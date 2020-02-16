class ButtonNavigation extends Button {

  int paddingX;
  String label;
  boolean isActive;
  int destinationScene;

  ButtonNavigation(int x, int y, int paddingX, String label, int destinationScene) {
    super(x, y, 32, 32);
    this.x = x;
    this.y = y;
    this.paddingX = paddingX;
    this.label = label;
    this.destinationScene = destinationScene;

    pushStyle();

    this.setFontStyle(false);
    this.w = int(textWidth(label)) + paddingX * 2;
    this.h = int(g.textLeading);

    popStyle();

    this.isActive = false;
  }

  @Override
  void onClick() {
    currentScene = this.destinationScene;
  }

  @Override
  void draw() {
    // Update Active Bar
    this.isActive = (currentScene == destinationScene);

    // Display
    if (this.isActive) {
      pushStyle();

      fill(colAccent);
      rect(this.x + this.paddingX, this.y + this.h - 14, this.w - this.paddingX * 2, 4);

      popStyle();
    }

    pushStyle();

    setFontStyle(this.isHovered);
    text(this.label, this.x + this.paddingX, this.y);

    popStyle();
  }

  void setFontStyle(boolean useHoverStyle) {
    if (useHoverStyle) {
      fill(colPrimary);
    }
    else {
      fill(colText);
    }
    textFont(fontNavigation);
    textAlign(LEFT, TOP);
  }
}