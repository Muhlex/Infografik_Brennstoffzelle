class ClozeTest {
  StringList textSnippets;
  StringList solutions;

  ClozeTest(StringList textSnippets, StringList solutions) {
    this.textSnippets = textSnippets;
    this.solutions = solutions;
  }

  IntList validate(StringList answers) {
    for (int i = 0; i < solutions.size(); i++) {
      if (solutions.get(i) == answers.get(i)) {
        println("Input "+i+" is correct");
      }
    }
    return new IntList();
  }
}