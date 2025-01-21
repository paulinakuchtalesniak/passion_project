import processing.svg.*; 
import controlP5.*;
import java.util.ArrayList;

int canvasSize = 600;
int apexNumber;            
int letterHeight;
int[][] apexPositions;
int[][][] letterSideDistance;
int[][] horizontalLinePos;
int[][] innerTriangle;
int[][] circlePositions;  

float deformationAmount = 9;     
float baseSegmentsPerLength = 0.85f; 
float lineWidth = 2;     
float dashLength = 5;   
float gapLength = 15;
boolean animateOutline = false; 
float dashOffset = 0; 
int circleRadius = 10;
int selectedCircle = -1; 
ArrayList<ArrayList<PVector>> edgesWithDeformations;
ControlP5 cp5;
float lastDeformationAmount;
float lastBaseSegmentsPerLength;
float lastLineWidth;
boolean showCircles = true;

color[] gradientColors = {
  color(234, 230, 199),
  color(208, 219, 61),
  color(211, 114, 139),
  color(101, 186, 138),
  color(211, 50, 19)
};

void setup() {
  size(600, 600);
  smooth();
  colorMode(HSB, 255);

  apexNumber = generateRandomBetweenOneAndTwo();
  letterHeight = generateHeight();
  apexPositions = generateApexPositions(apexNumber);
  letterSideDistance = generateLegs(letterHeight);
  horizontalLinePos = generateHorizontalLinePos();
  innerTriangle = generateInnerTriangle();
  circlePositions = generateCirclePositions();

  edgesWithDeformations = new ArrayList<ArrayList<PVector>>();
  generateAllEdgesWithDeformation();

  lastDeformationAmount = deformationAmount;
  lastBaseSegmentsPerLength = baseSegmentsPerLength;
  lastLineWidth = lineWidth;

  cp5 = new ControlP5(this);

  int sliderWidth = 80; 
  int sliderHeight = 10; 
  int ySpacing = 30;     
  int startX = 20;       
  int startY = 20;       

  cp5.addSlider("deformationAmount")
     .setPosition(startX, startY)
     .setSize(sliderWidth, sliderHeight)
     .setRange(0, 30)
     .setValue(deformationAmount);

  cp5.addSlider("baseSegmentsPerLength")
     .setPosition(startX, startY + ySpacing)
     .setSize(sliderWidth, sliderHeight)
     .setRange(0.05f, 2.0f)
     .setValue(baseSegmentsPerLength);

  cp5.addSlider("lineWidth")
     .setPosition(startX, startY + 2 * ySpacing)
     .setSize(sliderWidth, sliderHeight)
     .setRange(0.5f, 10.0f)
     .setValue(lineWidth);

  cp5.addSlider("dashLength")
     .setPosition(startX, startY + 3 * ySpacing)
     .setSize(sliderWidth, sliderHeight)
     .setRange(1, 50)
     .setValue(dashLength);

  cp5.addSlider("gapLength")
     .setPosition(startX, startY + 4 * ySpacing)
     .setSize(sliderWidth, sliderHeight)
     .setRange(0.5f, 50f)
     .setValue(gapLength);
     
     
  cp5.addToggle("animateOutline")
     .setPosition(startX, startY + 6 * ySpacing)
     .setSize(40, 15)
     .setValue(false)
     .setLabel("Animate");

cp5.addToggle("showCircles")
   .setPosition(20, startY + 5 * ySpacing) 
   .setSize(40, 15) 
   .setValue(true)
   .setLabel("Show Circles");


  background(30);
}

void draw() {
  background(30, 24, 25);
  if (abs(deformationAmount - lastDeformationAmount) > 0.0001f || abs(baseSegmentsPerLength - lastBaseSegmentsPerLength) > 0.0001f || abs(lineWidth - lastLineWidth) > 0.0001f) {
    generateAllEdgesWithDeformation();
    lastDeformationAmount = deformationAmount;
    lastBaseSegmentsPerLength = baseSegmentsPerLength;
    lastLineWidth = lineWidth;
  }
  if (animateOutline) dashOffset += 0.3;
  if (animateOutline) drawDashedEdges();
  else drawEdges();
 if (showCircles) drawControlCircles();
}

