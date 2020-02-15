class Button extends Element {

  Button(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  @Override
  void onClick() {
    println("Button clicked.");
  }

  void draw() {
    pushStyle();

    fill(colPrimary);
    rect(x, y, w, h);

    popStyle();
  }
}