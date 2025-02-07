import controlP5.*;
import processing.svg.*;

ControlP5 cp5;

int cols = 50;  
int rows = 50;   
float cellWidth, cellHeight;  
boolean[][] grid;  
float[][] circleSizes;  
String[][] gridChars;  
int[][] subdivisions; 
boolean[][][] subGrid; 
float fillProbability = 0.5; 
boolean drawCircles = false;  
boolean drawChars = false;   
boolean drawSubdivisions = false; 

String[] asciiChars = {"A", "@", "#", "$", "%", "&", "*", "+"};

color currentColor = color(211, 114, 139);  
color bgColor = color(30, 24, 25);  

int startY = int(rows * 0.2); 
int endY = int(rows * 0.9); 

float[][] squareScales;
float[][] squareRotations;

void setup() {
  size(600, 600);
  smooth();  

  cp5 = new ControlP5(this);

  cp5.addSlider("cols")
     .setPosition(10, 10)
     .setSize(200, 20)
     .setRange(1, 250) 
     .setValue(50);

  cp5.addSlider("rows")
     .setPosition(10, 40)
     .setSize(200, 20)
     .setRange(1, 250) 
     .setValue(50);

  cp5.addSlider("fillProbability")
     .setPosition(10, 70)
     .setSize(200, 20)
     .setRange(0.1, 1.0)
     .setValue(fillProbability)
     .plugTo(this, "setFillProbability")
     .hide(); // Ukryj suwak na początku

  cp5.addButton("saveAsSVG")
     .setPosition(10, 100)
     .setSize(100, 30)
     .setLabel("Save SVG")
     .plugTo(this, "saveSVG");


  cp5.addButton("distortGrid")
     .setPosition(10, 150)
     .setSize(100, 30)
     .setLabel("Distort")
     .plugTo(this, "distortGrid");

  cp5.addButton("randomizeCircles")
     .setPosition(10, 190)
     .setSize(100, 30)
     .setLabel("Randomize Circles")
     .plugTo(this, "randomizeShapes");

  cp5.addButton("drawCircles")
     .setPosition(10, 220)
     .setSize(100, 30)
     .setLabel("Draw Circles")
     .plugTo(this, "setDrawCircles");

  cp5.addButton("drawSquares")
     .setPosition(10, 250)
     .setSize(100, 30)
     .setLabel("Draw Squares")
     .plugTo(this, "setDrawSquares");

  cp5.addButton("drawChars")
     .setPosition(10, 280)
     .setSize(100, 30)
     .setLabel("Draw Chars")
     .plugTo(this, "setDrawChars");

  cp5.addButton("drawSubdivisions")
     .setPosition(10, 310)
     .setSize(100, 30)
     .setLabel("Draw Subdivisions")
     .plugTo(this, "setDrawSubdivisions")
     .hide(); // Ukryj przycisk na początku

  resetGrid();
}

void draw() {
  background(bgColor);  
  if (drawSubdivisions) {
    drawGridWithSubdivisions();
  } else {
    drawGrid();
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A') {
    generateLetterA();
  } else if (key == 'd' || key == 'D') {
    generateRegularD();
  } else if (key == 'E' || key == 'e') {
    generateRegularE();
  } else if (key == 'F' || key == 'f') {
    generateRegularF();
  } else if (key == 'I' || key == 'i') {
    generateRegularI();
  } else if (key == 'N' || key == 'n') {
    generateRegularN();
  } else if (key == 'O' || key == 'o') {
    generateRegularO();
  } else if (key == 'P' || key == 'p') {
    generateRegularP();
  } else if (key == 'M' || key == 'm') {
    generateRegularM();
  } else if (key == 'J' || key == 'j') {
    generateRegularJ();
  } else if (key == 'v' || key == 'V') {
    generateSpikyV();
  } 
}

void saveSVG() {
  PGraphics svg = createGraphics(width, height, SVG, "output_A.svg");
  svg.beginDraw();
  svg.background(bgColor);

  svg.fill(currentColor);
  svg.noStroke();

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j]) {
        if (drawChars && gridChars[i][j] != null) {
          svg.textAlign(CENTER, CENTER);
          svg.textSize(min(cellWidth, cellHeight) * 1.5);
          svg.text(gridChars[i][j], i * cellWidth + cellWidth / 2, j * cellHeight + cellHeight / 2);
        } else if (drawCircles) {
          svg.ellipse(
            i * cellWidth + cellWidth / 2,
            j * cellHeight + cellHeight / 2,
            circleSizes[i][j],
            circleSizes[i][j]
          );
        } else {
          svg.rect(
            i * cellWidth,
            j * cellHeight,
            cellWidth,
            cellHeight
          );
        }
      }
    }
  }

  svg.endDraw();
  println("SVG saved as output_A.svg");
}

