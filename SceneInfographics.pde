class SceneInfographics extends Scene {

  SceneInfographics() {
    super();
    InputText test = new InputText(32, 400, 20, new InputTextCallback() {
      void onChange(String value) {
        println("InputText value changed to: " + value);
      }
    });
    elements.add(test);
  }

  @Override
  void draw() {
    super.draw();

    // Draw Infographics
  }
}