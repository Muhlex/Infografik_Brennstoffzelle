class ClozeTest {
  StringList textSnippets;
  StringList solutions;

  ClozeTest(StringList textSnippets, StringList solutions) {
    this.textSnippets = textSnippets;
    this.solutions = solutions;
  }

  IntList validate(StringList answers) {
    IntList correctAnswers = new IntList();
    for (int i = 0; i < solutions.size(); i++) {
      String answer   = answers.get(i).toLowerCase().trim();
      String solution = solutions.get(i).toLowerCase().trim();

      if (answer.equals(solution)) {
        correctAnswers.append(i);
      }
    }
    return correctAnswers;
  }
}