class Quiz {

  ArrayList<Question> questions;
  ArrayList<ClozeTest> clozeTests;
  QuizState state;
  boolean answersConfirmed;
  int currQuestion;
  IntList selectedAnswers;
  StringList clozeAnswerValues;
  int score;
  int maxScore;
  int availableTime;

  ProcessingTimer timer;
  QuizCallback endCallback;

  Quiz(ArrayList<Question> questions, ArrayList<ClozeTest> clozeTests, int availableTime, QuizCallback endCallback) {
    this.questions = questions;
    this.clozeTests = clozeTests;
    this.availableTime = availableTime;
    this.state = QuizState.INITIAL;
    this.currQuestion = 0;
    this.score = 0;
    this.selectedAnswers = new IntList();

    this.endCallback = endCallback;
    this.timer = new ProcessingTimer(new TimerCallback() {
      @Override
      void expired() {
        state = QuizState.TIMEUP;
        getCallback().onEnd(state);
      }
    });

    // Caluclate max reachable score
    for (Question question : questions) {
      this.maxScore += question.solutions.size();
    }
    for (ClozeTest clozeTest : clozeTests) {
      this.maxScore += clozeTest.solutions.size();
    }
    this.maxScore *= 10;
  }

  QuizCallback getCallback() {
    return endCallback;
  }

  String getCurrQuestion() {
    if (currQuestion < questions.size()) {
      return this.questions.get(currQuestion).questionTitle;
    }
    return null;
  }

  String getCurrAnswer(int answer) {
    if (currQuestion < questions.size()) {
      return this.questions.get(currQuestion).answers.get(answer);
    }
    return null;
  }

  StringList getCurrClozeTextSnippets() {
    if (currQuestion >= questions.size()) {
      return this.clozeTests.get(currQuestion - questions.size()).textSnippets;
    }
    return null;
  }

  StringList getCurrClozeSolutions() {
    if (currQuestion >= questions.size()) {
      return this.clozeTests.get(currQuestion - questions.size()).solutions;
    }
    return null;
  }

  void reset() {
    this.currQuestion = 0;
    this.selectedAnswers = new IntList();
    this.score = 0;
    this.state = QuizState.INITIAL;
    this.answersConfirmed = false;
    this.timer.cancel();
  }

  void start() {
    this.state = QuizState.QUESTIONS;
    this.currQuestion = 0;
    this.selectedAnswers.clear();
    this.timer.start(availableTime);
  }

  void selectAnswer(int answer) {
    selectedAnswers.append(answer);
  }

  void deselectAnswer(int answer) {
    selectedAnswers.removeValue(answer);
  }

  ValidationResult confirmAnswers() {
    ValidationResult result = questions.get(currQuestion).validate(selectedAnswers);
    score += result.amountCorrect * 10;
    score -= result.amountFalse * 5;
    // Clamp Score > 0
    if (score < 0) {score = 0;}
    timer.subtract(result.amountFalse * 10 * 1000);
    answersConfirmed = true;
    return result;
  }

  IntList validateCloze() {
    IntList result = clozeTests.get(currQuestion - questions.size()).validate(clozeAnswerValues);
    score += result.size() * 10;
    return result;
  }

  void endQuiz() {
    this.state = QuizState.DONE;
    getCallback().onEnd(state);
    timer.pause();
  }

  void nextQuestion() {
    switch (this.state) {
      case QUESTIONS:
        if (currQuestion < questions.size() - 1) {
          currQuestion++;
          answersConfirmed = false;
          selectedAnswers = new IntList();
        }
        else if (! clozeTests.isEmpty()) {
          this.state = QuizState.CLOZETESTS;
          currQuestion++;
          initializeClozeTest();
          getCallback().onStartClozeTests();
        }
        else {
          endQuiz();
        }
      break;

      case CLOZETESTS:
        if (currQuestion < questions.size() + clozeTests.size() - 1) {
          currQuestion++;

          initializeClozeTest();
        } else {
          endQuiz();
        }
      break;
    }
  }

  void initializeClozeTest() {
    clozeAnswerValues = new StringList();
    for (int i = 0; i < clozeTests.get(currQuestion - questions.size()).solutions.size(); i++) {
      clozeAnswerValues.append("");
    }
  }
}

interface QuizCallback {
  void onEnd(QuizState reason);
  void onStartClozeTests();
}

enum QuizState {
  INITIAL, QUESTIONS, CLOZETESTS, TIMEUP, DONE;
}