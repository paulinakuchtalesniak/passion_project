import processing.svg.*;
import geomerative.*;
import controlP5.*;

ControlP5 cp5;

float distortionRange = 10;
float segments = 1;
boolean isExportingSVG = false; 
boolean distortionChanged = false;
boolean segmentsChanged = false;
int apexNumber;
int letterHeight;
int canvasSize = 600;
int[][] apexPositions;
int[][][] letterSideDistance;
int[][] horizontalLinePos;
int[][] innerTriangle;
int[][] circlePositions;
int circleRadius = 10;
int selectedCircle = -1; 
int buttonX = 20; 
int buttonY = 20; 
int buttonWidth = 100; 
int buttonHeight = 40;
RShape shape;
RPath triangle;
float distortionFactor = 0; 
float[][] finalOffsets; 
int animationDuration = 1000; 
int animationStartTime; 
boolean animationStarted = false;
boolean animationFinished = false;
RPolygon originalPolygon;
int strokeR = 211;
int strokeG = 114;
int strokeB = 139;
boolean isFillEnabled = false; 


void setup() {
  size(600, 600);
  smooth();

  cp5 = new ControlP5(this);

  cp5.addSlider("distortionRange")
     .setPosition(20, 20)
     .setRange(1, 100) 
     .setValue(10)
     .onChange((event) -> {
       distortionRange = event.getController().getValue();
       distortionChanged = true;
     });

  cp5.addSlider("segments")
     .setPosition(420, 20)
     .setRange(1, 30) 
     .setValue(1)
     .onChange((event) -> {
       segments = event.getController().getValue();
       segmentsChanged = true;
     });

  cp5.addButton("TransformLetter")
     .setPosition(20, 60)
     .setSize(120, 40)
     .setCaptionLabel("Save Svg")
     .onClick((event) -> startTransformation());

  cp5.addButton("ResetElement")
     .setPosition(20, 110)
     .setSize(120, 40)
     .setCaptionLabel("Reset")
     .onClick((event) -> resetElement());

  cp5.addButton("Pink")
   .setPosition(20, 160)
   .setSize(55, 40)
   .setColorBackground(color(211, 114, 139)) 
   .setColorForeground(color(255, 255, 255))
   .setColorActive(color(211, 114, 139)) 
   .onClick((event) -> setStrokeColor(211, 114, 139));

cp5.addButton("Lime")
   .setPosition(85, 160)
   .setSize(55, 40)
   .setColorBackground(color(208, 219, 61)) 
   .setColorForeground(color(255, 255, 255)) 
   .setColorActive(color(208, 219, 61)) 
   .onClick((event) -> setStrokeColor(208, 219, 61));

cp5.addButton("White")
   .setPosition(20, 210)
   .setSize(55, 40)
   .setColorBackground(color(234, 230, 199)) 
   .setColorForeground(color(255, 255, 255))
   .setColorActive(color(234, 230, 199))
   .onClick((event) -> setStrokeColor(234, 230, 199));
   
   cp5.addButton("Red")
      .setPosition(85, 210)
   .setSize(55, 40)
   .setColorBackground(color(211, 50, 19)) 
   .setColorForeground(color(255, 255, 255))
   .setColorActive(color(211, 50, 19))
   .onClick((event) -> setStrokeColor(211, 50, 19));
     
     cp5.addToggle("EnableFill")
     .setPosition(20, 310)
     .setSize(50, 25)
     .setValue(false)
     .setCaptionLabel("Fill")
     .onChange((event) -> {
       isFillEnabled = event.getController().getValue() == 1.0;
     });

  RG.init(this);

  apexNumber = generateRandomBetweenOneAndTwo();
  letterHeight = generateHeight();
  apexPositions = generateApexPositions(apexNumber);
  letterSideDistance = generateLegs(letterHeight);
  horizontalLinePos = generateHorizontalLinePos();
  innerTriangle = generateInnerTriangle();
  circlePositions = generateCirclePositions();

  finalOffsets = null; 
  background(30, 24, 25);
  shape = new RShape();
  drawShape();
}


