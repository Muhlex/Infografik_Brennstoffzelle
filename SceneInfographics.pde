class SceneInfographics extends Scene {

  // Easing Function Constants
  final int EASEIN    = 0;
  final int EASEOUT   = 1;
  final int EASEINOUT = 2;

  PShape illustrationBG;
  PShape shapeH2;
  PShape shapeElectron;

  float fadeTime = 0.05;

  SceneInfographics() {
    super();

    illustrationBG = loadShape("img/svg/infographics_bg.svg");
    shapeH2        = loadShape("img/svg/movables/h2.svg");
    shapeElectron  = loadShape("img/svg/movables/electron.svg");
  }

  void drawElement(float timestamp, PShape shape, PVector[] posKeyframes, float[] timeKeyframes, int easing) {

    float scale = 1.0;

    switch (easing) {
      case EASEIN:
        scale = easeInOut(mapConstrainNormalize(timestamp, timeKeyframes[0], timeKeyframes[0] + fadeTime));
      break;

      case EASEOUT:
        scale = easeInOut(1.0 - mapConstrainNormalize(timestamp, timeKeyframes[timeKeyframes.length-1] - fadeTime, timeKeyframes[timeKeyframes.length-1]));
      break;

      case EASEINOUT:
        scale = easeInOut(min(mapConstrainNormalize(timestamp, timeKeyframes[0], timeKeyframes[0] + fadeTime), 1.0 - mapConstrainNormalize(timestamp, timeKeyframes[timeKeyframes.length-1] - fadeTime, timeKeyframes[timeKeyframes.length-1])));
      break;
    }

    PVector pos = new PVector();

    for (int i = 0; i < timeKeyframes.length - 1; i++) {
      if (timestamp > timeKeyframes[i] && timestamp <= timeKeyframes[i+1]) {

        float lerpAmt = mapConstrainNormalize(timestamp, timeKeyframes[i], timeKeyframes[i+1]);
        pos = posKeyframes[i].lerp(posKeyframes[i+1], easeInOut(lerpAmt));

      }
    }

    if (timestamp >= timeKeyframes[0] && timestamp <= timeKeyframes[timeKeyframes.length-1]) {
      pushStyle();

      shapeMode(CENTER);
      shape(
        shape,
        pos.x,
        pos.y,
        shape.width * scale,
        shape.height * scale
      );

      popStyle();
    }
  }

  @Override
  void draw() {
    super.draw();

    // STATIC ELEMENTS (these do not get pushed into the elements ArrayList)

    shape(illustrationBG, 197, 201, 646, 364);

    float timestamp = float(millis()) / 10000 % 1;

    drawElement(
      timestamp,
      shapeH2,
      new PVector[] {
        new PVector(-54, 420),
        new PVector(232, 420)
      },
      new float[] {
        0.0,
        0.6
      },
      EASEOUT
    );

    drawElement(
      timestamp,
      shapeElectron,
      new PVector[] {
        new PVector(210, 420),
        new PVector(232, 203),
        new PVector(808, 203)
      },
      new float[] {
        0.5,
        0.6,
        1.0
      },
      EASEINOUT
    );
  }
}