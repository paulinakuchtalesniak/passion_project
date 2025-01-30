import controlP5.*;
import processing.svg.*;

ControlP5 cp5;

int cols = 10;  
int rows = 5;  
float cellWidth, cellHeight;  
int[][] gridCounters;  
color currentColor;  
color bgColor = color(30, 24, 25);  
color activeColor = color(200, 100, 100);
color inactiveColor = color(100, 100, 100);
color[] palette = {
  color(211, 114, 139), 
  color(208, 219, 61), 
  color(211, 50, 19), 
  color(234, 230, 199)
};

String mode = ""; 
String symmetryMode = "None"; 
boolean mouseInUI = false; 
boolean animationMode = false; 
float noiseOffset = 0;
float animationSpeed = 0.008;

void setup() {
  size(800, 800);
  currentColor = palette[0]; 
  cp5 = new ControlP5(this);

  int controlWidth = 100;
  int controlHeight = 15;
  int buttonHeight = 25;
  int buttonWidth = 100;
  int gap = 5; 

  cp5.addSlider("cols")
     .setPosition(10, 10)
     .setSize(controlWidth, controlHeight)
     .setRange(1, 500)  
     .setValue(cols);
  
  cp5.addSlider("rows")
     .setPosition(10, 30 + gap)
     .setSize(controlWidth, controlHeight)
     .setRange(1, 500)  
     .setValue(rows);

  cp5.addButton("resetGrid")
     .setPosition(10, 50 + 2 * gap)
     .setSize(controlWidth, buttonHeight)
     .setLabel("Reset Grid");

  cp5.addButton("drawMode")
     .setPosition(10, 80 + 3 * gap)
     .setSize(buttonWidth/2, buttonHeight)
     .setLabel("Draw")
     .setColorBackground(inactiveColor)
     .plugTo(this, "toggleDrawMode");

  cp5.addButton("eraseMode")
     .setPosition(10 + buttonWidth/2 + gap, 80 + 3 * gap)
     .setSize(buttonWidth/2, buttonHeight)
     .setLabel("Erase")
     .setColorBackground(inactiveColor)
     .plugTo(this, "toggleEraseMode");

int symmetryButtonWidth = buttonWidth / 2; 
int symmetryButtonHeight = buttonHeight; 

 addSymmetryButton("None", 10, 110 + 4 * gap, "setSymmetryNone", symmetryButtonWidth, symmetryButtonHeight);
addSymmetryButton("Vertical", 10 + symmetryButtonWidth + gap, 110 + 4 * gap, "setSymmetryVertical", symmetryButtonWidth, symmetryButtonHeight);
addSymmetryButton("Horizontal", 10, 140 + 5 * gap, "setSymmetryHorizontal", symmetryButtonWidth, symmetryButtonHeight);
addSymmetryButton("Radial", 10 + symmetryButtonWidth + gap, 140 + 5 * gap, "setSymmetryRadial", symmetryButtonWidth, symmetryButtonHeight);

 cp5.addButton("animationMode")
     .setPosition(10, 170 + 6 * gap)
     .setSize(controlWidth, buttonHeight)
     .setLabel("Animation")
     .setColorBackground(inactiveColor)
     .plugTo(this, "toggleAnimationMode");

  for (int i = 0; i < palette.length; i++) {
    cp5.addButton("color" + i)
       .setPosition(10 + i * (controlHeight + gap), 200 + 7 * gap)
       .setSize(controlHeight, controlHeight)
       .setColorForeground(palette[i])
       .setColorActive(palette[i])
       .setColorBackground(palette[i])
       .setLabelVisible(false)
       .plugTo(this, "setColor" + i);
  }

  resetGrid();
}

void draw() {
  background(bgColor);
  if (animationMode) {
    autonomousAnimation();
  }
  drawGrid();
  drawUI();
}

void drawGrid() {
  stroke(30);
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (gridCounters[i][j] > 0) {
        fill(getLayeredColor(currentColor, gridCounters[i][j]));
      } else {
        noFill();
      }
      rect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
    }
  }
}

void drawUI() {
  fill(234, 230, 199);
  textSize(14);
  text("Columns: " + cols, 10, 290);
  text("Rows: " + rows, 10, 310);
  text("Mode: " + (mode.equals("") ? "None" : mode), 10, 330);
  text("Symmetry: " + symmetryMode, 10, 350);
  text("Animation: " + (animationMode ? "Active" : "Inactive"), 10, 370);
  noFill();
  stroke(10);
  strokeWeight(0.3);
  for (int i = 0; i < palette.length; i++) {
    if (currentColor == palette[i]) {
      rect(10 + i * 40, 150, 30, 30);
    }
  }
}

