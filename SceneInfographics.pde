class SceneInfographics extends Scene {

  // Easing Function Constants
  final int NONE      = 0;
  final int EASEIN    = 1;
  final int EASEOUT   = 2;
  final int EASEINOUT = 3;

  PShape illustrationBG;
  PShape lightbulbOff;
  PShape lightbulbOn;

  PShape shapeH2;
  PShape shapeElectron;
  PShape shapeHPlus;
  PShape shapeO2;
  PShape shapeO;
  PShape shapeO2MinusWElectrons;
  PShape shapeH2O;

  float fadeTime;

  int currStep;
  Area[] stepHighlightBounds;

  float debugSKIP = 0;

  SceneInfographics() {
    super();

    illustrationBG         = loadShape("img/svg/infographics_bg.svg");
    lightbulbOff           = loadShape("img/svg/bulb.svg");
    lightbulbOn            = loadShape("img/svg/bulb_lit.svg");
    shapeH2                = loadShape("img/svg/movables/h2.svg");
    shapeElectron          = loadShape("img/svg/movables/electron.svg");
    shapeHPlus             = loadShape("img/svg/movables/h_plus.svg");
    shapeO2                = loadShape("img/svg/movables/o2.svg");
    shapeO                 = loadShape("img/svg/movables/o.svg");
    shapeO2MinusWElectrons = loadShape("img/svg/movables/o2_minus_w_electrons.svg");
    shapeH2O               = loadShape("img/svg/movables/h2o.svg");

    fadeTime = 0.03;
    currStep = 0;
    stepHighlightBounds = new Area[] {
      new Area(300, 148, 850, 240)
    };
  }

  @Override
  void onKeyPressed() {
    if (key == 'm') {
      debugSKIP += 100;
    } else if (key == 'M') {
      debugSKIP += 600;
    }
  }

  void drawMoveable(float timestamp, PShape shape, PVector[] posKeyframes, float[] timeKeyframes, int easing) {
    drawMoveable(timestamp, shape, posKeyframes, timeKeyframes, easing, null);
  }
  void drawMoveable(float timestamp, PShape shape, PVector[] posKeyframes, float[] timeKeyframes, int easing, Area highlightBounds) {

    PVector pos = new PVector();

    for (int i = 0; i < timeKeyframes.length - 1; i++) {
      if (timestamp >= timeKeyframes[i] && timestamp <= timeKeyframes[i+1]) {

        float lerpAmt = mapConstrainNormalize(timestamp, timeKeyframes[i], timeKeyframes[i+1]);
        pos = posKeyframes[i].lerp(posKeyframes[i+1], easeInOut(lerpAmt));

      }
    }

    float scale = 1.0;

    switch (easing) {
      case EASEIN:
        scale *= easeInOut(mapConstrainNormalize(timestamp, timeKeyframes[0], timeKeyframes[0] + fadeTime));
      break;

      case EASEOUT:
        scale *= easeInOut(1.0 - mapConstrainNormalize(timestamp, timeKeyframes[timeKeyframes.length-1] - fadeTime, timeKeyframes[timeKeyframes.length-1]));
      break;

      case EASEINOUT:
        scale *= easeInOut(min(mapConstrainNormalize(timestamp, timeKeyframes[0], timeKeyframes[0] + fadeTime), 1.0 - mapConstrainNormalize(timestamp, timeKeyframes[timeKeyframes.length-1] - fadeTime, timeKeyframes[timeKeyframes.length-1])));
      break;
    }

    float highlightOpacity = 1.0;

    if (highlightBounds != null) {

      FloatList distancesToEdges = new FloatList();
      if (pos.x >= highlightBounds.x1) {distancesToEdges.append(pos.x - highlightBounds.x1); }
      if (pos.y >= highlightBounds.y1) {distancesToEdges.append(pos.y - highlightBounds.y1); }
      if (pos.x <= highlightBounds.x2) {distancesToEdges.append(highlightBounds.x2 - pos.x); }
      if (pos.y <= highlightBounds.y2) {distancesToEdges.append(highlightBounds.y2 - pos.y); }

      // If is inside highlightBounds and between 0 and 25px from any edge
      if (distancesToEdges.size() >= 4 && distancesToEdges.min() <= 25) {
        highlightOpacity = easeInOut(map(distancesToEdges.min(), 0, 25, 0, 1));
      }
      // If not inside highlightBounds
      else if (distancesToEdges.size() < 4) {
        highlightOpacity = 0.0;
      }
    }

    if (timestamp >= timeKeyframes[0] && timestamp <= timeKeyframes[timeKeyframes.length-1]) {
      pushStyle();

      shapeMode(CENTER);

      if (highlightOpacity > 0.01) {
        // Colored Shape
        shape(
          shape,
          pos.x,
          pos.y,
          shape.width * scale,
          shape.height * scale
        );
      }

      if (highlightOpacity < 0.99) {

        // White outlined Shape
        shape.disableStyle();
        fill(color(255, 1.0 - highlightOpacity));
        stroke(color(colText, 1.0 - highlightOpacity));
        strokeWeight(1.5);

        shape(
          shape,
          pos.x,
          pos.y,
          shape.width * scale,
          shape.height * scale
        );

        shape.enableStyle();
      }

      popStyle();
    }
  }

  @Override
  void draw() {
    super.draw();

    // STATIC ELEMENTS (these do not get pushed into the elements ArrayList)

    shape(illustrationBG, 197, 201, 646, 364);

    float secondsPerCycle = 30;
    float timestamp = (debugSKIP + millis()) / (secondsPerCycle * 1000) % 1;

    if (timestamp * 12 % 1 > 0.5) {
      shape(lightbulbOff, 484, 97);
    }
    else {
      shape(lightbulbOn, 484, 97);
    }

    this.drawMoveables(timestamp);
    this.drawMoveables((timestamp + (2 / 3.0)) % 1);
    this.drawMoveables((timestamp + (2 / 3.0) * 2) % 1);
  }

  void drawMoveables(float timestamp) {
    // Electron 1
    drawMoveable(
      timestamp,
      shapeElectron,
      new PVector[] {
        new PVector(210, 420),
        new PVector(232, 203),
        new PVector(808, 203),
        new PVector(806, 294),
        new PVector(806, 294)
      },
      new float[] {
        0.055,
        0.18,
        0.34,
        0.45,
        0.465
      },
      EASEINOUT,
      stepHighlightBounds[0]
    );

    // Electron 2
    drawMoveable(
      timestamp,
      shapeElectron,
      new PVector[] {
        new PVector(254, 420),
        new PVector(232, 203),
        new PVector(808, 203),
        new PVector(766, 294),
        new PVector(766, 294)
      },
      new float[] {
        0.055,
        0.26,
        0.42,
        0.45,
        0.465
      },
      EASEINOUT,
      stepHighlightBounds[0]
    );

    // Electron 3
    drawMoveable(
      timestamp,
      shapeElectron,
      new PVector[] {
        new PVector(210, 420),
        new PVector(232, 203),
        new PVector(808, 203),
        new PVector(850, 294),
        new PVector(850, 294)
      },
      new float[] {
        0.215,
        0.34,
        0.50,
        0.61,
        0.625
      },
      EASEINOUT,
      stepHighlightBounds[0]
    );

    // Electron 4
    drawMoveable(
      timestamp,
      shapeElectron,
      new PVector[] {
        new PVector(254, 420),
        new PVector(232, 203),
        new PVector(808, 203),
        new PVector(810, 294),
        new PVector(810, 294)
      },
      new float[] {
        0.215,
        0.42,
        0.58,
        0.61,
        0.625
      },
      EASEINOUT,
      stepHighlightBounds[0]
    );

    // H-Plus 1
    drawMoveable(
      timestamp,
      shapeHPlus,
      new PVector[] {
        new PVector(210, 420),
        new PVector(268, 482),
        new PVector(448, 346),
        new PVector(576, 346),
        new PVector(701, 468),
        new PVector(701, 468)
      },
      new float[] {
        0.055,
        0.13,
        0.26,
        0.46,
        0.56,
        0.6
      },
      EASEINOUT
    );

    // H-Plus 2
    drawMoveable(
      timestamp,
      shapeHPlus,
      new PVector[] {
        new PVector(254, 420),
        new PVector(325, 530),
        new PVector(448, 490),
        new PVector(592, 490),
        new PVector(657, 468),
        new PVector(657, 468)
      },
      new float[] {
        0.055,
        0.13,
        0.33,
        0.45,
        0.56,
        0.6
      },
      EASEINOUT
    );

    // H-Plus 3
    drawMoveable(
      timestamp,
      shapeHPlus,
      new PVector[] {
        new PVector(210, 420),
        new PVector(268, 482),
        new PVector(448, 346),
        new PVector(576, 346),
        new PVector(701, 468),
        new PVector(701, 468)
      },
      new float[] {
        0.215,
        0.29,
        0.42,
        0.62,
        0.72,
        0.76
      },
      EASEINOUT
    );

    // H-Plus 4
    drawMoveable(
      timestamp,
      shapeHPlus,
      new PVector[] {
        new PVector(254, 420),
        new PVector(325, 530),
        new PVector(448, 490),
        new PVector(592, 490),
        new PVector(657, 468),
        new PVector(657, 468)
      },
      new float[] {
        0.215,
        0.29,
        0.49,
        0.61,
        0.72,
        0.76
      },
      EASEINOUT
    );

    // H2 1
    drawMoveable(
      timestamp,
      shapeH2,
      new PVector[] {
        new PVector(-54, 420),
        new PVector(232, 420),
        new PVector(232, 420)
      },
      new float[] {
        0.0,
        0.06,
        0.09
      },
      EASEOUT
    );

    // H2 2
    drawMoveable(
      timestamp,
      shapeH2,
      new PVector[] {
        new PVector(-54, 420),
        new PVector(232, 420),
        new PVector(232, 420)
      },
      new float[] {
        0.16,
        0.22,
        0.25
      },
      EASEOUT
    );

    // O (single) 1
    drawMoveable(
      timestamp,
      shapeO,
      new PVector[] {
        new PVector(786, 454),
        new PVector(786, 454),
        new PVector(786, 316),
        new PVector(786, 316)
      },
      new float[] {
        0.255,
        0.27,
        0.4,
        0.45
      },
      EASEIN
    );

    // O (single) 2
    drawMoveable(
      timestamp,
      shapeO,
      new PVector[] {
        new PVector(830, 454),
        new PVector(830, 454),
        new PVector(830, 316),
        new PVector(830, 316)
      },
      new float[] {
        0.255,
        0.27,
        0.56,
        0.61,
      },
      EASEIN
    );

    // O2-Minus w/ Electrons 1
    drawMoveable(
      timestamp,
      shapeO2MinusWElectrons,
      new PVector[] {
        new PVector(786, 311),
        new PVector(786, 311),
        new PVector(679, 455),
        new PVector(679, 455)
      },
      new float[] {
        0.45,
        0.46,
        0.53,
        0.6
      },
      EASEOUT
    );

    // O2-Minus w/ Electrons 2
    drawMoveable(
      timestamp,
      shapeO2MinusWElectrons,
      new PVector[] {
        new PVector(830, 311),
        new PVector(830, 311),
        new PVector(679, 455),
        new PVector(679, 455)
      },
      new float[] {
        0.61,
        0.62,
        0.69,
        0.76
      },
      EASEOUT
    );

    // O2
    drawMoveable(
      timestamp,
      shapeO2,
      new PVector[] {
        new PVector(1094, 394),
        new PVector(808,  454),
        new PVector(808,  454)
      },
      new float[] {
        0.2,
        0.26,
        0.29
      },
      EASEOUT
    );

    // H2O 1
    drawMoveable(
      timestamp,
      shapeH2O,
      new PVector[] {
        new PVector(679, 449),
        new PVector(679, 449),
        new PVector(679, 647)
      },
      new float[] {
        0.56,
        0.58,
        0.66
      },
      EASEIN
    );

    // H2O 2
    drawMoveable(
      timestamp,
      shapeH2O,
      new PVector[] {
        new PVector(679, 449),
        new PVector(679, 449),
        new PVector(679, 647)
      },
      new float[] {
        0.72,
        0.74,
        0.82
      },
      EASEIN
    );
  }
}