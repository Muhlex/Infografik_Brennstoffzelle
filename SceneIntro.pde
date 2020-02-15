class SceneIntro extends Scene {

  PImage illustration;

  SceneIntro() {
    super();

    illustration = loadImage("img/png/start_illustration.png");
  }

  @Override
  void draw() {
    super.draw();

    // Static Start-Screen
    String buffer;
    IntList highlightedWords;

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
    highlightedWords = new IntList();
    highlightedWords.append(3);
    highlightedWords.append(5);
    textExt(buffer, 32, 205, 543, highlightedWords, fontHeadingBold);

    popStyle();

    // Footnote
    pushStyle();

    fill(colText);
    textFont(fontBody);
    textAlign(LEFT, TOP);
    textLeading(fontBodySize * defaultLineHeight);

    buffer = "Felix Bastian\nInteraktive Lehrmedien\nProf. Ralph Tille\nWintersemester 2019/-20";
    highlightedWords = new IntList();
    highlightedWords.append(0);
    highlightedWords.append(1);
    textExt(buffer, 32, 664, 320, highlightedWords, fontBodyBold);

    popStyle();

    // Illustration
    image(illustration, 409, 292, 612, 503);

    // Navigation Hints
    pushStyle();

    fill(colText);
    textFont(fontBodyBold);
    textAlign(LEFT, TOP);

    text("Sag’s mir!", 743, 91);

    text("Weiß ich!", 939, 91);

    popStyle();
  }
}