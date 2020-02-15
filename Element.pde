abstract class Element {

  int x, y;
  int w, h;
  boolean isHovered;

  abstract void draw();

  void onClick() {};
}