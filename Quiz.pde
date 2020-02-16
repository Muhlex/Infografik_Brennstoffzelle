class Quiz {

  ArrayList<Question> questions;
  //ArrayList<ClozeTest> clozeTests;
  int currQuestion;
  IntList selectedAnswers;
  int score;
  ProcessingTimer timer;

  Quiz(ArrayList<Question> questions, int time) {
    this.questions = questions;
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
    return questions.get(currQuestion).questionTitle;
  }
}

enum QuizState {
  INITIAL, INPROGRESS, TIMEUP, DONE;
}