import controlP5.*;
import processing.svg.*;

ControlP5 cp5;

int cols = 10;  
int rows = 5;   
float cellWidth, cellHeight;  
boolean[][] grid;  
String[][] gridChars; 


String[] asciiChars = {"A", "@", "#", "$", "%", "&", "*", "+"};


color currentColor = color(211, 114, 139);  
color bgColor = color(30, 24, 25);  


int animationSpeed = 30; 
int additionFrequency = 60; 

void setup() {
  size(600, 600);
  smooth();  

  cp5 = new ControlP5(this);


  cp5.addSlider("cols")
     .setPosition(10, 10)
     .setSize(200, 20)
     .setRange(1, 150)
     .setValue(cols);


  cp5.addSlider("rows")
     .setPosition(10, 40)
     .setSize(200, 20)
     .setRange(1, 150)
     .setValue(rows);


  cp5.addButton("saveAsSVG")
     .setPosition(10, 110)
     .setSize(100, 30)
     .setLabel("Save SVG")
     .plugTo(this, "saveSVG");


  cp5.addButton("generateA")
     .setPosition(10, 70)
     .setSize(100, 30)
     .setLabel("Generate A")
     .plugTo(this, "generateLetterA");

  resetGrid();
}

void draw() {
  background(bgColor);


  if (frameCount % animationSpeed == 0) {
    animateGrid();
  }


  if (frameCount % additionFrequency == 0) {
    addNewElements();
  }

  drawGrid();
}

void animateGrid() {

  String[][] newGridChars = new String[cols][rows];

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      if (grid[x][y] && gridChars[x][y] != null) {

        int[] dx = {-1, 1, 0, 0}; 
        int[] dy = {0, 0, -1, 1}; 
        int direction = int(random(4)); 

        int newX = constrain(x + dx[direction], 0, cols - 1);
        int newY = constrain(y + dy[direction], 0, rows - 1);

        if (grid[newX][newY] && newGridChars[newX][newY] == null) {
          newGridChars[newX][newY] = gridChars[x][y]; 
          gridChars[x][y] = null; 
        } else {
          newGridChars[x][y] = gridChars[x][y]; 
        }
      }
    }
  }

  gridChars = newGridChars; 
}

void addNewElements() {

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      if (grid[x][y] && gridChars[x][y] == null && random(1) > 0.8) {
        gridChars[x][y] = asciiChars[int(random(asciiChars.length))];
      }
    }
  }
}

void drawGrid() {
  textAlign(CENTER, CENTER);
  textSize(min(cellWidth, cellHeight) * 1.8); 
  fill(currentColor);
  noStroke();

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      if (grid[x][y] && gridChars[x][y] != null) {
        text(gridChars[x][y], x * cellWidth + cellWidth / 2, y * cellHeight + cellHeight / 2);
      }
    }
  }
}

void saveSVG() {
  PGraphics svg = createGraphics(width, height, SVG, "output_A.svg");
  svg.beginDraw();
  svg.background(bgColor);

  svg.fill(currentColor);
  svg.noStroke();

  svg.textAlign(CENTER, CENTER);
  svg.textSize(min(cellWidth, cellHeight) * 0.6);

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      if (grid[x][y] && gridChars[x][y] != null) {
        svg.text(gridChars[x][y], x * cellWidth + cellWidth / 2, y * cellHeight + cellHeight / 2);
      }
    }
  }

  svg.endDraw();
  println("SVG saved as output_A.svg");
}

void generateLetterA() {
  resetGrid(); 


  boolean isSpiky = random(1) > 0.5;
  if (isSpiky) {
    generateSpikyA();
  } else {
    generateGeometricA();
  }
}

void resetGrid() {
  cellWidth = (float) width / cols;  
  cellHeight = (float) height / rows;  
  grid = new boolean[cols][rows];  
  gridChars = new String[cols][rows]; 

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      gridChars[x][y] = asciiChars[int(random(asciiChars.length))];
    }
  }
}

public void cols(int value) {
  cols = max(value, 1);
  resetGrid();
}

public void rows(int value) {
  rows = max(value, 1);
  resetGrid();
}
void generateGeometricA() {
  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);
  int letterHeight = endY - startY;

  int leftXStart = int(cols * random(0.15, 0.35));
  int rightXEnd = cols - leftXStart;

  int legWidth = max(1, round(cols * 0.05));
  int crossbarThickness = max(1, round(rows * 0.05));

  for (int y = startY; y < startY + crossbarThickness; y++) {
    for (int x = leftXStart; x <= rightXEnd; x++) {
      if (random(1) > 0.2) {
        grid[x][y] = true;
      }
    }
  }

  int middleYStart = int(random(startY + letterHeight * 0.5, startY + letterHeight * 0.8));
  for (int y = middleYStart; y < middleYStart + crossbarThickness; y++) {
    for (int x = leftXStart; x <= rightXEnd; x++) {
      if (random(1) > 0.3) {
        grid[x][y] = true;
      }
    }
  }

  for (int y = startY; y <= endY; y++) {
    for (int x = leftXStart; x < leftXStart + legWidth; x++) {
      if (random(1) > 0.3) {
        grid[x][y] = true;
      }
    }
    for (int x = rightXEnd - legWidth; x <= rightXEnd; x++) {
      if (random(1) > 0.3) {
        grid[x][y] = true;
      }
    }
  }
}

void generateSpikyA() {
  int apexX = cols / 2; 
  int apexY = int(rows * 0.1); 
  int leftXTarget = int(cols * random(0.15, 0.35)); 
  int rightXTarget = cols - leftXTarget; 
  int legWidth = max(1, round(cols * 0.05)); 
  int endY = int(rows * 0.9); 
  
  

  for (int y = apexY; y < endY; y++) {
    float t = (float) (y - apexY) / (endY - apexY); 
    int currentX = round(apexX + t * (leftXTarget - apexX)); 

    for (int w = 0; w < legWidth; w++) {
      int xPos = constrain(currentX + w, 0, cols - 1);
      grid[xPos][y] = true; 
    }
  }


  for (int y = apexY; y < endY; y++) {
    float t = (float) (y - apexY) / (endY - apexY);
    int currentX = round(apexX + t * (rightXTarget - apexX));

    for (int w = 0; w < legWidth; w++) {
      int xPos = constrain(currentX - w, 0, cols - 1);
      grid[xPos][y] = true;
    }
  }


  int crossbarYStart = int(random(rows * 0.5, rows * 0.8));
  int crossbarThickness = max(1, round(rows * 0.05));
  int leftBoundary = round(apexX + (crossbarYStart - apexY) * ((float)(leftXTarget - apexX) / (endY - apexY)));
  int rightBoundary = round(apexX + (crossbarYStart - apexY) * ((float)(rightXTarget - apexX) / (endY - apexY)));

  for (int y = crossbarYStart; y < crossbarYStart + crossbarThickness; y++) {
    for (int x = leftBoundary; x <= rightBoundary; x++) {
      if (random(1) > 0.3) { 
        grid[x][y] = true;
      }
    }
  }
}
