class InputText extends Element {

  int size;
  String value;
  InputTextCallback callback;

  boolean hasFocus;
  boolean ignoreKeys;
  boolean isDisabled;
  boolean isCorrect;

  int paddingX;
  int paddingY;

  InputText(int x, int y, int size, InputTextCallback callback) {
    this(x, y, size, "", callback);
  }
  InputText(int x, int y, int size, String initialValue, InputTextCallback callback) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.value = initialValue;
    this.callback = callback;
    this.hasFocus = false;
    this.ignoreKeys = false;
    this.isDisabled = false;
    this.isCorrect = false;
    this.paddingX = 4;
    this.paddingY = 4;

    pushStyle();

    this.setFontStyle();
    this.w = int(getMaxLetterWidth() * size + (defaultStrokeWeight * 2) + (paddingX * 2));
    this.h = int(g.textLeading) + (paddingY * 2);

    popStyle();
  }

  void setFontStyle() {
    if (isDisabled) {
      if (isCorrect) {
        fill(colAccentDark);
      } else {
        fill(colRed);
      }
    } else {
      fill(colText);
    }

    textFont(fontLead);
    textAlign(LEFT, TOP);
  }

  @Override
  void onClick(boolean insideElement) {
    if (insideElement && ! isDisabled) {
      hasFocus = true;
    }
    else {
      hasFocus = false;
    }
  }

  @Override
  void onKeyPressed() {

    if (isDisabled) {
      return;
    }

    if (keyCode == CONTROL) {
      ignoreKeys = true;
    }

    if (hasFocus && ! ignoreKeys) {
      switch (key) {
        case CODED:
        case TAB:
        case ENTER:
        case RETURN:
        case ESC:
        case DELETE:
        break;

        case BACKSPACE:
          if (value.length() > 0) {
            value = value.substring(0, value.length() - 1);
            callback.onChange(value);
          }
        break;

        default:
          if (value.length() < size) {
            value += key;
            callback.onChange(value);
          }
        break;
      }
    }
  }

  @Override
  void onKeyReleased() {
    if (keyCode == CONTROL) {
      ignoreKeys = false;
    }
  }

  void draw() {
    // Background
    pushStyle();

    noFill();

    if (hasFocus) {
      stroke(colText);
    }
    else {
      stroke(colPrimary);
    }

    strokeWeight(defaultStrokeWeight);

    // Set stroke on the inside(!) of the rectangle
    rect(
      this.x + (defaultStrokeWeight / 2),
      this.y + (defaultStrokeWeight / 2),
      this.w - (defaultStrokeWeight),
      this.h - (defaultStrokeWeight)
    );

    popStyle();

    // Text

    pushStyle();

    setFontStyle();

    text(value, this.x + defaultStrokeWeight + paddingX, this.y + defaultStrokeWeight + paddingY);


    popStyle();

    // Text Cursor
    if (hasFocus && (millis() % 1000 < 500)) {
      pushStyle();

      noFill();

      stroke(colPrimary);
      strokeWeight(2);

      pushStyle();
      setFontStyle();
      float cursorXPos = this.x + textWidth(value) + defaultStrokeWeight + 2;
      popStyle();

      line(
        cursorXPos + 3,
        this.y + defaultStrokeWeight + paddingX + 2,
        cursorXPos + 3,
        this.y + this.h - defaultStrokeWeight - paddingY - 2
      );

      popStyle();
    }
  }
}

interface InputTextCallback {
  void onChange(String value);
}