void draw() {
  background(30, 24, 25, 10);

  if (distortionChanged || segmentsChanged) {
    RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
    RCommand.setSegmentLength(segments);

    drawShape();

    distortionChanged = false;
    segmentsChanged = false;
  }

  drawShape();
}

void setStrokeColor(int r, int g, int b) {
  strokeR = r;
  strokeG = g;
  strokeB = b;
}


void polygonizeAndDistort(RPolygon polygon) {
  int totalPoints = countPolygonPoints(polygon);

  if (finalOffsets == null || finalOffsets.length != totalPoints || distortionChanged) {
    finalOffsets = new float[totalPoints][2];

    float noiseOffsetX = random(1000);
    float noiseOffsetY = random(1000);
    int pointIndex = 0;

    for (int i = 0; i < polygon.contours.length; i++) {
      for (int j = 0; j < polygon.contours[i].points.length; j++) {
        float noiseValueX = noise(noiseOffsetX + i * 0.1 + j * 0.1);
        float noiseValueY = noise(noiseOffsetY + i * 0.1 + j * 0.1);
        finalOffsets[pointIndex][0] = map(noiseValueX, 0, 1, -distortionRange, distortionRange);
        finalOffsets[pointIndex][1] = map(noiseValueY, 0, 1, -distortionRange, distortionRange);
        pointIndex++;
      }
    }

    distortionChanged = false;
  }

  int pointIndex = 0;
  for (int i = 0; i < polygon.contours.length; i++) {
    for (int j = 0; j < polygon.contours[i].points.length; j++) {
      RPoint curPoint = polygon.contours[i].points[j];
      curPoint.x += finalOffsets[pointIndex][0];
      curPoint.y += finalOffsets[pointIndex][1];
      pointIndex++;
    }
  }
}

int countPolygonPoints(RPolygon polygon) {
  int count = 0;
  for (int i = 0; i < polygon.contours.length; i++) {
    count += polygon.contours[i].points.length;
  }
  return count;
}

void drawShape() {
  shape = new RShape();

  shape.addMoveTo(horizontalLinePos[0][0], horizontalLinePos[0][1]);
  shape.addLineTo(horizontalLinePos[1][0], horizontalLinePos[1][1]);
  shape.addLineTo(letterSideDistance[0][1][0], letterSideDistance[0][1][1]);
  shape.addLineTo(letterSideDistance[0][0][0], letterSideDistance[0][0][1]);
  shape.addLineTo(apexPositions[0][0], apexPositions[0][1]);
  if (apexNumber == 2) {
    shape.addLineTo(apexPositions[1][0], apexPositions[1][1]);
  }
  shape.addLineTo(letterSideDistance[1][0][0], letterSideDistance[1][0][1]);
  shape.addLineTo(letterSideDistance[1][1][0], letterSideDistance[1][1][1]);
  shape.addLineTo(horizontalLinePos[0][0], horizontalLinePos[0][1]);

  RPath triangle = new RPath(innerTriangle[0][0], innerTriangle[0][1]);
  triangle.addLineTo(innerTriangle[1][0], innerTriangle[1][1]);
  triangle.addLineTo(innerTriangle[2][0], innerTriangle[2][1]);
  triangle.addLineTo(innerTriangle[0][0], innerTriangle[0][1]);
  shape.addPath(triangle);

  originalPolygon = shape.toPolygon();

  RPolygon polygon = copyPolygon(originalPolygon);
  polygonizeAndDistort(polygon);

  noFill();
   noFill();
  if (isFillEnabled) {
    fill(strokeR, strokeG, strokeB);
  }
  stroke(strokeR, strokeG, strokeB);
  strokeWeight(2);
  polygon.draw();

  if (!isExportingSVG) {
    for (int i = 0; i < circlePositions.length; i++) {
      fill(245, 245, 220);
      ellipse(circlePositions[i][0], circlePositions[i][1], circleRadius * 2, circleRadius * 2);
    }
  }
}