void drawGrid() {
  stroke(80);
  strokeWeight(1);
  for (int i = 0; i <= cols; i++) {
    line(i * cellWidth, 0, i * cellWidth, height); // Linie pionowe
  }
  for (int j = 0; j <= rows; j++) {
    line(0, j * cellHeight, width, j * cellHeight); // Linie poziome
  }

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j]) {
        fill(currentColor);
        noStroke();
        if (drawChars && gridChars[i][j] != null) {
          textAlign(CENTER, CENTER);
          textSize(min(cellWidth, cellHeight) * 1.2);
          textMode(SHAPE);
          text(gridChars[i][j], i * cellWidth + cellWidth / 2, j * cellHeight + cellHeight / 2);
        } else if (drawCircles) {
          ellipse(
            i * cellWidth + cellWidth / 2, 
            j * cellHeight + cellHeight / 2, 
            circleSizes[i][j], 
            circleSizes[i][j]
          );
        } else {
          pushMatrix();
          translate(i * cellWidth + cellWidth / 2, j * cellHeight + cellHeight / 2);
          rotate(squareRotations[i][j]); // Use stored rotation
          scale(squareScales[i][j]); // Use stored scale
          rectMode(CENTER);
          rect(0, 0, cellWidth, cellHeight);
          popMatrix();
        }
      }
    }
  }
}

