class SceneQuiz extends Scene {

  Quiz quiz;

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

    Checkbox testBox = new Checkbox(66, 508, 525, 48, 48, 0);
    elements.add(testBox);
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
  }
}