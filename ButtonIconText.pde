class ButtonIconText extends ButtonIcon {

  String label;

  ButtonIconText(int x, int y, int h, PShape shapeIcon, String label, ButtonCallback callback) {
    super(x, y, 0, h, shapeIcon, shapeIcon, callback);

    this.label = label;
    pushStyle();

    setFontStyle();
    this.w = h + int(textWidth(label));

    popStyle();
  }

  void setFontStyle() {
    if (isHovered) {
      fill(colText, 0.8);
    }
    else {
      fill(colText);
    }
    textFont(fontMini);
    textAlign(LEFT, CENTER);
  }

  @Override
  void draw() {
    pushStyle();

    if (this.isHovered) {
      tint(255, 0.8);
    }

    imageMode(CENTER);
    if (isDisabled) {
      image(iconDisabled, x + h / 2, y + h / 2);
    }
    else {
      image(icon, x + h / 2, y + h / 2);
    }

    setFontStyle();
    text(label, x + h, (y + h / 2) - 3);

    popStyle();
  }
}