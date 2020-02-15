int currentScene = 0;
Scene[] scenes = new Scene[3];

PFont fontTitle;
PFont fontNavigation;
PFont fontHeading;
PFont fontLead;
PFont fontLeadBold;
PFont fontBody;
PFont fontBodyBold;

color colBright = #FFFFFF;
color colPrimary = #67647E;
color colText = #363446;

color colAccent = #53A381;
color colAccentDark = #428267;

color colRed = #C04352;
color colBlue = #587BAB;
color colOrange = #EA9F2E;

// Unicode characters
String sub2 = "\u2082";
String supPlus = "\u207A";
String supMinus = "\u207B";

void setup() {
  size(1040, 780); // 4:3 Resolution
  pixelDensity(displayDensity());
  frameRate(60);

  fontTitle      = createFont("font/Sarabun-Bold.ttf",    52);
  fontNavigation = createFont("font/Sarabun-Regular.ttf", 36);
  fontHeading    = createFont("font/Sarabun-Regular.ttf", 32);
  fontLead       = createFont("font/Sarabun-Regular.ttf", 24);
  fontLeadBold   = createFont("font/Sarabun-Bold.ttf",    24);
  fontBody       = createFont("font/Sarabun-Regular.ttf", 18);
  fontBodyBold   = createFont("font/Sarabun-Bold.ttf",    18);

  scenes[0] = new SceneIntro();
}

void draw() {
  background(colBright);
  scenes[currentScene].draw();
  fill(colPrimary);
  textFont(fontTitle);
  text("Genuss!!"+ sub2 + supPlus + supMinus, 400, 400);
}

void mousePressed() {
  scenes[currentScene].onMousePressed();
}

void keyPressed() {
  scenes[currentScene].onKeyPressed();
}