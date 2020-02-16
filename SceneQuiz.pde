class SceneQuiz extends Scene {

  SceneQuiz() {
    super();
    StringList answers = new StringList();
    answers.append("Antwort 1");
    answers.append("Antwort 2");
    answers.append("Antwort 3");
    IntList solutions = new IntList();
    solutions.append(1);

    Question question = new Question("Saugt Processing Glied?", answers, solutions);

    IntList selected = new IntList();
    selected.append(1);
    selected.append(2);
    selected.append(0);
    ValidationResult result = question.validate(selected);

    println("result.amountCorrect: "+result.amountCorrect);
    println("result.amountFalse: "+result.amountFalse);



    QuizTimer timer = new QuizTimer(2000, new TimerCallback() {
      @Override
      void expired() {
        println("cock schmeggd");
      }
    });
    timer.start();
    timer.remaining();
  }

  @Override
  void draw() {
    super.draw();

    // Draw Quiz
  }
}