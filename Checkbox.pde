class Checkbox extends Button {

  int visualWidth;
  PShape iconCross;

  int value;
  boolean disabled;
  boolean checked;

  Checkbox(int x, int y, int w, int h, int visualWidth, int value) {
    super(x, y, w, h);
    this.visualWidth = visualWidth;
    this.value = value;

    this.iconCross = loadShape("img/svg/cross.svg");
  }

  @Override
  void onClick() {
    this.checked = !this.checked;
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