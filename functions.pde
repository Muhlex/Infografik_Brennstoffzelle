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

ArrayList<InputText> createClozeInputs(ClozeTest clozeTest, float x, float y, float w) {
  float currXPos = x;
  float currYPos = y;
  float lineHeightPx = g.textLeading;

  StringList textSnippets = clozeTest.textSnippets;
  StringList solutions = clozeTest.solutions;

  ArrayList<InputText> inputs = new ArrayList<InputText>();

  for (int i = 0; i < textSnippets.size(); i++) {
    String words[] = textSnippets.get(i).split(" ");

    for (String word : words) {

      float widthWord = textWidth(word);

      // Word has no space in current line
      if (widthWord > w - currXPos) {
        currYPos += lineHeightPx;
        currXPos = x;
      }

      currXPos += widthWord + textWidth(" ");
    }

    InputText newInput = new InputText(int(currXPos), int(currYPos - 8), solutions.get(i).length() + 2, null);

    // Check if new Input is too wide for the current line. If so, move it
    if (newInput.w > w - currXPos) {
      currYPos += lineHeightPx;
      currXPos = x;

      newInput.x = int(currXPos);
      newInput.y = int(currYPos);
    }

    inputs.add(newInput);

    currXPos += newInput.w + textWidth(" ");
  }
  return inputs;
}

void textCloze(StringList textSnippets, ArrayList<InputText> inputs, float x, float y, float w) {
  float currXPos = x;
  float currYPos = y;
  float lineHeightPx = g.textLeading;

  for (int i = 0; i < textSnippets.size(); i++) {
    String words[] = textSnippets.get(i).split(" ");

    for (String word : words) {

      float widthWord = textWidth(word);

      // Word has no space in current line
      if (widthWord > w - currXPos) {
        currYPos += lineHeightPx;
        currXPos = x;
      }

      text(word, currXPos, currYPos);

      currXPos += widthWord + textWidth(" ");
    }

    // Check if input width is too big for the current line
    if (inputs.get(i).w > w - currXPos) {
      currYPos += lineHeightPx;
      currXPos = x;
    }

    currXPos += inputs.get(i).w + textWidth(" ");
  }
}

String msToMinSecString(int ms) {
  int secs = (ms / 1000) % 60;
  int mins = (ms / (1000 * 60)) % 60;

  return String.format("%02d:%02d", mins, secs);
}

// Get the width of the widest letter of the current font
float getMaxLetterWidth() {
  int charcodeUpper = 65; // A
  int charcodeLower = 97; // a

  float highestWidth = 0.0;

  for (int i = charcodeUpper; i < charcodeUpper + 26; i++) {
    float charWidth = textWidth(char(i));
    if (charWidth > highestWidth) {
      highestWidth = charWidth;
    }
  }

  for (int i = charcodeLower; i < charcodeLower + 26; i++) {
    float charWidth = textWidth(char(i));
    if (charWidth > highestWidth) {
      highestWidth = charWidth;
    }
  }

  return highestWidth;
}