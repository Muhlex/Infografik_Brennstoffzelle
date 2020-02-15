class Question {

  String questionTitle;
  StringList answersLabel;
  IntList solutions;

  Question(String questionTitle, StringList answersLabel, IntList solutions) {
    this.questionTitle = questionTitle;
    this.answersLabel = answersLabel;
    this.solutions = solutions;
  }

  ValidationResult validate(IntList selected) {

    ValidationResult result = new ValidationResult();

    for (int i = 0; i < answersLabel.size(); i++) {
      if (selected.hasValue(i)) {
        if (solutions.hasValue(i)) {
          // Selected and is solution
          result.amountCorrect++;
        }
        else {
          // Selected but is not a solution
          result.amountFalse++;
        }
      }
      else if (solutions.hasValue(i)) {
        // Not selected but is a solution
        result.amountFalse++;
      }
    }
    return result;
  }
}

class ValidationResult {

  int amountCorrect;
  int amountFalse;

  ValidationResult() {
    this.amountCorrect = 0;
    this.amountFalse = 0;
  }

  ValidationResult(int amountCorrect, int amountFalse) {
    this.amountCorrect = amountCorrect;
    this.amountFalse = amountFalse;
  }
}