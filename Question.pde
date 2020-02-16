class Question {

  String questionTitle;
  StringList answers;
  IntList solutions;

  Question(String questionTitle, StringList answers, IntList solutions) {
    this.questionTitle = questionTitle;
    this.answers = answers;
    this.solutions = solutions;
  }

  ValidationResult validate(IntList selected) {

    ValidationResult result = new ValidationResult();

    for (int i = 0; i < answers.size(); i++) {
      if (selected.hasValue(i)) {
        if (solutions.hasValue(i)) {
          // Selected and is solution
          result.amountCorrect++;
          result.answersSelectedCorrectly.append(i);
        }
        else {
          // Selected but is not a solution
          result.amountFalse++;
          result.answersSelectedFalsely.append(i);
        }
      }
      else if (solutions.hasValue(i)) {
        // Not selected but is a solution
        result.amountFalse++;
        result.answersNotSelectedFalsely.append(i);
      }
    }
    return result;
  }
}

class ValidationResult {

  int amountCorrect;
  int amountFalse;
  IntList answersSelectedCorrectly;
  IntList answersSelectedFalsely;
  IntList answersNotSelectedFalsely;

  ValidationResult() {
    this.amountCorrect = 0;
    this.amountFalse = 0;
    this.answersSelectedCorrectly = new IntList();
    this.answersSelectedFalsely = new IntList();
    this.answersNotSelectedFalsely = new IntList();
  }
}