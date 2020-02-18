class SceneInfographics extends Scene {

  PShape illustrationBG;
  PShape shapeH2;

  float fadeTime = 0.05;

  SceneInfographics() {
    super();

    illustrationBG = loadShape("img/svg/infographics_bg.svg");
    shapeH2 = loadShape("img/svg/movables/h2.svg");
  }

  void drawH2(float time) {
    PVector posStart = new PVector(-18, 300);
    PVector posEnd   = new PVector(183, 346);
    float localStart = 0;
    float localEnd   = 0.5;

    float scale = easeInOut(min(mapConstrainNormalize(time, localStart, localStart + fadeTime), 1.0 - mapConstrainNormalize(time, localEnd - fadeTime, localEnd)));

    float normalizedTime  = mapConstrainNormalize(time, localStart, localEnd);

    PVector pos = posStart.lerp(posEnd, easeInOut(normalizedTime));

    if (time >= localStart && time <= localEnd) {
      pushStyle();

      shapeMode(CENTER);
      shape(
        shapeH2,
        pos.x,
        pos.y,
        shapeH2.width * scale,
        shapeH2.height * scale
      );

      popStyle();
    }
  }

  @Override
  void draw() {
    super.draw();

    // STATIC ELEMENTS (these do not get pushed into the elements ArrayList)

    shape(illustrationBG, 197, 201, 646, 364);

    float time = float(millis()) / 10000 % 1;
    drawH2(time);
  }
}