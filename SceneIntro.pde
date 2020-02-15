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
    String buffer;

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
    buffer = "Was macht die Brennstoffzelle so umweltfreundlich, und wie genau funktioniert sie überhaupt?";
    text(buffer, 32, 205, 543, 132);

    popStyle();

    // Footnote
    pushStyle();

    fill(colText);
    textFont(fontBody);
    textAlign(LEFT, TOP);
    textLeading(fontBodySize * defaultLineHeight);
    buffer = "Felix Bastian\nInteraktive Lehrmedien Prof. Ralph Tille Wintersemester 2019/-20";

    IntList boldWords = new IntList();
    boldWords.append(0);
    boldWords.append(1);
    textExt(buffer, 32, 664, defaultLineHeight, 320, boldWords, fontBodyBold);
    //text(buffer, 32, 664, 320, 500);

    popStyle();

    // Illustration
    image(illustration, 409, 292, 612, 503);
  }
}