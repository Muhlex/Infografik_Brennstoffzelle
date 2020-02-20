class ButtonIcon extends Button {

  PShape shapeIcon;
  PShape shapeIconDisabled;
  PGraphics icon;
  PGraphics iconDisabled;

  boolean isDisabled;

  ButtonIcon(int x, int y, int w, int h, PShape shapeIcon, PShape shapeIconDisabled, ButtonCallback callback) {
    super(x, y, w, h);

    this.shapeIcon = shapeIcon;

    this.callback = callback;

    // Convert Shapes to raster images, to allow for setting their transparency
    this.icon = createGraphics(int(shapeIcon.width), int(shapeIcon.height));
    icon.beginDraw();
    icon.shape(shapeIcon);
    icon.endDraw();

    this.iconDisabled = createGraphics(int(shapeIconDisabled.width), int(shapeIconDisabled.height));
    iconDisabled.beginDraw();
    iconDisabled.shape(shapeIconDisabled);
    iconDisabled.endDraw();

    this.isDisabled = false;
  }

  void disable() {
    isDisabled = true;
  }

  void enable() {
    isDisabled = false;
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

    if (this.isHovered) {
      tint(255, 0.8);
    }

    imageMode(CENTER);
    if (isDisabled) {
      image(iconDisabled, x + w / 2, y + h / 2);
    }
    else {
      image(icon, x + w / 2, y + h / 2);
    }

    popStyle();
  }
}