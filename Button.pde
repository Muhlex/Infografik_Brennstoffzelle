class Button extends Element {

  ButtonCallback callback;

  Button(int x, int y, int w, int h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  @Override
  void onClick(boolean insideElement) {
    if (insideElement) {
      callback.onClick();
    }
  }

  void draw() {
    pushStyle();

    fill(colPrimary);
    rect(x, y, w, h);

    popStyle();
  }
}

interface ButtonCallback {
  void onClick();
}