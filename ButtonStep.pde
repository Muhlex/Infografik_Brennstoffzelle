class ButtonStep extends Button {

  int relativeValue;
  int maxValue;
  PShape shapeArrow;

  ButtonStep(int x, int y, int w, int h, int relativeValue, int maxValue) {
    super(x, y, w, h);

    this.relativeValue = relativeValue;
    this.maxValue = maxValue;

    // Load left / right arrow
    if (this.relativeValue <= 0) {
      shapeArrow = loadShape("img/svg/arrow_left.svg");
    } else {
      shapeArrow = loadShape("img/svg/arrow_right.svg");
    }
  }

  @Override
  void onClick(boolean insideElement) {
    if (insideElement) {
      if (currStep + relativeValue >= 0 && currStep + relativeValue <= maxValue) {
        currStep += relativeValue;
      }
    }
  }

  @Override
  void draw() {
    if ((relativeValue < 0 && currStep == 0) || (relativeValue > 0 && currStep == maxValue)) {
      return;
    }
    pushStyle();

    if (this.isHovered) {
      shapeArrow.disableStyle();
      fill(color(colBright), 0.8);
    }

    shapeMode(CENTER);
    shape(shapeArrow, x + w/2, y + h/2);

    if (this.isHovered) {
      shapeArrow.enableStyle();
    }

    popStyle();
  }
}