RPolygon copyPolygon(RPolygon polygon) {
  RPolygon newPolygon = new RPolygon();
  for (int i = 0; i < polygon.contours.length; i++) {
    RPoint[] points = polygon.contours[i].points;
    RPoint[] newPoints = new RPoint[points.length];
    for (int j = 0; j < points.length; j++) {
      newPoints[j] = new RPoint(points[j].x, points[j].y);
    }
    newPolygon.addContour(newPoints);
  }
  return newPolygon;
}

void mousePressed() {
  selectedCircle = -1;
  for (int i = 0; i < circlePositions.length; i++) {
    float distance = dist(mouseX, mouseY, circlePositions[i][0], circlePositions[i][1]);
    if (distance <= circleRadius) {
      selectedCircle = i;
      println("Clicked circle " + (i + 1));
      break;
    }
  }
}

void mouseDragged() {
  if (selectedCircle != -1) {
    circlePositions[selectedCircle][0] = mouseX;
    circlePositions[selectedCircle][1] = mouseY;
    if (selectedCircle == 0) {
      letterSideDistance[0][0][0] = mouseX;
      letterSideDistance[0][0][1] = mouseY;
    } else if (selectedCircle == 1) {
      letterSideDistance[1][0][0] = mouseX;
      letterSideDistance[1][0][1] = mouseY;
    } else if (selectedCircle == 2) {
      apexPositions[0][0] = mouseX;
      apexPositions[0][1] = mouseY;
    } else if (selectedCircle == 3 && apexNumber == 2) {
      apexPositions[1][0] = mouseX;
      apexPositions[1][1] = mouseY;
    } else if (selectedCircle == 4) {
      letterSideDistance[0][1][0] = mouseX;
      letterSideDistance[0][1][1] = mouseY;
    } else if (selectedCircle == 5) {
      letterSideDistance[1][1][0] = mouseX;
      letterSideDistance[1][1][1] = mouseY;
    } else if (selectedCircle >= 6 && selectedCircle <= 8) {
      innerTriangle[selectedCircle - 6][0] = mouseX;
      innerTriangle[selectedCircle - 6][1] = mouseY;
    } else if (selectedCircle >= 9 && selectedCircle <= 10) {
      horizontalLinePos[selectedCircle - 9][0] = mouseX;
      horizontalLinePos[selectedCircle - 9][1] = mouseY;
    }
  }
}

void resetElement() {
  apexNumber = generateRandomBetweenOneAndTwo();
  letterHeight = generateHeight();
  apexPositions = generateApexPositions(apexNumber);
  letterSideDistance = generateLegs(letterHeight);
  horizontalLinePos = generateHorizontalLinePos();
  innerTriangle = generateInnerTriangle();
  circlePositions = generateCirclePositions();

  animationStarted = false;
  animationFinished = false;
  finalOffsets = null;

  distortionRange = 1;
  segments = 1;

  cp5.getController("distortionRange").setValue(distortionRange);
  cp5.getController("segments").setValue(segments);

  background(30, 24, 25);

  drawShape();

  distortionChanged = true;
  segmentsChanged = true;
}

void startTransformation() {
  exportSVG();
}

void mouseReleased() {
  selectedCircle = -1;
}

void exportSVG() {
  isExportingSVG = true;
  beginRecord(SVG, "updated_letter_A.svg");
  drawShape();
  endRecord();
  isExportingSVG = false;
}

int[][] generateCirclePositions() {
  int[][] positions = new int[11][2];
  positions[0][0] = letterSideDistance[0][0][0];
  positions[0][1] = letterSideDistance[0][0][1];
  positions[1][0] = letterSideDistance[1][0][0];
  positions[1][1] = letterSideDistance[1][0][1];
  positions[2][0] = apexPositions[0][0];
  positions[2][1] = apexPositions[0][1];
  if (apexNumber == 2) {
    positions[3][0] = apexPositions[1][0];
    positions[3][1] = apexPositions[1][1];
  } else {
    positions[3][0] = -1;
    positions[3][1] = -1;
  }
  positions[4][0] = letterSideDistance[0][1][0];
  positions[4][1] = letterSideDistance[0][1][1];
  positions[5][0] = letterSideDistance[1][1][0];
  positions[5][1] = letterSideDistance[1][1][1];
  for (int i = 0; i < 3; i++) {
    positions[6 + i][0] = innerTriangle[i][0];
    positions[6 + i][1] = innerTriangle[i][1];
  }
  positions[9][0] = horizontalLinePos[0][0];
  positions[9][1] = horizontalLinePos[0][1];
  positions[10][0] = horizontalLinePos[1][0];
  positions[10][1] = horizontalLinePos[1][1];
  return positions;
}

