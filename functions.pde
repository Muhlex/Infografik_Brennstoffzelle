boolean isMouseInsideRect(float x1, float y1, float x2, float y2) {
  return (mouseX >= x1 && mouseX <= x2) &&
         (mouseY >= y1 && mouseY <= y2);
}

void textExt(String text, float x, float y) {
  textExt(text, x, y, width, null, null);
}
void textExt(String text, float x, float y, float w) {
  textExt(text, x, y, w, null, null);
}

void textExt(String text, float x, float y, float w, IntList highlightedWords, PFont highlightFont) {
  float currXPos = x;
  float currYPos = y;
  float lineHeightPx = g.textLeading;
  String paragraphs[] = text.split("\n");

  int wordIndex = 0;

  for (String paragraph : paragraphs) {
    String words[] = paragraph.split(" ");


    for (String word : words) {
      boolean highlightWord = ((highlightFont != null) && (highlightedWords.hasValue(wordIndex)));

      if (highlightWord) {
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