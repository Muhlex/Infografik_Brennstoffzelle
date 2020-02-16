boolean isMouseInsideRect(float x1, float y1, float x2, float y2) {
  return (mouseX >= x1 && mouseX <= x2) &&
         (mouseY >= y1 && mouseY <= y2);
}

void textExt(String text, float x, float y) {
  textExt(text, x, y, width, null);
}
void textExt(String text, float x, float y, float w) {
  textExt(text, x, y, w, null);
}

void textExt(String text, float x, float y, float w, PFont highlightFont) {
  float currXPos = x;
  float currYPos = y;
  float lineHeightPx = g.textLeading;
  String paragraphs[] = text.split("\n");

  int wordIndex = 0;

  for (String paragraph : paragraphs) {
    String words[] = paragraph.split(" ");


    for (String word : words) {
      boolean highlightWord = word.startsWith("\b");

      if (highlightWord) {
        word = word.substring(1);
        pushStyle();
        textFont(highlightFont);
      }

      float widthWord = textWidth(word);

      // Word has no space in current line
      if (widthWord > w - currXPos) {
        currYPos += lineHeightPx;
        currXPos = x;
      }

      text(word, currXPos, currYPos);

      if (highlightWord) {
        popStyle();
      }

      currXPos += widthWord + textWidth(" ");
      wordIndex++;
    }

    currYPos += lineHeightPx;
    currXPos = x;
  }
}

String msToMinSecString(int ms) {
  int secs = (ms / 1000) % 60;
  int mins = (ms / (1000 * 60)) % 60;

  return String.format("%02d:%02d", mins, secs);
}