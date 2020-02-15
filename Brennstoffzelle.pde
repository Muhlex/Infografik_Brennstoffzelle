int currentScene = 0;
Scene[] scenes = new Scene[3];

void setup() {
  size(960, 540);
  //size(1280, 720);
  pixelDensity(displayDensity());
  frameRate(60);

  scenes[0] = new SceneIntro();
}

void draw() {
  background(100);
  scenes[currentScene].draw();
}

void mousePressed() {
  scenes[currentScene].onMousePressed();
}