int[][] generateInnerTriangle() {
  int[][] triangle = new int[3][2];
  triangle[0][0] = letterSideDistance[0][1][0] + int(random(0, 45));
  triangle[0][1] = int(random(horizontalLinePos[0][1] - 30, horizontalLinePos[0][1] - 10));
  triangle[1][0] = letterSideDistance[1][1][0] - int(random(0, 45));
  triangle[1][1] = int(random(horizontalLinePos[0][1] - 30, horizontalLinePos[0][1] - 10));
  triangle[2][0] = apexPositions[0][0];
  triangle[2][1] = apexPositions[0][1] + int(random(40, 120));
  return triangle;
}

int[][] generateHorizontalLinePos() {
    int[][] horizontalLinePos = new int[2][2]; 

    int highestApexY = height; 
    if (apexPositions.length == 1) {
        highestApexY = apexPositions[0][1]; 
    } else {
        for (int i = 0; i < apexPositions.length; i++) {
            if (apexPositions[i][1] < highestApexY) {
                highestApexY = apexPositions[i][1];
            }
        }
    }

    int randomPercentage = generateRandomPercentage(); 
    int newY = highestApexY + int((randomPercentage / 100.0) * (letterHeight - highestApexY));
    int unifiedLength = int(random(10, 30));
    horizontalLinePos[0][0] = letterSideDistance[1][1][0] - unifiedLength;
    horizontalLinePos[0][1] = newY;
    horizontalLinePos[1][0] = letterSideDistance[0][1][0] + unifiedLength;
    horizontalLinePos[1][1] = newY;

    println(letterSideDistance[1][0][0], horizontalLinePos[0][0], horizontalLinePos[1][0]);

    return horizontalLinePos;
}

int generateRandomPercentage(){
     return int(random(70, 80));
}

int[][][] generateLegs(int letterHeight) {
    int[][][] legs = new int[2][2][2]; 

     int unifiedLeg = int(random(50, 100));
    legs[0][0][0] = int(random(50, 200)); 
    legs[0][0][1] = letterHeight;       
    legs[0][1][0] = legs[0][0][0] + unifiedLeg;
    legs[0][1][1] = letterHeight;

    legs[1][0][0] = int(random(400, 550));
    legs[1][0][1] = letterHeight;         
    legs[1][1][0] = legs[1][0][0] - unifiedLeg;
    legs[1][1][1] = letterHeight;  

    return legs;
}

int generateRandomBetweenOneAndTwo() {
     return int(random(1, 3));
}

int generateHeight() {
     return int(random(canvasSize/1.5, canvasSize));
}

int[][] generateApexPositions(int numberOfApexes) {
    int[][] positions = new int[numberOfApexes][2]; 

for (int i = 0; i < numberOfApexes; i++) {
    int x = int(random(250, 350));
    int y = int(random(0, 100));

    if (i == 1) { 
        int firstApexX = positions[0][0];
        int firstApexY = positions[0][1];
        int maxDistanceX = 80; 
        x = int(random(max(20, firstApexX), firstApexX + maxDistanceX));
        while (
            abs(x - firstApexX) > maxDistanceX || 
            y < 0 || y > height ||              
            x < 20 ||                            
            (x == firstApexX && y == firstApexY)
        ) {
            x = int(random(firstApexX, firstApexX + maxDistanceX)); 
            y = int(random(0, 100));                               
        }
    }

    
    positions[i][0] = x; 
    positions[i][1] = y; 
}
    return positions;
}
