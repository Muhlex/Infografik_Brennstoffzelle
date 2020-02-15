class Button extends Element {
  // color bgColor;
  // color bgColorHover;
  // color bgColorMousedown;
  PShape buttonShape;

  Button(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;

    buttonShape = createShape(RECT, x, y, w, h);
  }

  @Override
  void onClick() {
    println("Button clicked.");
  }

  void draw() {
    shape(buttonShape);
  }
}