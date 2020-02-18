class SceneInfographics extends Scene {

  // Easing Function Constants
  final int NONE      = 0;
  final int EASEIN    = 1;
  final int EASEOUT   = 2;
  final int EASEINOUT = 3;

  PShape illustrationBG;

  PShape shapeH2;
  PShape shapeElectron;
  PShape shapeHPlus;
  PShape shapeO2;
  PShape shapeO;
  PShape shapeO2MinusWElectrons;
  PShape shapeH2O;

  float fadeTime = 0.03;

  SceneInfographics() {
    super();

    illustrationBG         = loadShape("img/svg/infographics_bg.svg");
    shapeH2                = loadShape("img/svg/movables/h2.svg");
    shapeElectron          = loadShape("img/svg/movables/electron.svg");
    shapeHPlus             = loadShape("img/svg/movables/h_plus.svg");
    shapeO2                = loadShape("img/svg/movables/o2.svg");
    shapeO                 = loadShape("img/svg/movables/o.svg");
    shapeO2MinusWElectrons = loadShape("img/svg/movables/o2_minus_w_electrons.svg");
    shapeH2O               = loadShape("img/svg/movables/h2o.svg");
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

    float secondsPerCycle = 20;
    float timestamp = millis() / (secondsPerCycle * 1000) % 1;

    // H2
    drawElement(
      timestamp,
      shapeH2,
      new PVector[] {
        new PVector(-54, 420),
        new PVector(232, 420)
      },
      new float[] {
        0.0,
        0.2
      },
      EASEOUT
    );

    // Electron 1
    drawElement(
      timestamp,
      shapeElectron,
      new PVector[] {
        new PVector(210, 420),
        new PVector(232, 203),
        new PVector(808, 203),
        new PVector(786, 334)
      },
      new float[] {
        0.2,
        0.3,
        0.6,
        0.7
      },
      EASEINOUT
    );

    // Electron 2
    drawElement(
      timestamp,
      shapeElectron,
      new PVector[] {
        new PVector(254, 420),
        new PVector(232, 203),
        new PVector(808, 203),
        new PVector(786, 334)
      },
      new float[] {
        0.2,
        0.4,
        0.7,
        0.8
      },
      EASEINOUT
    );

    // H-Plus 1
    drawElement(
      timestamp,
      shapeHPlus,
      new PVector[] {
        new PVector(210, 420),
        new PVector(210, 485),
        new PVector(467, 490),
        new PVector(696, 448)
      },
      new float[] {
        0.2,
        0.4,
        0.5,
        0.9
      },
      EASEINOUT
    );

    // H-Plus 2
    drawElement(
      timestamp,
      shapeHPlus,
      new PVector[] {
        new PVector(254, 420),
        new PVector(254, 485),
        new PVector(456, 346),
        new PVector(696, 448)
      },
      new float[] {
        0.2,
        0.4,
        0.5,
        0.9
      },
      EASEINOUT
    );

    // O2
    drawElement(
      timestamp,
      shapeO2,
      new PVector[] {
        new PVector(1094, 394),
        new PVector(808,  394)
      },
      new float[] {
        0.5,
        0.6
      },
      EASEOUT
    );

    // O (single) 1
    drawElement(
      timestamp,
      shapeO,
      new PVector[] {
        new PVector(786, 394),
        new PVector(786, 334)
      },
      new float[] {
        0.6,
        0.7
      },
      EASEINOUT
    );

    // O (single) 2
    drawElement(
      timestamp,
      shapeO,
      new PVector[] {
        new PVector(830, 394),
        new PVector(930, 345)
      },
      new float[] {
        0.6,
        0.7
      },
      EASEINOUT
    );

    // O2 Minus w/ Electrons
    drawElement(
      timestamp,
      shapeO2MinusWElectrons,
      new PVector[] {
        new PVector(788, 329),
        new PVector(697, 443)
      },
      new float[] {
        0.8,
        0.9
      },
      EASEINOUT
    );

    // H2O
    drawElement(
      timestamp,
      shapeH2O,
      new PVector[] {
        new PVector(697, 414),
        new PVector(697, 647)
      },
      new float[] {
        0.9,
        1.0
      },
      EASEINOUT
    );

  }
}