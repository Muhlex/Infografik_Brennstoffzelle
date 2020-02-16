class SceneQuiz extends Scene {

  Quiz quiz;
  Checkbox[] checkboxes = new Checkbox[3];
  ButtonAction buttonStart;
  ButtonAction buttonConfirm;
  ButtonAction buttonContinue;
  ButtonAction buttonRestart;
  ValidationResult result;

  int quizTime;
  int quizQuestionCount;

  SceneQuiz() {
    super();

    // Initialize Quiz

    ArrayList<Question> questions = new ArrayList<Question>();
    String questionTitle;
    StringList answers = new StringList();
    IntList solutions = new IntList();

    questionTitle = "Ist die richtige Antwort B?";
    answers.append("Nein es ist A.\n\bGlaube \bich.");
    answers.append("Ja genau.");
    answers.append("Keine Ahnung.");
    solutions.append(1);

    questions.add(new Question(questionTitle, answers, solutions));

    answers = new StringList();
    solutions = new IntList();

    questionTitle = "Magst du Schokoeis?";
    answers.append("Natürlich, das schmeckt super.");
    answers.append("Auf jeden Fall, einfach klasse.");
    answers.append("Ne.");
    solutions.append(0);
    solutions.append(1);

    questions.add(new Question(questionTitle, answers, solutions));

    quizQuestionCount = 2;
    quizTime = 91000;

    this.quiz = new Quiz(questions, quizTime, new QuizEndCallback() {
      void onEnd(QuizState reason) {
        for (Checkbox checkbox : checkboxes) {
          checkbox.hide();
        }
        buttonConfirm.hide();
        buttonContinue.hide();
      }
    });

    // Initialize A, B, C checkboxes
    int currYPos = 508;
    for (int i = 0; i <= 2; i++) {
      checkboxes[i] = new Checkbox(66, currYPos, 525, 48, 48, i, new CheckboxCallback() {
        void onChange(int value, boolean checked) {
          if (checked) {
            quiz.selectAnswer(value);
          }
          else {
            quiz.deselectAnswer(value);
          }
        }
      });
      checkboxes[i].hide();
      elements.add(checkboxes[i]);
      currYPos += 96;
    }

    // Initialize Action Buttons
    buttonRestart = new ButtonAction(417, 179, 22, 8, "Quiz neustarten", new ButtonActionCallback() {
      void onClick() {
        quiz.reset();
        buttonStart.show();
        buttonRestart.hide();
        buttonConfirm.hide();
        buttonContinue.hide();

        for (Checkbox checkbox : checkboxes) {
          checkbox.hide();
          checkbox.checked = false;
          checkbox.disabled = false;
          checkbox.currIcon = 0;
        }
      }
    });
    buttonRestart.hide();
    elements.add(buttonRestart);

    buttonStart = new ButtonAction(864, 701, 22, 8, "Quiz starten", new ButtonActionCallback() {
      void onClick() {
        quiz.start();
        buttonStart.hide();
        buttonRestart.show();
        buttonConfirm.show();

        for (Checkbox checkbox : checkboxes) {
          checkbox.show();
        }
      }
    });
    elements.add(buttonStart);

    buttonConfirm = new ButtonAction(805, 701, 22, 8, "Antwort bestätigen", new ButtonActionCallback() {
      void onClick() {
        result = quiz.confirmAnswers();
        buttonConfirm.hide();
        buttonContinue.show();

        for (int i = 0; i < checkboxes.length; i++) {

          checkboxes[i].disabled = true;

          if (result.answersSelectedFalsely.hasValue(i)) {
            checkboxes[i].currIcon = 1;
          }
          else if (result.answersSelectedCorrectly.hasValue(i)) {
            checkboxes[i].currIcon = 3;
          }
          else if (result.answersNotSelectedFalsely.hasValue(i)) {
            checkboxes[i].checked = true;
            checkboxes[i].currIcon = 2;
          }
        }
      }
    });
    buttonConfirm.hide();
    elements.add(buttonConfirm);

    buttonContinue = new ButtonAction(846, 701, 22, 8, "Nächste Frage", new ButtonActionCallback() {
      void onClick() {
        quiz.nextQuestion();
        buttonContinue.hide();
        buttonConfirm.show();

        for (Checkbox checkbox : checkboxes) {
          checkbox.checked = false;
          checkbox.currIcon = 0;
          checkbox.disabled = false;
        }
      }
    });
    buttonContinue.hide();
    elements.add(buttonContinue);
  }

  @Override
  void onKeyPressed() {
    for (int i = 0; i < checkboxes.length; i++) {
      if ((i == 0 && (key == 'a' || key == 'A')) ||
          (i == 1 && (key == 'b' || key == 'B')) ||
          (i == 2 && (key == 'c' || key == 'C'))) {
        boolean checked = checkboxes[i].checked = ! checkboxes[i].checked;
        if (checked) {
          quiz.selectAnswer(i);
        }
        else {
          quiz.deselectAnswer(i);
        }
      }
    }
  }

  @Override
  void draw() {
    super.draw();

    String buffer = "";

    // STATIC ELEMENTS (these do not get pushed into the elements ArrayList)

    // Heading Background
    pushStyle();

    fill(colPrimary);

    switch (quiz.state) {
      case INITIAL:
      case TIMEUP:
      case DONE:
        rect(0, 281, 591, 129);
      break;

      case QUESTIONS:
        rect(0, 281, 591, 171);
      break;

      case CLOZETESTS:
        rect(0, 281, 591, 87);
      break;
    }

    popStyle();

    // Heading Text
    pushStyle();

    fill(colBright);
    textFont(fontHeading);
    textAlign(LEFT, TOP);
    textLeading(fontHeadingSize * defaultLineHeight);

    switch (quiz.state) {
      case INITIAL:
        buffer = "Hier kannst Du \bdein \bWissen zum Thema \bBrennstoffzelle testen!";
      break;

      case QUESTIONS:
        buffer = quiz.getCurrQuestion();
      break;

      case CLOZETESTS:
        buffer = "Vervollständige den Text.";
      break;

      case TIMEUP:
        buffer = "Die \bZeit ist abgelaufen!";
      break;
    }

    textExt(buffer, 32, 304, 519, fontHeadingBold);

    popStyle();

    // Body Text
    pushStyle();

    fill(colText);
    textFont(fontLead);
    textAlign(LEFT, TOP);
    textLeading(fontLeadSize * defaultLineHeight);

    switch (quiz.state) {
      case INITIAL:
        buffer = "Hier werden Dir nacheinander verschiedene \bMultiple-Choice-Fragen gestellt. " +
                 "Wenn du diese gemeistert hast, kommt am Ende noch ein \bLückentext auf dich zu. " +
                 "Dabei solltest Du die Zeit im Blick behalten, da dir nur X Minuten für alle 3 Fragen zur Verfügung stehen. " +
                 "Bei einer falschen Antwort erhältst Du eine Zeitstrafe.\n\n" +
                 "\bViel \bErfolg!";
        textExt(buffer, 30, 446, 564, fontLeadBold);
      break;

      case TIMEUP:
        buffer = "Du kannst es erneut versuchen, oder dir die Infografik zuerst noch einmal genauer ansehen.";
        textExt(buffer, 30, 446, 564, fontLeadBold);
      break;
    }

    popStyle();

    // Statistics
    if (quiz.state != QuizState.INITIAL) {
      pushStyle();

      fill(colText);
      textFont(fontLead);
      textAlign(LEFT, TOP);
      textLeading(fontLeadSize * defaultLineHeight);

      switch(quiz.state) {
        case QUESTIONS:
        case CLOZETESTS:
          buffer = "\bFrage \b" + (quiz.currQuestion + 1) + " \b/ \b3";
        break;

        default:
          buffer = "\bDein \bErgebnis";
        break;
      }

      textExt(buffer, 32, 129, 380, fontLeadBold);
      textExt("Punktestand: \b" + quiz.score + " \b/ \b100", 32, 162, 380, fontLeadBold);

      color colTimer = lerpColor(colRed, colText, (float(quiz.timer.getRemaining()) / float(quizTime)));
      fill(colTimer);
      textExt("Verbleibende Zeit: \b" + msToMinSecString(quiz.timer.getRemaining()), 32, 195, 380, fontLeadBold);

      popStyle();
    }

    // Multiple-Choice-Question specific Elements

    if (quiz.state == QuizState.QUESTIONS) {

      // A, B, C Letters
      pushStyle();

      fill(colPrimary);
      textFont(fontHeadingBold);
      textAlign(LEFT, TOP);
      textLeading(fontHeadingSize * defaultLineHeight);

      text("A", 32, 506);
      text("B", 32, 603);
      text("C", 32, 700);

      popStyle();

      // Answer Labels
      pushStyle();

      fill(colText);
      textFont(fontLead);
      textAlign(LEFT, TOP);
      textLeading(fontLeadSize * 1);

      int currYPos = 504;
      for (int i = 0; i <= 2; i++) {
        if (quiz.answersConfirmed) {
          if (result.answersSelectedCorrectly.hasValue(i)) {
            fill(colAccentDark);
          }
          else if (result.answersSelectedFalsely.hasValue(i)) {
            fill(colRed);
          }
          else {
            fill(colText);
          }
        }
        textExt(quiz.getCurrAnswer(i), 146, currYPos, 445, fontLeadBold);
        currYPos += 96;
      }

      popStyle();
    }
  }
}