void keyPressed() {
  if (key == 's') {
    beginRecord(SVG, "output.svg");
    background(30, 24, 25);
    if (animateOutline) drawDashedEdges();
    else drawEdges();
    endRecord();
    println("Zapisano do pliku 'output.svg' (bez kółek).");
  }
}

void generateAllEdgesWithDeformation() {
  edgesWithDeformations.clear();
  edgesWithDeformations.add(generateDeformedEdge(circlePositions[9], circlePositions[10]));
  edgesWithDeformations.add(generateDeformedEdge(circlePositions[10], circlePositions[4]));
  edgesWithDeformations.add(generateDeformedEdge(circlePositions[4], circlePositions[0]));
  edgesWithDeformations.add(generateDeformedEdge(circlePositions[0], circlePositions[2]));
  if (apexNumber == 2) {
    edgesWithDeformations.add(generateDeformedEdge(circlePositions[2], circlePositions[3]));
    edgesWithDeformations.add(generateDeformedEdge(circlePositions[3], circlePositions[1]));
  } else {
    edgesWithDeformations.add(generateDeformedEdge(circlePositions[2], circlePositions[1]));
  }
  edgesWithDeformations.add(generateDeformedEdge(circlePositions[1], circlePositions[5]));
  edgesWithDeformations.add(generateDeformedEdge(circlePositions[5], circlePositions[9]));
  edgesWithDeformations.add(generateDeformedEdge(circlePositions[6], circlePositions[7]));
  edgesWithDeformations.add(generateDeformedEdge(circlePositions[7], circlePositions[8]));
  edgesWithDeformations.add(generateDeformedEdge(circlePositions[8], circlePositions[6]));
}

ArrayList<PVector> generateDeformedEdge(int[] start, int[] end) {
  ArrayList<PVector> pts = new ArrayList<PVector>();
  if (start[0] < 0 || start[1] < 0 || end[0] < 0 || end[1] < 0) return pts;
  float edgeLength = dist(start[0], start[1], end[0], end[1]);
  int dynamicSegments = max(2, int(edgeLength * baseSegmentsPerLength)); 
  for (int i = 0; i <= dynamicSegments; i++) {
    float t = map(i, 0, dynamicSegments, 0, 1);
    float x = lerp(start[0], end[0], t);
    float y = lerp(start[1], end[1], t);
    float offsetX = random(-deformationAmount, deformationAmount);
    float offsetY = random(-deformationAmount, deformationAmount);
    x += offsetX;
    y += offsetY;
    pts.add(new PVector(x, y));
  }
  return pts;
}

color interpolateColor(color c1, color c2, float t) {
  float r = lerp(red(c1), red(c2), t);
  float g = lerp(green(c1), green(c2), t);
  float b = lerp(blue(c1), blue(c2), t);
  return color(r, g, b);
}

void drawEdges() {
  stroke(0, 0, 255);
  strokeWeight(lineWidth);
  noFill();
  for (ArrayList<PVector> edge : edgesWithDeformations) {
    if (edge.size() > 1) {
      beginShape();
      for (PVector p : edge) {
        curveVertex(p.x, p.y);
      }
      endShape();
    }
  }
}

void drawDashedEdges() {
  strokeWeight(lineWidth);
  noFill();
  float patternLength = dashLength + gapLength;
  for (ArrayList<PVector> edge : edgesWithDeformations) {
    if (edge.size() < 2) continue;
    float distanceSoFar = 0; 
    PVector prev = edge.get(0);
    for (int i = 1; i < edge.size(); i++) {
      PVector curr = edge.get(i);
      float segLen = dist(prev.x, prev.y, curr.x, curr.y);
      float done = 0; 
      while (done < segLen) {
        float remain = segLen - done;
        float localDist = (distanceSoFar + done + dashOffset) % patternLength;
        float dashRemain = 0;
        if (localDist < dashLength) {
          dashRemain = dashLength - localDist;
        } else {
          dashRemain = patternLength - localDist;
        }
        float step = min(remain, dashRemain);
        float t1 = done / segLen;
        float t2 = (done + step) / segLen;
        float x1 = lerp(prev.x, curr.x, t1);
        float y1 = lerp(prev.y, curr.y, t1);
        float x2 = lerp(prev.x, curr.x, t2);
        float y2 = lerp(prev.y, curr.y, t2);
        if (localDist < dashLength) {
          int colorIndex = int((distanceSoFar + dashOffset) / patternLength) % gradientColors.length;
          stroke(gradientColors[colorIndex]);
          line(x1, y1, x2, y2);
        }
        done += step;
      }
      distanceSoFar += segLen;
      prev = curr;
    }
  }
}

