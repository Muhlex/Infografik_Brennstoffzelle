import java.util.*;

int currentScene = 0;
Scene[] scenes = new Scene[3];

PFont fontTitle;
PFont fontNavigation;
PFont fontHeading;
PFont fontHeadingBold;
PFont fontLead;
PFont fontLeadBold;
PFont fontBody;
PFont fontBodyBold;
int   fontTitleSize      = 52;
int   fontNavigationSize = 36;
int   fontHeadingSize    = 32;
int   fontLeadSize       = 24;
int   fontBodySize       = 18;

float defaultLineHeight  = 1.3;

color colBright = #FFFFFF;
color colPrimary = #67647E;
color colText = #363446;

color colAccent = #53A381;
color colAccentDark = #428267;

color colRed = #C04352;
color colBlue = #587BAB;
color colOrange = #EA9F2E;

int   defaultStrokeWeight = 4;

// Unicode characters
String sub2 = "\u2082";
String supPlus = "\u207A";
String supMinus = "\u207B";

void setup() {
  size(1040, 780); // 4:3 Resolution
  pixelDensity(displayDensity());
  frameRate(60);

  fontTitle       = createFont("font/Sarabun-Bold.ttf",    fontTitleSize);
  fontNavigation  = createFont("font/Sarabun-Regular.ttf", fontNavigationSize);
  fontHeading     = createFont("font/Sarabun-Regular.ttf", fontHeadingSize);
  fontHeadingBold = createFont("font/Sarabun-Bold.ttf",    fontHeadingSize);
  fontLead        = createFont("font/Sarabun-Regular.ttf", fontLeadSize);
  fontLeadBold    = createFont("font/Sarabun-Bold.ttf",    fontLeadSize);
  fontBody        = createFont("font/Sarabun-Regular.ttf", fontBodySize);
  fontBodyBold    = createFont("font/Sarabun-Bold.ttf",    fontBodySize);

  scenes[0] = new SceneIntro();
  scenes[1] = new SceneInfographics();
  scenes[2] = new SceneQuiz();

  // Default styles
  noStroke();
  fill(colPrimary);
}

void draw() {
  background(colBright);
  scenes[currentScene].draw();

  // Debug show mouse position
  //if (frameCount % 60 == 0) {
  //  println("Mouse X: " + mouseX);
  //  println("Mouse Y: " + mouseY);
  //}
}

void mousePressed() {
  scenes[currentScene].onMousePressed();
}

void keyPressed() {
  scenes[currentScene].onKeyPressed();
}