import controlP5.*;
import processing.svg.*;

ControlP5 cp5;

int cols = 10;  
int rows = 5;   
float cellWidth, cellHeight;  
boolean[][] grid;  
int startY = int(rows * 0.2); 
int endY = int(rows * 0.9); 

color currentColor = color(211, 114, 139);  
color bgColor = color(30, 24, 25);  

void setup() {
  size(600, 600);
  noSmooth();  

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
  drawGrid();
}

void saveSVG() {
  PGraphics svg = createGraphics(width, height, SVG, "output_A.svg");
  svg.beginDraw();
  svg.background(bgColor);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j]) {
        svg.fill(currentColor);
        svg.noStroke();
        svg.rect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
      }
    }
  }

  svg.endDraw();
  println("SVG saved as output_A.svg");
}

void drawGrid() {
  stroke(10);  
  strokeWeight(1);  
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j]) {
        fill(currentColor);
      } else {
        noFill(); 
      }
      rect(i * cellWidth, j * cellHeight, cellWidth, cellHeight);
    }
  }
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

void generateGeometricA() {
  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);
  int letterHeight = endY - startY;

  int leftXStart = int(cols * random(0.25, 0.35));
  int rightXEnd = cols - leftXStart;

  int lineThickness = max(1, round(rows * 0.05));

  for (int y = startY; y < startY + lineThickness; y++) { 
    for (int x = leftXStart; x <= rightXEnd; x++) {
      if (random(1) > 0.2) {
        grid[x][y] = true;
      }
    }
  }

  int middleYStart = int(random(startY + letterHeight * 0.35, startY + letterHeight * 0.65));
  for (int y = middleYStart; y < middleYStart + lineThickness; y++) { 
    for (int x = leftXStart; x <= rightXEnd; x++) {
      if (random(1) > 0.3) {
        grid[x][y] = true;
      }
    }
  }

  for (int y = startY; y <= endY; y++) {
    for (int x = leftXStart; x < leftXStart + round(cols * 0.05); x++) {
      if (random(1) > 0.3) {
        grid[x][y] = true;
      }
    }
    for (int x = rightXEnd - round(cols * 0.05); x <= rightXEnd; x++) {
      if (random(1) > 0.3) {
        grid[x][y] = true;
      }
    }
  }
}

void generateSpikyA() {
  resetGrid();

  int apexX = cols / 2;
  int apexY = int(rows * 0.1);

  int apexSquareSize = max(2, int(cols * 0.05));

  for (int y = apexY; y < apexY + apexSquareSize; y++) {
    for (int x = apexX - apexSquareSize / 2; x <= apexX + apexSquareSize / 2; x++) {
      if (x >= 0 && x < cols && y >= 0 && y < rows) {
        grid[x][y] = true;
      }
    }
  }

  int leftXTarget = int(cols * random(0.15, 0.35));
  int rightXTarget = cols - leftXTarget;
  int legWidth = max(1, round(cols * 0.05));
  int endY = int(rows * 0.9);

  for (int y = apexY + apexSquareSize; y < endY; y++) {
    float t = (float) (y - apexY) / (endY - apexY);
    int currentX = round(apexX + t * (leftXTarget - apexX));
    currentX += int(random(-1, 2));
    for (int w = 0; w < legWidth; w++) {
      if (currentX + w >= 0 && currentX + w < cols) {
        grid[currentX + w][y] = true;
      }
    }
  }

  for (int y = apexY + apexSquareSize; y < endY; y++) {
    float t = (float) (y - apexY) / (endY - apexY);
    int currentX = round(apexX + t * (rightXTarget - apexX));
    currentX += int(random(-1, 2));
    for (int w = 0; w < legWidth; w++) {
      if (currentX - w >= 0 && currentX - w < cols) {
        grid[currentX - w][y] = true;
      }
    }
  }

  int crossbarYStart = int(random(rows * 0.35, rows * 0.65));
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

void resetGrid() {
  cellWidth = (float) width / cols;  
  cellHeight = (float) height / rows;  
  grid = new boolean[cols][rows];  
}

public void cols(int value) {
  cols = max(value, 1);  
  resetGrid();
}

public void rows(int value) {
  rows = max(value, 1); 
  resetGrid();
}
