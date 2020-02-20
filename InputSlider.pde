class InputSlider extends Element {

  float value;
  float minValue;
  float maxValue;

  InputSliderCallback callback;

  InputSlider(int x, int y, int w, int h, float minValue, float maxValue, float initialValue, InputSliderCallback callback) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.value = initialValue;
    this.minValue = minValue;
    this.maxValue = maxValue;

    this.callback = callback;
  }

  @Override
  void onClick(boolean insideElement) {
    if (insideElement) {
      value = map(mouseX, x, x + w, minValue, maxValue);
      callback.onChange(value);
    }
  }

  @Override
  void onMouseDragged(boolean insideElement) {
    if (insideElement) {
      value = map(mouseX, x, x + w, minValue, maxValue);
      callback.onChange(value);
    }
  }

  void draw() {
    pushStyle();

    rectMode(CENTER);
    fill(colBright);
    rect(x + w / 2, y + h / 2, w, defaultStrokeWeight);

    rect(map(value, minValue, maxValue, x, x + w), y + h / 2, 8, h - 8);

    popStyle();
  }
}

interface InputSliderCallback {
  void onChange(float value);
}