void drawControlCircles() {
 colorMode(RGB); 
  fill(234, 230, 199);
  noStroke();
  for (int i = 0; i < circlePositions.length; i++) {
    if (circlePositions[i][0] < 0 || circlePositions[i][1] < 0) continue;
    ellipse(circlePositions[i][0], circlePositions[i][1], circleRadius * 2, circleRadius * 2);
  }
    colorMode(HSB, 255);
}

void mousePressed() {
  selectedCircle = -1;
  for (int i = 0; i < circlePositions.length; i++) {
    if (circlePositions[i][0] < 0 || circlePositions[i][1] < 0) continue;
    float d = dist(mouseX, mouseY, circlePositions[i][0], circlePositions[i][1]);
    if (d <= circleRadius) {
      selectedCircle = i;
      break;
    }
  }
}

void mouseDragged() {
  if (selectedCircle != -1) {
    circlePositions[selectedCircle][0] = mouseX;
    circlePositions[selectedCircle][1] = mouseY;
  }
}

void mouseReleased() {
  if (selectedCircle != -1) {
    selectedCircle = -1;
    generateAllEdgesWithDeformation();
  }
}

int generateRandomBetweenOneAndTwo() {
  return int(random(1, 3));
}

int generateHeight() {
  return int(random(canvasSize / 1.5, canvasSize));
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
      while (abs(x - firstApexX) > maxDistanceX || y < 0 || y > height || x < 20 || (x == firstApexX && y == firstApexY)) {
        x = int(random(firstApexX, firstApexX + maxDistanceX)); 
        y = int(random(0, 100));                               
      }
    }
    positions[i][0] = x; 
    positions[i][1] = y; 
  }
  return positions;
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

int[][] generateHorizontalLinePos() {
  int[][] horizontalLinePos = new int[2][2]; 
  int highestApexY = height; 
  for (int i = 0; i < apexPositions.length; i++) {
    if (apexPositions[i][1] < highestApexY) {
      highestApexY = apexPositions[i][1];
    }
  }
  int newY = highestApexY + int(0.6 * (letterHeight - highestApexY));
  int unifiedLength = int((letterSideDistance[1][1][0] - letterSideDistance[0][1][0]) / 4);
  horizontalLinePos[0][0] = letterSideDistance[1][1][0] - unifiedLength;
  horizontalLinePos[0][1] = newY;
  horizontalLinePos[1][0] = letterSideDistance[0][1][0] + unifiedLength;
  horizontalLinePos[1][1] = newY;
  return horizontalLinePos;
}

int[][] generateInnerTriangle() {
  int[][] triangle = new int[3][2];
  int centerX = (letterSideDistance[0][1][0] + letterSideDistance[1][1][0]) / 2;
  int baseY = horizontalLinePos[0][1] - 20;
  triangle[0][0] = centerX - 30;
  triangle[0][1] = baseY;
  triangle[1][0] = centerX + 30;
  triangle[1][1] = baseY;
  triangle[2][0] = centerX;
  triangle[2][1] = baseY - 160;
  return triangle;
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
  positions[6][0] = innerTriangle[0][0];
  positions[6][1] = innerTriangle[0][1];
  positions[7][0] = innerTriangle[1][0];
  positions[7][1] = innerTriangle[1][1];
  positions[8][0] = innerTriangle[2][0];
  positions[8][1] = innerTriangle[2][1];
  positions[9][0] = horizontalLinePos[0][0];
  positions[9][1] = horizontalLinePos[0][1];
  positions[10][0] = horizontalLinePos[1][0];
  positions[10][1] = horizontalLinePos[1][1];
  return positions;
}
