abstract class Element {

  int x, y;
  int w, h;
  boolean isHovered;
  boolean isHidden;

  abstract void draw();

  void onClick(boolean insideElement) {};

  void onMouseDragged(boolean insideElement) {};

  void onKeyPressed() {};

  void onKeyReleased() {};

  void toggleVisibility() {
    this.isHidden = ! this.isHidden;
  }
  void hide() {
    this.isHidden = true;
  }
  void show() {
    this.isHidden = false;
  }
}