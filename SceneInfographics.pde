class SceneInfographics extends Scene {

  // Easing Function Constants
  final int NONE      = 0;
  final int EASEIN    = 1;
  final int EASEOUT   = 2;
  final int EASEINOUT = 3;
  final int MAX_INT   = 2147483647;

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

  PShape shapeSpeed;
  PShape shapeSpeedDisabled;
  PShape shapeVolume;
  PShape shapeVolumeDisabled;

  ButtonStep prevButton;
  ButtonStep nextButton;

  ButtonIcon muteButton;
  InputSlider volumeSlider;

  ButtonIcon pauseButton;
  InputSlider speedSlider;

  float fadeTime;

  String[] stepDescriptions;
  Area[] stepHighlightBounds;

  float volume;
  float prevVolume;
  boolean isMuted;

  float speed;
  float prevSpeed;
  boolean isPaused;

  float time;
  int prevTime;
  int currTime;
  float[] previousTimestamps;
  int[] seeds;

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

    volume = 1.0;
    prevVolume = speed;
    isMuted = false;

    speed = 1.0;
    prevSpeed = speed;
    isPaused = false;

    time = 0.0;
    prevTime = millis();
    currTime = millis();
    previousTimestamps = new float[3];
    seeds = new int[] {
      int(random(MAX_INT)),
      int(random(MAX_INT)),
      int(random(MAX_INT))
    };

    stepDescriptions = new String[] {
      "Die Brennstoffzelle besteht grundlegend aus zwei \bElektroden (Anode und Kathode). " +
      "Das sind miteinander verbundene, elektrische Leiter. " +
      "Zwischen den Elektroden befindet sich eine sogenannte \bElektrolytmembran.",

      "Zuerst wird \bWasserstoff in die Brennstoffzelle geleitet. Dieser wird auf der Anodenseite \boxidiert. " +
      "Das heißt, ihm werden negativ geladene \bElektronen entzogen. " +
      "Übrig bleiben positive \bWasserstoffionen – auch \bProtonen genannt.",

      "Die \bElektronen fließen über einen Leiter zur Kathode. " +
      "Dabei entsteht \belektrische \bSpannung, also Strom.",

      "Zeitgleich diffundieren die Wasserstoffionen \b(Protonen) durch die Elektrolytmembran in Richtung Kathode. " +
      "Die Membran ist \bnur \bfür \bProtonen \bdurchlässig, weshalb die Elektronen den äußeren Stromkreis durchlaufen.",

      "An der Kathode angekommen, vereinen sich die \bElektronen mit \bSauerstoffmolekülen, die durch einen Luftstrom zugeführt werden, zu \bSauerstoffionen. " +
      "Dies nennt man \bReduktion.",

      "Die Sauerstoffionen treffen anschließend auf die Protonen und reagieren zu \bWasser. " +
      "Die einzige \bEmission einer Brennstoffzelle ist somit H2O.",

      "So funktioniert die \bBrennstoffzelle.\n"+
      "Wenn Du dich jetzt fit fühlst, kannst du dich am \bQuiz versuchen!\n\n" +
      "\bFun \bFact: Die CO"+sub2+"-Bilanz bei der Herstellung eines Brennstoffzellenfahrzeugs ist nur etwa 50% so hoch, wie bei einem klassischen Elektroauto. "
      //"Da die chemisch gebundene Energie jedoch nur mit einem Wirkungsgrad von bis zu 60% in elektrische Energie umgewandelt werden kann, ist die Gesamtbilanz " +
      //"(unter Einbezug der Betriebsphase) schlechter."
    };

    stepHighlightBounds = new Area[] {
      null, // First step does not have any moving elements
      new Area(-80, 220, 284, 554),
      new Area(208, 182, 832, 254),
      new Area(256, 234, 624, 554),
      new Area(742, 182, width + 80, 554),
      new Area(616, 254, 742, height),
      new Area(-80, -80, width + 80, height + 80)
    };

    prevButton = new ButtonStep(0,   604, 106, 176, -1, stepDescriptions.length-1);
    nextButton = new ButtonStep(934, 604, 106, 176,  1, stepDescriptions.length-1);
    elements.add(prevButton);
    elements.add(nextButton);

    shapeVolume = loadShape("img/svg/volume.svg");
    shapeVolumeDisabled = loadShape("img/svg/volume_disabled.svg");

    muteButton = new ButtonIcon(119, 664, 48, 48, shapeVolume, shapeVolumeDisabled, new ButtonCallback() {
      void onClick() {
        if (isMuted) {
          muteButton.enable();
          volume = prevVolume;
          isMuted = false;
        }
        else {
          muteButton.disable();
          prevVolume = volume;
          volume = 0.0;
          isMuted = true;
        }
      }
    });
    elements.add(muteButton);

    volumeSlider = new InputSlider(176, 672, 128, 32, 0.0, 1.0, 0.75, new InputSliderCallback(){
      void onChange(float value) {
        volume = value;
        if (isPaused) {
          muteButton.enable();
          isMuted = false;
        }
      }
    });
    elements.add(volumeSlider);

    shapeSpeed = loadShape("img/svg/speed.svg");
    shapeSpeedDisabled = loadShape("img/svg/speed_disabled.svg");

    pauseButton = new ButtonIcon(119, 712, 48, 48, shapeSpeed, shapeSpeedDisabled, new ButtonCallback() {
      void onClick() {
        if (isPaused) {
          pauseButton.enable();
          speed = prevSpeed;
          isPaused = false;
        }
        else {
          pauseButton.disable();
          prevSpeed = speed;
          speed = 0.0;
          isPaused = true;
        }
      }
    });
    elements.add(pauseButton);

    speedSlider = new InputSlider(176, 720, 128, 32, 0.0, 2.4, 1.0, new InputSliderCallback(){
      void onChange(float value) {
        speed = value;
        if (isPaused) {
          pauseButton.enable();
          isPaused = false;
        }
      }
    });
    elements.add(speedSlider);
  }

  @Override
  void onKeyPressed() {
    super.onKeyPressed();
    if (key == 'm') {
      speed += 0.1;
    }
    if (key == 'n') {
      speed -= 0.1;
    }

    switch (keyCode) {
      case RIGHT:
      case UP:
        if (currStep < stepDescriptions.length - 1) {
          currStep++;
        };
      break;

      case LEFT:
      case DOWN:
        if (currStep > 0) {
          currStep--;
        };
      break;
    }

    if (Character.getNumericValue(key) >= 1 && Character.getNumericValue(key) <= stepDescriptions.length) {
      currStep = Character.getNumericValue(key) - 1;
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

    float highlightOpacity = 0.0;

    if (highlightBounds != null) {

      highlightOpacity = 1.0;

      FloatList distancesToEdges = new FloatList();
      if (pos.x >= highlightBounds.x1) {distancesToEdges.append(pos.x - highlightBounds.x1); }
      if (pos.y >= highlightBounds.y1) {distancesToEdges.append(pos.y - highlightBounds.y1); }
      if (pos.x <= highlightBounds.x2) {distancesToEdges.append(highlightBounds.x2 - pos.x); }
      if (pos.y <= highlightBounds.y2) {distancesToEdges.append(highlightBounds.y2 - pos.y); }

      // If is inside highlightBounds and between 0 and 25px from any edge
      if (distancesToEdges.size() >= 4 && distancesToEdges.min() <= 20) {
        highlightOpacity = easeInOut(map(distancesToEdges.min(), 0, 20, 0, 1));
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
    // STATIC ELEMENTS (these do not get pushed into the elements ArrayList)

    shape(illustrationBG, 197, 201, 646, 364);

    float secondsPerCycle = 40;

    prevTime = currTime;
    currTime = millis();
    int millisPerDraw = currTime - prevTime;
    time += millisPerDraw / 28000.0 * speed;

    float timestamp = time % 1;

    float timestamps[] = new float[] {
      timestamp,
      (timestamp + (2 / 3.0)) % 1,
      (timestamp + (2 / 3.0) * 2) % 1
    };

    if (currStep == 0) {
      shape(lightbulbOff, 484, 97);
    }
    else {

      if (timestamp * 12 % 1 > 0.25) {
        shape(lightbulbOff, 484, 97);
      }
      else {
        shape(lightbulbOn, 484, 97);
      }

      for (int i = 0; i < timestamps.length; i++) {
        if (timestamps[i] - previousTimestamps[i] < 0) {
          seeds[i] = int(random(MAX_INT));
        }
        this.drawMoveables(timestamps[i], seeds[i]);
      }
    }

    for (int i = 0; i < timestamps.length; i++) {
      previousTimestamps[i] = timestamps[i];
    }

    // Background for lower panel
    rect(0, 604, width, 176);

    pushStyle();

    fill(colBright);
    textFont(fontBody);
    textAlign(LEFT, TOP);
    textLeading(fontBodySize * defaultLineHeight);

    textExt(stepDescriptions[currStep], 368, 628, 512, fontBodyBold);

    textFont(fontHeadingBold);

    text((currStep+1) + " / " + stepDescriptions.length, 193, 624);

    fill(colText);
    textFont(fontMini);
    textLeading(fontMiniSize * defaultLineHeight);

    text("Steuerung per Pfeiltasten oder Zahlentasten 1-" + stepDescriptions.length + " möglich", 32, 587);

    popStyle();

    super.draw();
  }

  void drawMoveables(float timestamp, int seed) {

    randomSeed(seed);

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
      stepHighlightBounds[currStep]
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
      stepHighlightBounds[currStep]
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
      stepHighlightBounds[currStep]
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
      stepHighlightBounds[currStep]
    );

    int hPlus1Hole = int(random(0,2));
    int hPlus2Hole = int(random(2,5));
    int hPlus3Hole = int(random(0,2));
    int hPlus4Hole = int(random(2,5));

    // H-Plus 1
    drawMoveable(
      timestamp,
      shapeHPlus,
      new PVector[] {
        new PVector(210, 420),
        new PVector(210, 484),
        new PVector(random(416, 472), 298 + (48 * hPlus1Hole)),
        new PVector(random(568, 616), 298 + (48 * hPlus1Hole)),
        new PVector(701, 468),
        new PVector(679, 460)
      },
      new float[] {
        0.055,
        0.13,
        random(0.26, 0.33),
        random(0.39, 0.46),
        0.56,
        0.59
      },
      EASEINOUT,
      stepHighlightBounds[currStep]
    );

    // H-Plus 2
    drawMoveable(
      timestamp,
      shapeHPlus,
      new PVector[] {
        new PVector(254, 420),
        new PVector(254, 524),
        new PVector(random(416, 472), 298 + (48 * hPlus2Hole)),
        new PVector(random(568, 616), 298 + (48 * hPlus2Hole)),
        new PVector(657, 468),
        new PVector(679, 460)
      },
      new float[] {
        0.055,
        0.13,
        random(0.26, 0.33),
        random(0.39, 0.46),
        0.56,
        0.59
      },
      EASEINOUT,
      stepHighlightBounds[currStep]
    );

    // H-Plus 3
    drawMoveable(
      timestamp,
      shapeHPlus,
      new PVector[] {
        new PVector(210, 420),
        new PVector(210, 484),
        new PVector(random(416, 472), 298 + (48 * hPlus3Hole)),
        new PVector(random(568, 616), 298 + (48 * hPlus3Hole)),
        new PVector(701, 468),
        new PVector(679, 460)
      },
      new float[] {
        0.215,
        0.29,
        random(0.42, 0.49),
        random(0.55, 0.62),
        0.72,
        0.75
      },
      EASEINOUT,
      stepHighlightBounds[currStep]
    );

    // H-Plus 4
    drawMoveable(
      timestamp,
      shapeHPlus,
      new PVector[] {
        new PVector(254, 420),
        new PVector(254, 524),
        new PVector(random(416, 472), 298 + (48 * hPlus4Hole)),
        new PVector(random(568, 616), 298 + (48 * hPlus4Hole)),
        new PVector(657, 468),
        new PVector(679, 460)
      },
      new float[] {
        0.215,
        0.29,
        random(0.42, 0.49),
        random(0.55, 0.62),
        0.72,
        0.75
      },
      EASEINOUT,
      stepHighlightBounds[currStep]
    );

    // H2 1
    drawMoveable(
      timestamp,
      shapeH2,
      new PVector[] {
        new PVector(-54, random(290, 490)),
        new PVector(232, 420),
        new PVector(232, 420)
      },
      new float[] {
        0.0,
        0.06,
        0.09
      },
      EASEOUT,
      stepHighlightBounds[currStep]
    );

    // H2 2
    drawMoveable(
      timestamp,
      shapeH2,
      new PVector[] {
        new PVector(-54, random(290, 490)),
        new PVector(232, 420),
        new PVector(232, 420)
      },
      new float[] {
        0.16,
        0.22,
        0.25
      },
      EASEOUT,
      stepHighlightBounds[currStep]
    );

    // O (single) 1
    drawMoveable(
      timestamp,
      shapeO,
      new PVector[] {
        new PVector(786, 454),
        new PVector(786, 438),
        new PVector(786, 316),
        new PVector(786, 316)
      },
      new float[] {
        0.255,
        0.32,
        0.42,
        0.45
      },
      EASEIN,
      stepHighlightBounds[currStep]
    );

    // O (single) 2
    drawMoveable(
      timestamp,
      shapeO,
      new PVector[] {
        new PVector(830, 454),
        new PVector(830, 316),
        new PVector(830, 316)
      },
      new float[] {
        0.255,
        0.58,
        0.61
      },
      EASEIN,
      stepHighlightBounds[currStep]
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
        0.59
      },
      EASEOUT,
      stepHighlightBounds[currStep]
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
        0.75
      },
      EASEOUT,
      stepHighlightBounds[currStep]
    );

    // O2
    drawMoveable(
      timestamp,
      shapeO2,
      new PVector[] {
        new PVector(1094, random(290, 490)),
        new PVector(808,  454),
        new PVector(808,  454)
      },
      new float[] {
        0.2,
        0.26,
        0.29
      },
      EASEOUT,
      stepHighlightBounds[currStep]
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
      EASEIN,
      stepHighlightBounds[currStep]
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
      EASEIN,
      stepHighlightBounds[currStep]
    );
  }
}