void autonomousAnimation() {
  float x = noise(noiseOffset) * cols;
  float y = noise(noiseOffset + 100) * rows;

  int col = constrain(int(x), 0, cols - 1);
  int row = constrain(int(y), 0, rows - 1);

  applySymmetry(col, row, true);

  noiseOffset += animationSpeed;
}

void mousePressed() {
  mouseInUI = isMouseOnUI(); 
  if (!mouseInUI && isWithinGrid(mouseX, mouseY) && !mode.equals("")) {
    toggleCell(mouseX, mouseY);
  }
}

void mouseDragged() {
  if (!mouseInUI && isWithinGrid(mouseX, mouseY) && !mode.equals("")) {
    toggleCell(mouseX, mouseY);
  }
}

void toggleCell(int x, int y) {
  int col = int(x / cellWidth);
  int row = int(y / cellHeight);
  if (col >= 0 && col < cols && row >= 0 && row < rows) {
    if (mode.equals("draw")) {
      applySymmetry(col, row, true);
    } else if (mode.equals("erase")) {
      applySymmetry(col, row, false);
    }
  }
}

void applySymmetry(int col, int row, boolean state) {
  updateCell(col, row, state);
  if (symmetryMode.equals("Vertical")) {
    updateCell(cols - 1 - col, row, state);
  } else if (symmetryMode.equals("Horizontal")) {
    updateCell(col, rows - 1 - row, state);
  } else if (symmetryMode.equals("Radial")) {
    updateCell(cols - 1 - col, row, state);
    updateCell(col, rows - 1 - row, state);
    updateCell(cols - 1 - col, rows - 1 - row, state);
  }
}

void updateCell(int col, int row, boolean state) {
  if (state) {
    gridCounters[col][row]++;
  } else {
    gridCounters[col][row] = 0;
  }
}

color getLayeredColor(color base, int layers) {
  float brightnessAdjustment = map(layers, 1, 10, 1.0, 0.5);
  return lerpColor(base, color(0), 1 - brightnessAdjustment);
}

boolean isMouseOnUI() {
  return cp5.isMouseOver();
}

boolean isWithinGrid(int x, int y) {
  return x >= 0 && x < cols * cellWidth && y >= 0 && y < rows * cellHeight;
}

void resetGrid() {
  cellWidth = (float) width / cols;
  cellHeight = (float) height / rows;
  gridCounters = new int[cols][rows];
}

public void toggleDrawMode() {
  mode = mode.equals("draw") ? "" : "draw";
  cp5.get("drawMode").setColorBackground(mode.equals("draw") ? activeColor : inactiveColor);
  cp5.get("eraseMode").setColorBackground(inactiveColor);
}

public void toggleEraseMode() {
  mode = mode.equals("erase") ? "" : "erase";
  cp5.get("eraseMode").setColorBackground(mode.equals("erase") ? activeColor : inactiveColor);
  cp5.get("drawMode").setColorBackground(inactiveColor);
}

public void toggleAnimationMode() {
  animationMode = !animationMode;
  cp5.get("animationMode").setColorBackground(animationMode ? activeColor : inactiveColor);
}

public void cols(int value) {
  cols = max(1, value);
  resetGrid();
}

public void rows(int value) {
  rows = max(1, value);
  resetGrid();
}

public void setColor0() { currentColor = palette[0]; }
public void setColor1() { currentColor = palette[1]; }
public void setColor2() { currentColor = palette[2]; }
public void setColor3() { currentColor = palette[3]; }

public void setSymmetryNone() { 
  symmetryMode = "None"; 
  updateSymmetryButtonColors("None"); 
}
public void setSymmetryVertical() { 
  symmetryMode = "Vertical"; 
  updateSymmetryButtonColors("Vertical"); 
}
public void setSymmetryHorizontal() { 
  symmetryMode = "Horizontal"; 
  updateSymmetryButtonColors("Horizontal"); 
}
public void setSymmetryRadial() { 
  symmetryMode = "Radial"; 
  updateSymmetryButtonColors("Radial"); 
}

void addSymmetryButton(String label, int x, int y, String method, int width, int height) {
  cp5.addButton(label)
     .setPosition(x, y)
     .setSize(width, height)
     .setLabel(label)
     .setColorBackground(inactiveColor)
     .plugTo(this, method);
}
void updateSymmetryButtonColors(String selectedMode) {
  for (String mode : new String[] {"None", "Vertical", "Horizontal", "Radial"}) {
    cp5.get(mode).setColorBackground(mode.equals(selectedMode) ? activeColor : inactiveColor);
  }
}
