class ButtonIcon extends Button {

  PShape icon;

  ButtonIcon(int x, int y, int w, int h, PShape icon, ButtonCallback callback) {
    super(x, y, w, h);

    this.icon = icon;

    this.callback = callback;
  }

  @Override
  void onClick(boolean insideElement) {
    if (insideElement) {
      callback.onClick();
    }
  }

  @Override
  void draw() {
    pushStyle();

    shapeMode(CENTER);
    shape(icon, x + w / 2, y + h / 2);

    popStyle();
  }
}