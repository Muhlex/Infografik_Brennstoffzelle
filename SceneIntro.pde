class SceneIntro extends Scene {

  PImage illustration;

  SceneIntro() {
    super();

    illustration = loadImage("img/png/start_illustration.png");
    //Button testButton = new Button(10,10,300,40);
    //elements.add(testButton);
  }

  @Override
  void draw() {
    super.draw();

    // Static Start-Screen

    // Heading Background
    pushStyle();

    fill(colPrimary);
    rect(0, 184, 591, 171);
    beginShape();
    vertex(591, 184);
    vertex(591, 355);
    vertex(738, 133);
    endShape(CLOSE);

    popStyle();

    // Heading Text
    pushStyle();

    fill(colBright);
    textFont(fontHeading);
    textAlign(LEFT, TOP);
    textLeading(fontHeadingSize * defaultLineHeight);
    String text = "Was macht die Brennstoffzelle so umweltfreundlich, und wie genau funktioniert sie überhaupt?";
    text(text, 32, 205, 543, 132);

    popStyle();

    // Footnote
    pushStyle();

    fill(colBright);
    textFont(fontHeading);
    textAlign(LEFT, TOP);
    textLeading(fontHeadingSize * defaultLineHeight);
    String text = "Was macht die Brennstoffzelle so umweltfreundlich, und wie genau funktioniert sie überhaupt?";
    text(text, 32, 205, 543, 132);

    popStyle();

    // Illustration
    image(illustration, 409, 292, 612, 503);
  }
}