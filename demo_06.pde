import controlP5.*;
import processing.svg.*;

ControlP5 cp5;

int cols = 10;
int rows = 5;
float cellWidth, cellHeight;
boolean[][] grid;
int[][] subdivisions; 
boolean[][][] subGrid; 
float fillProbability = 0.5; 


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

  cp5.addSlider("fillProbability")
     .setPosition(10, 70)
     .setSize(200, 20)
     .setRange(0.1, 1.0)
     .setValue(fillProbability)
     .plugTo(this, "setFillProbability");

  cp5.addButton("saveAsSVG")
     .setPosition(10, 100)
     .setSize(100, 30)
     .setLabel("Save SVG")
     .plugTo(this, "saveSVG");

  cp5.addButton("generateA")
     .setPosition(10, 130)
     .setSize(100, 30)
     .setLabel("Generate A")
     .plugTo(this, "generateLetterA");

  resetGrid();
}

void draw() {
  background(bgColor);
  drawGridWithSubdivisions();
}

void drawGridWithSubdivisions() {
  stroke(10);
  strokeWeight(1);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j]) { 
        float x = i * cellWidth;
        float y = j * cellHeight;

        int subDiv = subdivisions[i][j];
        float subCellWidth = cellWidth / subDiv;
        float subCellHeight = cellHeight / subDiv;

        for (int subX = 0; subX < subDiv; subX++) {
          for (int subY = 0; subY < subDiv; subY++) {
            if (subGrid[i][j][subX * subDiv + subY]) { 
              float subXPos = x + subX * subCellWidth;
              float subYPos = y + subY * subCellHeight;
              fill(currentColor);
              noStroke();
              rect(subXPos, subYPos, subCellWidth, subCellHeight);
            }
          }
        }
      }
    }
  }
}

void saveSVG() {
  PGraphics svg = createGraphics(width, height, SVG, "output_A.svg");
  svg.beginDraw();
  svg.background(bgColor);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j]) { 
        float x = i * cellWidth;
        float y = j * cellHeight;

        int subDiv = subdivisions[i][j];
        float subCellWidth = cellWidth / subDiv;
        float subCellHeight = cellHeight / subDiv;

        for (int subX = 0; subX < subDiv; subX++) {
          for (int subY = 0; subY < subDiv; subY++) {
            if (subGrid[i][j][subX * subDiv + subY]) { 
              float subXPos = x + subX * subCellWidth;
              float subYPos = y + subY * subCellHeight;
              svg.fill(currentColor);
              svg.noStroke();
              svg.rect(subXPos, subYPos, subCellWidth, subCellHeight);
            }
          }
        }
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

void generateGeometricA() {
  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);
  int letterHeight = endY - startY;

  int leftXStart = int(cols * random(0.25, 0.35));
  int rightXEnd = cols - leftXStart;

  int lineThickness = max(1, round(rows * 0.05));

  for (int y = startY; y < startY + lineThickness; y++) {
    for (int x = leftXStart; x <= rightXEnd; x++) {
      grid[x][y] = true;
      fillSubdivisions(x, y);
    }
  }

  int middleYStart = int(random(startY + letterHeight * 0.35, startY + letterHeight * 0.65));
  for (int y = middleYStart; y < middleYStart + lineThickness; y++) {
    for (int x = leftXStart; x <= rightXEnd; x++) {
      grid[x][y] = true;
      fillSubdivisions(x, y);
    }
  }

  for (int y = startY; y <= endY; y++) {
    for (int x = leftXStart; x < leftXStart + round(cols * 0.05); x++) {
      grid[x][y] = true;
      fillSubdivisions(x, y);
    }
    for (int x = rightXEnd - round(cols * 0.05); x <= rightXEnd; x++) {
      grid[x][y] = true;
      fillSubdivisions(x, y);
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
      fillSubdivisions(xPos, y);
    }
  }

  for (int y = apexY; y < endY; y++) {
    float t = (float) (y - apexY) / (endY - apexY);
    int currentX = round(apexX + t * (rightXTarget - apexX));

    for (int w = 0; w < legWidth; w++) {
      int xPos = constrain(currentX - w, 0, cols - 1);
      grid[xPos][y] = true;
      fillSubdivisions(xPos, y);
    }
  }

  int crossbarYStart = int(random(rows * 0.5, rows * 0.8));
  int crossbarThickness = max(1, round(rows * 0.05));
  int leftBoundary = round(apexX + (crossbarYStart - apexY) * ((float)(leftXTarget - apexX) / (endY - apexY)));
  int rightBoundary = round(apexX + (crossbarYStart - apexY) * ((float)(rightXTarget - apexX) / (endY - apexY)));

  for (int y = crossbarYStart; y < crossbarYStart + crossbarThickness; y++) {
    for (int x = leftBoundary; x <= rightBoundary; x++) {
      grid[x][y] = true;
      fillSubdivisions(x, y);
    }
  }
}

void fillSubdivisions(int x, int y) {
  int subDiv = subdivisions[x][y];
  subGrid[x][y] = new boolean[subDiv * subDiv];
  for (int i = 0; i < subDiv * subDiv; i++) {
    subGrid[x][y][i] = random(1) < fillProbability;
  }
}

void resetGrid() {
  cellWidth = (float) width / cols;
  cellHeight = (float) height / rows;
  grid = new boolean[cols][rows];
  subdivisions = new int[cols][rows];
  subGrid = new boolean[cols][rows][];

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      subdivisions[i][j] = int(random(1, 9));
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

public void setFillProbability(float value) {
  fillProbability = value;
}
