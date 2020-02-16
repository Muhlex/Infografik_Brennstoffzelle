class Quiz {

  ArrayList<Question> questions;
  //ArrayList<ClozeTest> clozeTests;
  QuizState state;
  int currQuestion;
  IntList selectedAnswers;
  int score;
  ProcessingTimer timer;

  Quiz(ArrayList<Question> questions, int time) {
    this.questions = questions;
    this.state = QuizState.INITIAL;
    this.currQuestion = 0;
    this.score = 0;
    this.selectedAnswers = new IntList();

    this.timer = new ProcessingTimer(new TimerCallback() {
      @Override
      void expired() {
        println("Timer abgelaufen.");
      }
    });
  }

  String getCurrQuestion() {
    return this.questions.get(currQuestion).questionTitle;
  }

  String getCurrAnswer(int answer) {
    return this.questions.get(currQuestion).answers.get(answer);
  }

  void reset() {
    this.currQuestion = 0;
    this.selectedAnswers.clear();
    this.score = 0;
    this.state = QuizState.INITIAL;
  }

  void start() {
    this.state = QuizState.QUESTIONS;
    this.currQuestion = 0;
    this.selectedAnswers.clear();
  }

  void selectAnswer(int answer) {
    selectedAnswers.append(answer);
  }

  void deselectAnswer(int answer) {
    selectedAnswers.removeValue(answer);
  }

  void confirmAnswers() {
    ValidationResult result = questions.get(currQuestion).validate(selectedAnswers);
    score += result.amountCorrect * 10;
    println(score);
  }

  void nextQuestion() {
    switch (this.state) {
      case QUESTIONS:
        if (currQuestion < questions.size() - 1) {
          currQuestion++;
        }
      break;


    }
  }
}

enum QuizState {
  INITIAL, QUESTIONS, CLOZETESTS, TIMEUP, DONE;
}