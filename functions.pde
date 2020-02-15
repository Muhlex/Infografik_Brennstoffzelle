void textExt(String text, float x, float y) {
  textExt(text, x, y, 1.0, width, null, null);
}
void textExt(String text, float x, float y, float lineHeight) {
  textExt(text, x, y, lineHeight, width, null, null);
}
void textExt(String text, float x, float y, float lineHeight, float w) {
  textExt(text, x, y, lineHeight, w, null, null);
}

void textExt(String text, float x, float y, float lineHeight, float w, IntList highlightedWords, PFont highlightFont) {
  float currXPos = x;
  float currYPos = y;
  float lineHeightAbsolute = (textAscent() + textDescent()) * lineHeight;
  String paragraphs[] = text.split("\n");

  int wordIndex = 0;

  for (String paragraph : paragraphs) {
    String words[] = paragraph.split(" ");


    for (String word : words) {
      float widthWord = textWidth(word);

      // Word has no space in current line
      if (widthWord > w - currXPos) {
        currYPos += lineHeightAbsolute;
        currXPos = x;
      }

      if ((highlightFont != null) && (highlightedWords.hasValue(wordIndex))) {
        pushStyle();
        textFont(highlightFont);

        text(word, currXPos, currYPos);

        popStyle();
      }
      else {
        text(word, currXPos, currYPos);
      }

      currXPos += widthWord + textWidth(" ");
      wordIndex++;
    }

    currYPos += lineHeightAbsolute;
    currXPos = x;
  }
}