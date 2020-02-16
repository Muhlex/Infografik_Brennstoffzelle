class SceneQuiz extends Scene {

  Quiz quiz;
  Checkbox[] checkboxes = new Checkbox[3];

  SceneQuiz() {
    super();
    String questionTitle;
    StringList answers = new StringList();
    IntList solutions = new IntList();

    questionTitle = "Ist die richtige Antwort B?";
    answers.append("Nein es ist A.");
    answers.append("Ja genau.");
    answers.append("Keine Ahnung.");
    solutions.append(1);

    ArrayList<Question> questions = new ArrayList<Question>();
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
      elements.add(checkboxes[i]);
      currYPos += 96;
    }
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

    textExt(quiz.getCurrQuestion(), 32, 304, 519, fontHeadingBold);

    popStyle();

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
    textLeading(fontLeadSize * defaultLineHeight);

    textExt(quiz.getCurrAnswer(0), 146, 514, 445, fontLeadBold);
    textExt(quiz.getCurrAnswer(1), 146, 611, 445, fontLeadBold);
    textExt(quiz.getCurrAnswer(2), 146, 708, 445, fontLeadBold);

    popStyle();
  }
}