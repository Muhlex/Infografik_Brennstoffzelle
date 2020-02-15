int currentScene = 0;
Scene[] scenes = new Scene[3];

color bright = #FFFFFF;
color primary = #67647E;
color text = #363446;

color accent = #53A381;
color accentDark = #428267;

color red = #C04352;
color blue = #587BAB;
color orange = #EA9F2E;

void setup() {
  size(1040, 780); // 4:3 Resolution
  pixelDensity(displayDensity());
  frameRate(60);

  scenes[0] = new SceneIntro();
}

void draw() {
  background(bright);
  scenes[currentScene].draw();
}

void mousePressed() {
  scenes[currentScene].onMousePressed();
}

void void keyPressed() {
  scenes[currentScene].onKeyPressed();
}