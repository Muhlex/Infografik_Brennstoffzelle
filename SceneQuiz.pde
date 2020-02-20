class SceneQuiz extends Scene {

  Quiz quiz;
  Checkbox[] checkboxes = new Checkbox[3];
  ButtonAction buttonStart;
  ButtonAction buttonConfirm;
  ButtonAction buttonContinue;
  ButtonAction buttonRestart;
  ValidationResult questionResult;
  IntList clozeResult;
  ArrayList<InputText> inputs;

  int quizTime;
  int quizQuestionCount;

  SceneQuiz() {
    super();

    // Initialize Quiz

    // Load questions from file
    ArrayList<Question> questions = new ArrayList<Question>();
    String[] questionsData = loadStrings("questions.txt");

    for (int i = 0; i < questionsData.length; i += 3) {
      String questionTitle;
      StringList answers = new StringList();
      IntList solutions = new IntList();

      questionTitle = questionsData[i];

      answers.append(questionsData[i+1].split(";"));

      for (String solution : questionsData[i+2].split(";")) {
        solutions.append(int(solution));
      }

      questions.add(new Question(questionTitle, answers, solutions));
    }

    // Load clozetest from file
    ArrayList<ClozeTest> clozeTests = new ArrayList<ClozeTest>();
    ClozeTest clozeTest;

    String[] clozetestsData = loadStrings("clozetest.txt");

    StringList textSnippets = new StringList();
    StringList solutions    = new StringList();

    for (int i = 0; i < clozetestsData.length; i += 2) {

      textSnippets.append(clozetestsData[i]);
      if (i+1 < clozetestsData.length) {
        solutions.append(clozetestsData[i+1]);
      }

    }
    clozeTest = new ClozeTest(textSnippets, solutions);
    clozeTests.add(clozeTest);

    pushStyle();

    fill(colText);
    textFont(fontLead);
    textAlign(LEFT, TOP);
    textLeading(52);

    inputs = createClozeInputs(clozeTest, 32, 423, 560);

    popStyle();

    for (int i = 0; i < inputs.size(); i++) {
      final int id = i;

      inputs.get(i).callback = new InputTextCallback() {
        void onChange(String value) {
          quiz.clozeAnswerValues.set(id, value);
        }
      };

      inputs.get(i).hide();
    }
    elements.addAll(inputs);

    quizQuestionCount = 2;
    quizTime = 91000;

    this.quiz = new Quiz(questions, clozeTests, quizTime, new QuizCallback() {
      void onEnd(QuizState reason) {
        for (Checkbox checkbox : checkboxes) {
          checkbox.hide();
        }

        for (InputText input : inputs) {
          input.hide();
        }

        buttonConfirm.hide();
        buttonContinue.hide();
      }

      void onStartClozeTests() {
        for (Checkbox checkbox : checkboxes) {
          checkbox.hide();
        }

        for (InputText input : inputs) {
          input.show();
        }
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
    buttonRestart = new ButtonAction(417, 179, 22, 8, "Quiz neustarten", new ButtonCallback() {
      void onClick() {
        quiz.reset();
        buttonStart.show();
        buttonRestart.hide();
        buttonConfirm.hide();
        buttonContinue.hide();
        buttonContinue.label = "Nächste Frage";

        for (Checkbox checkbox : checkboxes) {
          checkbox.hide();
          checkbox.checked = false;
          checkbox.disabled = false;
          checkbox.currIcon = 0;
        }

        for (InputText input : inputs) {
          input.hide();
          input.value = "";
          input.isDisabled = false;
          input.isCorrect = false;
        }
      }
    });
    buttonRestart.hide();
    elements.add(buttonRestart);

    buttonStart = new ButtonAction(864, 701, 22, 8, "Quiz starten", new ButtonCallback() {
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

    buttonConfirm = new ButtonAction(805, 701, 22, 8, "Antwort bestätigen", new ButtonCallback() {
      void onClick() {
        switch (quiz.state) {
          case QUESTIONS:
            questionResult = quiz.confirmAnswers();
            buttonConfirm.hide();
            buttonContinue.show();

            for (int i = 0; i < checkboxes.length; i++) {

              checkboxes[i].disabled = true;

              if (questionResult.answersSelectedFalsely.hasValue(i)) {
                checkboxes[i].currIcon = 1;
              }
              else if (questionResult.answersSelectedCorrectly.hasValue(i)) {
                checkboxes[i].currIcon = 3;
              }
              else if (questionResult.answersNotSelectedFalsely.hasValue(i)) {
                checkboxes[i].checked = true;
                checkboxes[i].currIcon = 2;
              }
            }

            if (quiz.state == QuizState.CLOZETESTS) {

            }
          break;

          case CLOZETESTS:
            clozeResult = quiz.validateCloze();
            for (int i = 0; i < inputs.size(); i++) {
              inputs.get(i).isDisabled = true;
              if (clozeResult.hasValue(i)) {
                inputs.get(i).isCorrect = true;
              } else {
                inputs.get(i).isCorrect = false;
              }
            }

            quiz.timer.pause();

            buttonConfirm.hide();
            buttonContinue.label = "Quiz beenden";
            buttonContinue.show();
          break;
        }
      }
    });
    buttonConfirm.hide();
    elements.add(buttonConfirm);

    buttonContinue = new ButtonAction(846, 701, 22, 8, "Nächste Frage", new ButtonCallback() {
      void onClick() {
        quiz.nextQuestion();
        buttonContinue.hide();
        if (quiz.state != QuizState.DONE) {
          buttonConfirm.show();
        }

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
    super.onKeyPressed();
    switch (quiz.state) {
      case QUESTIONS:
        // Allow user to tick A, B, C via Keyboard
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
      break;

      case CLOZETESTS:
        // Allow user to use TAB to switch focused input field
        if (key == TAB) {
          boolean focusNextInput = false;
          for (int i = 0; i < inputs.size(); i++) {
            if (focusNextInput) {
              inputs.get(i).hasFocus = true;
              break;
            }
            else if (inputs.get(i).hasFocus) {
              inputs.get(i).hasFocus = false;
              // If not last input
              if (i < inputs.size() - 1) {
                focusNextInput = true;
              }
              else {
                // Focus first one again
                inputs.get(0).hasFocus = true;
              }
            }
          }
          // Focus first one if none was focused
          if ( ! focusNextInput) {
            inputs.get(0).hasFocus = true;
          }
        }
      break;
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

      case DONE:
        if (quiz.score >= quiz.maxScore) {
          buffer = "Das war \bperfekt!\nDu hast alls richtig beantwortet.";
        } else if (quiz.score >= quiz.maxScore * 0.8) {
          buffer = "Das war \bsehr \bgut!\nDu kennst Dich im Thema super aus.";
        } else if (quiz.score >= quiz.maxScore * 0.5) {
          buffer = "Das war \bnicht \bschlecht!\nDas kannst Du aber noch besser.";
        } else if (quiz.score >= quiz.maxScore * 0.25) {
          buffer = "Das war schonmal \bein \bAnfang!\nDa geht aber noch mehr.";
        } else {
          buffer = "Das war... ein Versuch.\n\bWiederhole den Stoff noch einmal.";
        }
      break;
    }

    textExt(buffer, 32, 304, 520, fontHeadingBold);

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

      case DONE:
        if (quiz.score >= quiz.maxScore) {
          buffer = "Deine Kenntnisse zur Brennstoffzelle sind wirklich beeindruckend.";
        } else if (quiz.score >= quiz.maxScore * 0.8) {
          buffer = "Dein Verständnis zur Brennstoffzelle ist wirklich gut. " +
                   "Vielleicht schaust Du Dir die Fachbegriffe noch einmal genauer an, um den letzten Rest herauszuholen!.";
        } else if (quiz.score >= quiz.maxScore * 0.5) {
          buffer = "Schaue Dir noch einmal die Infografik an und achte auch auf die verwendete Terminologie. " +
                   "Dann holst Du Dir auch die restlichen Punkte ab!";
        } else if (quiz.score >= quiz.maxScore * 0.25) {
          buffer = "Sieh Dir die einzelnen Schritte der Infografik erneut im Detail an. " +
                   "Wenn Du auf die Fachbegriffe und die genauen Abläufe achtest, kommst Du der Maximalpunkzzahl immer näher.";
        } else {
          buffer = "In der Infografik werden Dir der Aufbau, und die Abläufe der Brennstoffzelle im Detail erklärt. " +
                   "Wenn Du Dich damit vertraut machst, erreichst du beim nächsten Mal sicher ein gutes Ergebnis.";
        }
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
      textExt("Punktestand: \b" + quiz.score + " \b/ \b" + quiz.maxScore, 32, 162, 380, fontLeadBold);

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
          if (questionResult.answersSelectedCorrectly.hasValue(i)) {
            fill(colAccentDark);
          }
          else if (questionResult.answersSelectedFalsely.hasValue(i)) {
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

    // Cloze Test specific Elements
    if (quiz.state == QuizState.CLOZETESTS) {
      // Render Text
      pushStyle();

      fill(colText);
      textFont(fontLead);
      textAlign(LEFT, TOP);
      textLeading(52);

      textCloze(quiz.getCurrClozeTextSnippets(), inputs, 32, 423, 560);

      popStyle();
    }
  }
}