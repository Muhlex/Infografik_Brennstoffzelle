class ButtonNavigation extends Button {

  int paddingX;
  String label;
  boolean isActive;
  int destinationScene;

  ButtonNavigation(int x, int y, int paddingX, String label, int destinationScene) {
    super(x, y, paddingX * 2, 32); // TODO: do this differently?
    this.x = x;
    this.y = y;
    this.paddingX = paddingX;
    this.label = label;
    this.destinationScene = destinationScene;

    pushStyle();

    this.setFontStyle();
    this.w = int(textWidth(label)) + paddingX * 2;
    this.h = int(g.textLeading);
    println("textLeading: "+g.textLeading);

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
    pushStyle();

    setFontStyle();
    text(this.label, this.x + this.paddingX, this.y);

    popStyle();

    if (this.isActive) {
      pushStyle();

      fill(colAccent);
      rect(this.x + this.paddingX, this.y + this.h - 14, this.w - this.paddingX * 2, 4);

      popStyle();
    }
  }

  void setFontStyle() {
    fill(colText);
    textFont(fontNavigation);
    textAlign(LEFT, TOP);
  }
}