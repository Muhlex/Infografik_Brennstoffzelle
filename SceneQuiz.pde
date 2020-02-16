class SceneQuiz extends Scene {

  Quiz quiz;
  Checkbox[] checkboxes = new Checkbox[3];
  ButtonAction buttonStart;
  ButtonAction buttonConfirm;
  ButtonAction buttonContinue;
  ButtonAction buttonRestart;
  ValidationResult result;

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

    this.quiz = new Quiz(questions, 30000);

    // Initialize A, B, C checkboxes
    int currYPos = 508;
    for (int i = 0; i <= 2; i++) {
      checkboxes[i] = new Checkbox(66, currYPos, 525, 48, 48, i, new CheckboxCallback() {
        @Override
        void onChange(int value, boolean checked) {
          onCheckboxChange(value, checked);
        }
      });
      checkboxes[i].hide();
      elements.add(checkboxes[i]);
      currYPos += 96;
    }

    // Initialize Action Buttons
    buttonRestart = new ButtonAction(417, 179, 22, 8, "Quiz neustarten", new ButtonActionCallback() {
      @Override
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
      @Override
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
      @Override
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
      @Override
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

  void onCheckboxChange(int value, boolean checked) {
    if (checked) {
      quiz.selectAnswer(value);
    }
    else {
      quiz.deselectAnswer(value);
    }
  }

  @Override
  void draw() {
    super.draw();

    // Heading Background
    pushStyle();

    fill(colPrimary);
    rect(0, 281, 591, 171);

    popStyle();

    // Heading Text
    pushStyle();

    fill(colBright);
    textFont(fontHeading);
    textAlign(LEFT, TOP);
    textLeading(fontHeadingSize * defaultLineHeight);

    String headingText = "";
    switch (quiz.state) {
      case INITIAL:
        headingText = "Hier kannst Du \bdein \bWissen zum Thema Brennstoffzelle testen!";
      break;

      case QUESTIONS:
        headingText = quiz.getCurrQuestion();
      break;

      case CLOZETESTS:
        headingText = "Vervollständige den Text.";
      break;
    }

    textExt(headingText, 32, 304, 519, fontHeadingBold);

    popStyle();

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

    // Statistics
    if (quiz.state != QuizState.INITIAL) {
      pushStyle();

      fill(colText);
      textFont(fontLead);
      textAlign(LEFT, TOP);
      textLeading(fontLeadSize * defaultLineHeight);

      textExt("\bFrage \b1 \b/ \b3", 32, 129, 380, fontLeadBold);
      textExt("Punktestand: \b" + quiz.score, 32, 162, 380, fontLeadBold);
      textExt("Verbleibende Zeit: \bXXs", 32, 195, 380, fontLeadBold);

      popStyle();
    }
  }
}