void drawGridWithSubdivisions() {
  stroke(10);
  strokeWeight(1);

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      if (grid[i][j]) { // Tylko dla komórek litery A
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
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  int middleYStart = int(random(startY + letterHeight * 0.35, startY + letterHeight * 0.65));
  for (int y = middleYStart; y < middleYStart + lineThickness; y++) {
    for (int x = leftXStart; x <= rightXEnd; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  for (int y = startY; y <= endY; y++) {
    for (int x = leftXStart; x < leftXStart + round(cols * 0.05); x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
    for (int x = rightXEnd - round(cols * 0.05); x <= rightXEnd; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
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
      if (random(1) > fillProbability) {
        grid[xPos][y] = true;
        fillSubdivisions(xPos, y);
      }
    }
  }

  for (int y = apexY; y < endY; y++) {
    float t = (float) (y - apexY) / (endY - apexY);
    int currentX = round(apexX + t * (rightXTarget - apexX));

    for (int w = 0; w < legWidth; w++) {
      int xPos = constrain(currentX - w, 0, cols - 1);
      if (random(1) > fillProbability) {
        grid[xPos][y] = true;
        fillSubdivisions(xPos, y);
      }
    }
  }

  int crossbarYStart = int(random(rows * 0.5, rows * 0.8));
  int crossbarThickness = max(1, round(rows * 0.05));
  int leftBoundary = round(apexX + (crossbarYStart - apexY) * ((float)(leftXTarget - apexX) / (endY - apexY)));
  int rightBoundary = round(apexX + (crossbarYStart - apexY) * ((float)(rightXTarget - apexX) / (endY - apexY)));

  for (int y = crossbarYStart; y < crossbarYStart + crossbarThickness; y++) {
    for (int x = leftBoundary; x <= rightBoundary; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }
}

void fillSubdivisions(int x, int y) {
  int subDiv = subdivisions[x][y];
  if (subGrid[x][y] == null || subGrid[x][y].length != subDiv * subDiv) {
    subGrid[x][y] = new boolean[subDiv * subDiv]; // Upewnij się, że subGrid jest zainicjalizowane
  }
  for (int i = 0; i < subDiv * subDiv; i++) {
    subGrid[x][y][i] = random(1) < fillProbability;
  }
}

void generateRegularD() {
  resetGrid();

  int leftX = int(cols * 0.25);
  int rightX = int(cols * random(0.55, 0.65));

  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);

  int stemThickness = max(1, round(cols * 0.05));
  int horizontalLength = max(2, round(cols * 0.15));

  // vertical stem
  for (int y = startY; y <= endY; y++) {
    for (int x = leftX; x < leftX + stemThickness; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // upper horizontal line
  for (int x = leftX + stemThickness; x <= leftX + stemThickness + horizontalLength; x++) {
    for (int y = startY; y < startY + stemThickness; y++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // lower horizontal line
  for (int x = leftX + stemThickness; x <= leftX + stemThickness + horizontalLength; x++) {
    for (int y = endY - stemThickness; y <= endY; y++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // middle part
  int middleYStart = startY + int((endY - startY) * 0.4);
  int middleYEnd = middleYStart + int((endY - startY) * 0.1);
  for (int y = middleYStart; y < middleYEnd; y++) {
    for (int x = rightX - stemThickness; x <= rightX; x++) {
      if (x < cols && random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // upper diagonal line
  for (int y = startY; y <= middleYStart; y++) {
    int x = int(map(y, startY, middleYStart, leftX + stemThickness + horizontalLength, rightX - stemThickness));
    for (int w = 0; w < stemThickness; w++) {
      if (x + w < cols && random(1) > fillProbability) {
        grid[x + w][y] = true;
        fillSubdivisions(x + w, y);
      }
    }
  }

  // lower diagonal line
  for (int y = middleYEnd; y <= endY; y++) {
    int x = int(map(y, middleYEnd, endY, rightX - stemThickness, leftX + stemThickness + horizontalLength));
    for (int w = 0; w < stemThickness; w++) {
      if (x + w < cols && random(1) > fillProbability) {
        grid[x + w][y] = true;
        fillSubdivisions(x + w, y);
      }
    }
  }
}

void generateRegularE() {
  resetGrid();

  int leftX = int(cols * 0.25);
  int rightX = int(cols * random(0.55, 0.65));

  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);

  int stemThickness = max(1, round(cols * 0.05));
  int horizontalLength = max(2, round(cols * 0.15));

  // vertical stem
  for (int y = startY; y <= endY; y++) {
    for (int x = leftX; x < leftX + stemThickness; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // upper horizontal line
  for (int x = leftX; x <= rightX; x++) {
    for (int y = startY; y < startY + stemThickness; y++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // middle horizontal line
  int middleY = startY + int((endY - startY) * 0.5);
  for (int x = leftX; x < leftX + horizontalLength; x++) {
    for (int y = middleY; y < middleY + stemThickness; y++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // lower horizontal line
  for (int x = leftX; x <= rightX; x++) {
    for (int y = endY - stemThickness; y <= endY; y++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }
}

void generateRegularF() {
  resetGrid();

  int leftX = int(cols * 0.25);
  int rightX = int(cols * random(0.55, 0.65));

  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);

  int stemThickness = max(1, round(cols * 0.05));
  int horizontalLength = max(2, round(cols * 0.15));

  // vertical stem
  for (int y = startY; y <= endY; y++) {
    for (int x = leftX; x < leftX + stemThickness; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // upper horizontal line
  for (int x = leftX; x <= rightX; x++) {
    for (int y = startY; y < startY + stemThickness; y++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // middle horizontal line
  int middleY = startY + int((endY - startY) * 0.5);
  for (int x = leftX; x < leftX + horizontalLength; x++) {
    for (int y = middleY; y < middleY + stemThickness; y++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }
}

void generateRegularI() {
  resetGrid();

  int centerX = int(cols * 0.5);
  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);

  int stemThickness = max(1, round(cols * 0.05));

  // vertical stem
  for (int y = startY; y <= endY; y++) {
    for (int x = centerX - stemThickness / 2; x <= centerX + stemThickness / 2; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }
}

void generateRegularN() {
  resetGrid();

  int leftX = int(cols * 0.25);
  int rightX = int(cols * random(0.55, 0.65));

  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);

  int stemThickness = max(1, round(cols * 0.05));

  // left stem
  for (int y = startY; y <= endY; y++) {
    for (int x = leftX; x < leftX + stemThickness; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // right stem
  for (int y = startY; y <= endY; y++) {
    for (int x = rightX; x < rightX + stemThickness; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // diagonal line
  for (int y = startY; y <= endY; y++) {
    int x = int(map(y, startY, endY, leftX + stemThickness, rightX));
    for (int w = 0; w < stemThickness; w++) {
      if (x + w < cols && random(1) > fillProbability) {
        grid[x + w][y] = true;
        fillSubdivisions(x + w, y);
      }
    }
  }
}

void generateRegularO() {
  resetGrid();

  int leftX = int(cols * 0.25);
  int rightX = int(cols * random(0.55, 0.65));

  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);

  int stemThickness = max(1, round(cols * 0.05));

  // upper horizontal line
  for (int x = leftX; x <= rightX; x++) {
    for (int y = startY; y < startY + stemThickness; y++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // lower horizontal line
  for (int x = leftX; x <= rightX; x++) {
    for (int y = endY - stemThickness; y <= endY; y++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // left stem
  for (int y = startY; y <= endY; y++) {
    for (int x = leftX; x < leftX + stemThickness; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // right stem
  for (int y = startY; y <= endY; y++) {
    for (int x = rightX; x < rightX + stemThickness; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }
}

void generateRegularP() {
  resetGrid();

  int leftX = int(cols * 0.25);
  int rightX = int(cols * random(0.55, 0.65));

  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);

  int stemThickness = max(1, round(cols * 0.05));

  // vertical stem
  for (int y = startY; y <= endY; y++) {
    for (int x = leftX; x < leftX + stemThickness; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // upper horizontal line
  for (int x = leftX; x <= rightX; x++) {
    for (int y = startY; y < startY + stemThickness; y++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // right stem
  for (int y = startY; y <= startY + (endY - startY) / 2; y++) {
    for (int x = rightX; x < rightX + stemThickness; x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // middle horizontal line
  int middleY = startY + (endY - startY) / 2;
  for (int x = leftX; x <= rightX; x++) {
    for (int y = middleY - stemThickness; y <= middleY; y++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }
}

void generateRegularM() {
  resetGrid();

  int leftX = int(cols * random(0.1, 0.2)); // start of left stem
  int rightX = int(cols * random(0.7, 0.8)); // start of right stem
  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);
  int middleY = int(endY * random(0.6, 0.9)); // random point of contact

  int stemThickness = max(1, round(cols * 0.05));
  int middleX = (leftX + rightX) / 2; // center

  // left stem
  for (int y = startY; y <= endY; y++) {
    for (int x = leftX; x < min(leftX + stemThickness, cols); x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // right stem
  for (int y = startY; y <= endY; y++) {
    for (int x = rightX; x < min(rightX + stemThickness, cols); x++) {
      if (random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // left diagonal line
  for (int y = startY; y <= middleY; y++) {
    int x = int(map(y, startY, middleY, leftX + stemThickness, middleX));
    for (int w = 0; w < stemThickness; w++) {
      if (x + w < cols && random(1) > fillProbability) {
        grid[x + w][y] = true;
        fillSubdivisions(x + w, y);
      }
    }
  }

  // right diagonal line
  for (int y = startY; y <= middleY; y++) {
    int x = int(map(y, startY, middleY, rightX, middleX));
    for (int w = 0; w < stemThickness; w++) {
      if (x - w >= 0 && random(1) > fillProbability) {
        grid[x - w][y] = true;
        fillSubdivisions(x - w, y);
      }
    }
  }
}

void generateRegularJ() {
  resetGrid();

  int centerX = int(cols * 0.5); 
  int startY = int(rows * 0.1);
  int endY = int(rows * random(0.75, 0.85));

  int stemThickness = max(1, round(cols * 0.05));

  // vertical stem
  for (int y = startY; y <= endY; y++) {
    for (int x = centerX - stemThickness / 2; x < centerX + stemThickness / 2; x++) {
      if (x >= 0 && x < cols && random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // diagonal line to 40% x and 90% height
  int diagEndX1 = int(cols * 0.43);
  int diagEndY1 = int(rows * random(0.85, 0.95)); // slight randomness in end
  for (int y = endY; y <= diagEndY1; y++) {
    int x = int(map(y, endY, diagEndY1, centerX + stemThickness / 2, diagEndX1)); 
    for (int w = 0; w < stemThickness; w++) {
      if (x - w >= 0 && x - w < cols && random(1) > fillProbability) {
        grid[x - w][y] = true;
        fillSubdivisions(x - w, y);
      }
    }
  }

  // horizontal line to 35% x and 90% height
  int horizEndX = int(cols * 0.35);
  for (int x = diagEndX1; x >= horizEndX; x--) {
    for (int y = diagEndY1 - stemThickness / 2; y < diagEndY1 + stemThickness / 2; y++) {
      if (y >= 0 && y < rows && random(1) > fillProbability) {
        grid[x][y] = true;
        fillSubdivisions(x, y);
      }
    }
  }

  // diagonal line to 30% x and 80% height
  int diagEndX2 = int(cols * 0.3);
  int diagEndY2 = endY;
  for (int y = diagEndY1; y >= diagEndY2; y--) {
    int x = int(map(y, diagEndY1, diagEndY2, horizEndX, diagEndX2));
    for (int w = 0; w < stemThickness; w++) {
      if (x - w >= 0 && x - w < cols && random(1) > fillProbability) {
        grid[x - w][y] = true;
        fillSubdivisions(x - w, y);
      }
    }
  }
}

void generateSpikyV() {
  resetGrid();

  int startY = int(rows * 0.1);
  int endY = int(rows * 0.9);
  int startX = int(cols * 0.2);
  int endX = int(cols * 0.8);

  int stemThickness = max(1, round(cols * 0.05));

  // left diagonal line
  for (int y = startY; y <= endY; y++) {
    int x = int(map(y, startY, endY, startX, (startX + endX) / 2));
    for (int w = 0; w < stemThickness; w++) {
      if (x + w >= 0 && x + w < cols && random(1) > fillProbability) {
        grid[x + w][y] = true;
        fillSubdivisions(x + w, y);
      }
    }
  }

  // right diagonal line
  for (int y = startY; y <= endY; y++) {
    int x = int(map(y, startY, endY, endX, (startX + endX) / 2));
    for (int w = 0; w < stemThickness; w++) {
      if (x - w >= 0 && x - w < cols && random(1) > fillProbability) {
        grid[x - w][y] = true;
        fillSubdivisions(x - w, y);
      }
    }
  }
}

void resetGrid() {
  cellWidth = (float) width / cols;
  cellHeight = (float) height / rows;
  grid = new boolean[cols][rows];
  subdivisions = new int[cols][rows];
  subGrid = new boolean[cols][rows][];
  circleSizes = new float[cols][rows];
  gridChars = new String[cols][rows];
  squareScales = new float[cols][rows];
  squareRotations = new float[cols][rows];

  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      subdivisions[i][j] = int(random(1, 9));
      subGrid[i][j] = new boolean[subdivisions[i][j] * subdivisions[i][j]]; // Inicjalizacja subGrid
      circleSizes[i][j] = random(cellWidth * 0.5, cellWidth * 0.9);
      gridChars[i][j] = asciiChars[int(random(asciiChars.length))];
      squareScales[i][j] = 1.0; 
      squareRotations[i][j] = 0.0; 
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

void distortGrid() {
  boolean[][] newGrid = new boolean[cols][rows];

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      if (grid[x][y]) {
        // random offset in range -1 to 1 for both axes
        int offsetX = int(random(-1, 2)); 
        int offsetY = int(random(-1, 2)); 

        int newX = constrain(x + offsetX, 0, cols - 1);
        int newY = constrain(y + offsetY, 0, rows - 1);

        newGrid[newX][newY] = true;

     
        if (random(1) > 0.5) {
          newGrid[x][y] = true;
        }
      }
    }
  }

  grid = newGrid;
}

void randomizeShapes() {
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
   
      circleSizes[i][j] = random(cellWidth * 0.5, cellWidth * 0.9);
      squareScales[i][j] = random(0.5, 1.5); 
      squareRotations[i][j] = random(TWO_PI); 
    }
  }
}

void setDrawCircles() {
  drawCircles = true;
  drawChars = false;
  drawSubdivisions = false;
  cp5.getController("fillProbability").hide();
  cp5.getController("drawSubdivisions").hide();
}

void setDrawSquares() {
  drawCircles = false;
  drawChars = false;
  drawSubdivisions = false;
  cp5.getController("fillProbability").hide();
  cp5.getController("drawSubdivisions").show();
}

void setDrawChars() {
  drawChars = true;
  drawCircles = false;
  drawSubdivisions = false;
  cp5.getController("fillProbability").hide();
  cp5.getController("drawSubdivisions").hide();
}

void setDrawSubdivisions() {
  drawSubdivisions = true;
  drawCircles = false;
  drawChars = false;
  cp5.getController("fillProbability").show();
}

public void setFillProbability(float value) {
  fillProbability = value;
}
