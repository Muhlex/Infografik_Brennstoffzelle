class Checkbox extends Button {

  int visualWidth;
  PShape[] icon;
  int currIcon;

  boolean disabled;
  boolean checked;
  int value;
  CheckboxCallback callback;

  Checkbox(int x, int y, int w, int h, int visualWidth, int value, CheckboxCallback callback) {
    super(x, y, w, h);
    this.visualWidth = visualWidth;
    this.callback = callback;
    this.value = value;
    this.disabled = false;
    this.checked = false;

    this.icon = new PShape[4];
    this.icon[0] = loadShape("img/svg/cross.svg");
    this.icon[1] = loadShape("img/svg/cross_red.svg");
    this.icon[2] = loadShape("img/svg/checkmark.svg");
    this.icon[3] = loadShape("img/svg/checkmark_green.svg");

    this.currIcon = 0;
  }

  @Override
  void onClick(boolean insideElement) {
    if (insideElement) {
      if (! this.disabled) {
        this.checked = !this.checked;
        callback.onChange(this.value, this.checked);
      }
    }
  }

  @Override
  void draw() {

    pushStyle();

    noFill();
    stroke(colPrimary);
    strokeWeight(defaultStrokeWeight);

    // Set stroke on the inside(!) of the rectangle
    rect(
      this.x + (defaultStrokeWeight / 2),
      this.y + (defaultStrokeWeight / 2),
      this.visualWidth - (defaultStrokeWeight),
      this.h - (defaultStrokeWeight)
    );

    popStyle();

    if (this.checked) {
      shape(icon[currIcon], this.x, this.y, this.visualWidth, this.h);
    }
  }
}

interface CheckboxCallback {
  void onChange(int value, boolean checked);
}