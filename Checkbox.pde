class Checkbox extends Button {

  int visualWidth;
  PShape iconCross;

  boolean disabled;
  boolean checked;
  int value;
  CheckboxCallback callback;

  Checkbox(int x, int y, int w, int h, int visualWidth, int value, CheckboxCallback callback) {
    super(x, y, w, h);
    this.visualWidth = visualWidth;
    this.callback = callback;
    this.value = value;

    this.iconCross = loadShape("img/svg/cross.svg");
  }

  @Override
  void onClick() {
    this.checked = !this.checked;
    callback.onChange(this.value, this.checked);
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
      shape(iconCross, this.x, this.y, this.visualWidth, this.h);
    }
  }
}

interface CheckboxCallback {
  void onChange(int value, boolean checked);
}