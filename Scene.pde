class Scene {
  ArrayList<Element> elements;

  Scene() {
    elements = new ArrayList<Element>();

    // Initialize Navigation
    Button[] buttonsNav = new Button[3];
    String[] buttonLabels = {"Start", "Infografik", "Quiz"};

    int currXPos = 591;

    for (int i = 0; i <= 2; i++) {
      buttonsNav[i] = new ButtonNavigation(currXPos, 42, 24, buttonLabels[i], i);
      elements.add(buttonsNav[i]);
      currXPos += buttonsNav[i].w;
    }
  }

  void onMousePressed() {
    ArrayList<Element> visibleElements = new ArrayList<Element>();
    for (Element e : elements) {
      if (! e.isHidden) {
        visibleElements.add(e);
      }
    }
    for (Element e: visibleElements) {
      if (isMouseInsideRect(e.x, e.y, e.x + e.w, e.y + e.h)) {
        e.onClick(true);
      }
      else {
        e.onClick(false);
      }
    }
  }

  void onKeyPressed() {
    for (Element e : elements) {
      if (! e.isHidden) {
        e.onKeyPressed();
      }
    }
  }

  void onKeyReleased() {
    for (Element e : elements) {
      if (! e.isHidden) {
        e.onKeyReleased();
      }
    }
  }

  void reset() {}

  void draw() {
    for (Element e : elements) {
      if (! e.isHidden) {
        e.isHovered = isMouseInsideRect(e.x, e.y, e.x + e.w, e.y + e.h);

        e.draw();
      }
    }

    // HEADER

    // Title
    pushStyle();

    noStroke();
    fill(colAccentDark);
    textFont(fontTitle);
    textAlign(LEFT, TOP);
    text("Die Brennstoffzelle", 30, 25);

    popStyle();
  }
}
