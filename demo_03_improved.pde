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
String currentLetter = "A";

int[][] vApexPositions;
int[][][] vSideDistance;
int[] vApexTopControl;
int vApexNumber;


int randomVLegsDistanceX = int(random(100, 200));

color[] gradientColors = {
  color(234, 230, 199),
  color(208, 219, 61),
  color(211, 114, 139),
  color(101, 186, 138),
  color(211, 50, 19)
};

int[] eMiddleHorizontalEnd;
int[] eBaselineEnd;

int[][] jTopPoints;
int[] jStemEnd;
int[] jCurveControl;
int[] jCurveEnd;
int[] jInnerCurveControl;
int[] jCurveControl2;
int[] jConnectingPoint;
int[] jInnerCurveControl2;

int[] point10;
int[] point11;

int[][] eBackbonePositions;
int[][] eTopLinePositions;
int[][] eMiddleLinePositions;
int[][] eBottomLinePositions;

int[][] iTopPositions;
int[][] iBottomPositions;

int[][] nPoints;

int[][] dOuterPoints;
int[][] dInnerPoints;

boolean isRecording = false;

PGraphics pg;

int frameCount = 0; 

void setup() {
  size(600, 600, P2D);
  smooth();
  colorMode(HSB, 255);

  pg = createGraphics(width, height);

  initializeLetterA();

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

cp5.addToggle("recordToggle")
   .setPosition(20, 500)
   .setSize(50, 50)
   .setValue(false)
   .setLabel("Record");
}

void draw() {
  background(29, 22, 23);
  pg.beginDraw();
  pg.clear(); 
  pg.background(0, 0, 0, 0); 

  pg.colorMode(HSB, 255);
  pg.strokeWeight(lineWidth);

  if (abs(deformationAmount - lastDeformationAmount) > 0.0001f || abs(baseSegmentsPerLength - lastBaseSegmentsPerLength) > 0.0001f || abs(lineWidth - lastLineWidth) > 0.0001f) {
    generateAllEdgesWithDeformation();
    lastDeformationAmount = deformationAmount;
    lastBaseSegmentsPerLength = baseSegmentsPerLength;
    lastLineWidth = lineWidth;
  }
  if (animateOutline) dashOffset += 0.3;
  if (animateOutline) drawDashedEdgesOnGraphics(pg);
  else drawEdgesOnGraphics(pg);
 if (showCircles) drawControlCirclesOnGraphics(pg);

  pg.endDraw();
  image(pg, 0, 0);

  if (isRecording) {
    pg.save("frames/frame-" + frameCount + ".png"); 
    frameCount++;
  }
}

void keyPressed() {
  if (key == 's') {
    beginRecord(SVG, "output.svg");
      background(29, 22, 23);
    if (animateOutline) drawDashedEdges();
    else drawEdges();
    endRecord();
    println("Zapisano do pliku 'output.svg' (bez kółek).");
  } else if (key == 'A' || key == 'a') {
    currentLetter = "A";
    initializeLetterA();
    circlePositions = generateCirclePositions();
    generateAllEdgesWithDeformation();
  } else if (key == 'V' || key == 'v') {
    currentLetter = "V";
    initializeLetterV();
    circlePositions = generateCirclePositions();
    generateAllEdgesWithDeformation();
  }
  else if (key == 'E' || key == 'e') { 
    currentLetter = "E";
    initializeLetterE();
    circlePositions = generateCirclePositions();
    generateAllEdgesWithDeformation();
  } else if (key == 'F' || key == 'f') {
    currentLetter = "F";
    initializeLetterF();
    circlePositions = generateCirclePositions();
    generateAllEdgesWithDeformation();
  } else if (key == 'J' || key == 'j') {
    currentLetter = "J";
    initializeLetterJ();
    circlePositions = generateCirclePositions();
    generateAllEdgesWithDeformation();
  } else if (key == 'I' || key == 'i') {
    currentLetter = "I";
    initializeLetterI();
    circlePositions = generateCirclePositions();
    generateAllEdgesWithDeformation();
  } else if (key == 'N' || key == 'n') {
    currentLetter = "N";
    initializeLetterN();
    circlePositions = generateCirclePositions();
    generateAllEdgesWithDeformation();
  } else if (key == 'D' || key == 'd') {
    currentLetter = "D";
    initializeLetterD();
    circlePositions = generateCirclePositions();
    generateAllEdgesWithDeformation();
  }
}

void generateAllEdgesWithDeformation() {
  edgesWithDeformations.clear();
  
  if (currentLetter.equals("A")) {
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
  } else if (currentLetter.equals("V")) {
    if (vApexNumber == 1) {
      edgesWithDeformations.add(generateDeformedEdge(vSideDistance[0][0], vSideDistance[0][1]));
      edgesWithDeformations.add(generateDeformedEdge(vSideDistance[0][1], vApexTopControl));
      edgesWithDeformations.add(generateDeformedEdge(vApexTopControl, vSideDistance[1][1]));
      edgesWithDeformations.add(generateDeformedEdge(vSideDistance[1][1], vSideDistance[1][0]));
      edgesWithDeformations.add(generateDeformedEdge(vSideDistance[1][0], vApexPositions[0]));
      edgesWithDeformations.add(generateDeformedEdge(vApexPositions[0], vSideDistance[0][0]));
    } else {
      edgesWithDeformations.add(generateDeformedEdge(vSideDistance[0][0], vSideDistance[0][1]));
      edgesWithDeformations.add(generateDeformedEdge(vSideDistance[0][1], vApexTopControl));
      edgesWithDeformations.add(generateDeformedEdge(vApexTopControl, vSideDistance[1][1]));
      edgesWithDeformations.add(generateDeformedEdge(vSideDistance[1][1], vSideDistance[1][0]));
      edgesWithDeformations.add(generateDeformedEdge(vSideDistance[1][0], vApexPositions[1]));
      edgesWithDeformations.add(generateDeformedEdge(vApexPositions[1], vApexPositions[0]));
      edgesWithDeformations.add(generateDeformedEdge(vApexPositions[0], vSideDistance[0][0]));
    }
  } else if (currentLetter.equals("E")) {
  edgesWithDeformations.add(generateDeformedEdge(eBackbonePositions[0], eBackbonePositions[1]));
    
    edgesWithDeformations.add(generateDeformedEdge(eBackbonePositions[1], eTopLinePositions[0]));
    edgesWithDeformations.add(generateDeformedEdge(eTopLinePositions[0], eTopLinePositions[1]));
    edgesWithDeformations.add(generateDeformedEdge(eTopLinePositions[1], eTopLinePositions[2]));

    edgesWithDeformations.add(generateDeformedEdge(eTopLinePositions[2], eMiddleLinePositions[0]));
    
    edgesWithDeformations.add(generateDeformedEdge(eMiddleLinePositions[0], eMiddleLinePositions[1]));
    edgesWithDeformations.add(generateDeformedEdge(eMiddleLinePositions[1], eMiddleLinePositions[2]));
    
    edgesWithDeformations.add(generateDeformedEdge(eMiddleLinePositions[2], eMiddleHorizontalEnd));
    
    edgesWithDeformations.add(generateDeformedEdge(eMiddleHorizontalEnd, eBottomLinePositions[0]));
    
    edgesWithDeformations.add(generateDeformedEdge(eBottomLinePositions[0], eBottomLinePositions[1]));
    edgesWithDeformations.add(generateDeformedEdge(eBottomLinePositions[1], eBottomLinePositions[2]));
    
    edgesWithDeformations.add(generateDeformedEdge(eBottomLinePositions[2], eBackbonePositions[0]));
  
  } else if (currentLetter.equals("F")) {
    edgesWithDeformations.add(generateDeformedEdge(eBackbonePositions[0], eBackbonePositions[1]));
    

    edgesWithDeformations.add(generateDeformedEdge(eBackbonePositions[1], eTopLinePositions[0]));
    edgesWithDeformations.add(generateDeformedEdge(eTopLinePositions[0], eTopLinePositions[1]));
    edgesWithDeformations.add(generateDeformedEdge(eTopLinePositions[1], eTopLinePositions[2]));
    
 
    edgesWithDeformations.add(generateDeformedEdge(eTopLinePositions[2], eMiddleLinePositions[0]));

    edgesWithDeformations.add(generateDeformedEdge(eMiddleLinePositions[0], eMiddleLinePositions[1]));
    edgesWithDeformations.add(generateDeformedEdge(eMiddleLinePositions[1], eMiddleLinePositions[2]));
    
  
    edgesWithDeformations.add(generateDeformedEdge(eMiddleLinePositions[2], eMiddleHorizontalEnd));
 
    edgesWithDeformations.add(generateDeformedEdge(eMiddleHorizontalEnd, eBaselineEnd));
    

    edgesWithDeformations.add(generateDeformedEdge(eBaselineEnd, eBackbonePositions[0]));
  } else if (currentLetter.equals("J")) {
    
    edgesWithDeformations.add(generateDeformedEdge(jTopPoints[0], jTopPoints[1]));
    edgesWithDeformations.add(generateDeformedEdge(jTopPoints[1], jStemEnd));
    edgesWithDeformations.add(generateDeformedEdge(jStemEnd, jCurveEnd));
    edgesWithDeformations.add(generateDeformedEdge(jCurveEnd, jCurveControl));
    edgesWithDeformations.add(generateDeformedEdge(jCurveControl, jCurveControl2));
    edgesWithDeformations.add(generateDeformedEdge(jCurveControl2, jConnectingPoint));
    edgesWithDeformations.add(generateDeformedEdge(jConnectingPoint, jInnerCurveControl));
    edgesWithDeformations.add(generateDeformedEdge(jInnerCurveControl, jInnerCurveControl2));
    edgesWithDeformations.add(generateDeformedEdge(jInnerCurveControl2, point10));
    edgesWithDeformations.add(generateDeformedEdge(point10, point11));
    edgesWithDeformations.add(generateDeformedEdge(point11, jTopPoints[0]));
  } else if (currentLetter.equals("I")) {
    
    edgesWithDeformations.add(generateDeformedEdge(iTopPositions[0], iTopPositions[1]));
    edgesWithDeformations.add(generateDeformedEdge(iBottomPositions[0], iBottomPositions[1]));
    
    
    edgesWithDeformations.add(generateDeformedEdge(iTopPositions[0], iBottomPositions[0]));
    edgesWithDeformations.add(generateDeformedEdge(iTopPositions[1], iBottomPositions[1]));
  } else if (currentLetter.equals("N")) {
  
    edgesWithDeformations.add(generateDeformedEdge(nPoints[0], nPoints[1]));
    edgesWithDeformations.add(generateDeformedEdge(nPoints[1], nPoints[2]));
    edgesWithDeformations.add(generateDeformedEdge(nPoints[2], nPoints[3]));
    edgesWithDeformations.add(generateDeformedEdge(nPoints[3], nPoints[4]));
    edgesWithDeformations.add(generateDeformedEdge(nPoints[4], nPoints[5]));
    edgesWithDeformations.add(generateDeformedEdge(nPoints[5], nPoints[6]));
    edgesWithDeformations.add(generateDeformedEdge(nPoints[6], nPoints[7]));
    edgesWithDeformations.add(generateDeformedEdge(nPoints[7], nPoints[8]));
    edgesWithDeformations.add(generateDeformedEdge(nPoints[8], nPoints[9]));
    edgesWithDeformations.add(generateDeformedEdge(nPoints[9], nPoints[0]));
  } else if (currentLetter.equals("D")) {
   
    for (int i = 0; i < dOuterPoints.length - 1; i++) {
      edgesWithDeformations.add(generateDeformedEdge(dOuterPoints[i], dOuterPoints[i + 1]));
    }
    edgesWithDeformations.add(generateDeformedEdge(dOuterPoints[dOuterPoints.length - 1], dOuterPoints[0]));

    for (int i = 0; i < dInnerPoints.length - 1; i++) {
      edgesWithDeformations.add(generateDeformedEdge(dInnerPoints[i], dInnerPoints[i + 1]));
    }
    edgesWithDeformations.add(generateDeformedEdge(dInnerPoints[dInnerPoints.length - 1], dInnerPoints[0]));
  }
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

void drawEdgesOnGraphics(PGraphics g) {
  g.stroke(0, 0, 255);
  g.noFill();
  for (ArrayList<PVector> edge : edgesWithDeformations) {
    if (edge.size() > 1) {
      g.beginShape();
      for (PVector p : edge) {
        g.curveVertex(p.x, p.y);
      }
      g.endShape();
    }
  }
}

void drawDashedEdgesOnGraphics(PGraphics g) {
  g.strokeWeight(lineWidth);
  g.noFill();
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
          g.stroke(gradientColors[colorIndex]);
          g.line(x1, y1, x2, y2);
        }
        done += step;
      }
      distanceSoFar += segLen;
      prev = curr;
    }
  }
}

void drawControlCirclesOnGraphics(PGraphics g) {
  g.colorMode(RGB); 
  g.fill(234, 230, 199);
  g.noStroke();
  for (int i = 0; i < circlePositions.length; i++) {
    if (circlePositions[i][0] < 0 || circlePositions[i][1] < 0) continue;
    g.ellipse(circlePositions[i][0], circlePositions[i][1], circleRadius * 2, circleRadius * 2);
  }
  g.colorMode(HSB, 255);
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
  if (selectedCircle != -1 && selectedCircle < circlePositions.length) {
    int x = mouseX;
    int y = mouseY;
    circlePositions[selectedCircle][0] = x;
    circlePositions[selectedCircle][1] = y;
    
    if (currentLetter.equals("A")) {
      switch (selectedCircle) {
        case 0:
          letterSideDistance[0][0][0] = x;
          letterSideDistance[0][0][1] = y;
          break;
        case 1:
          letterSideDistance[1][0][0] = x;
          letterSideDistance[1][0][1] = y;
          break;
        case 2:
          apexPositions[0][0] = x;
          apexPositions[0][1] = y;
          break;
        case 3:
          if (apexNumber == 2) {
            apexPositions[1][0] = x;
            apexPositions[1][1] = y;
          }
          break;
        case 4:
          letterSideDistance[0][1][0] = x;
          letterSideDistance[0][1][1] = y;
          break;
        case 5:
          letterSideDistance[1][1][0] = x;
          letterSideDistance[1][1][1] = y;
          break;
        case 6:
          innerTriangle[0][0] = x;
          innerTriangle[0][1] = y;
          break;
        case 7:
          innerTriangle[1][0] = x;
          innerTriangle[1][1] = y;
          break;
        case 8:
          innerTriangle[2][0] = x;
          innerTriangle[2][1] = y;
          break;
        case 9:
          horizontalLinePos[0][0] = x;
          horizontalLinePos[0][1] = y;
          break;
        case 10:
          horizontalLinePos[1][0] = x;
          horizontalLinePos[1][1] = y;
          break;
      }
    } else if (currentLetter.equals("V")) {
      switch (selectedCircle) {
        case 0:
          vApexPositions[0][0] = x;
          vApexPositions[0][1] = y;
          break;
        case 1:
          if (vApexNumber == 2) {
            vApexPositions[1][0] = x;
            vApexPositions[1][1] = y;
          }
          break;
        case 2:
          vSideDistance[0][0][0] = x;
          vSideDistance[0][0][1] = y;
          break;
        case 3:
          vSideDistance[0][1][0] = x;
          vSideDistance[0][1][1] = y;
          break;
        case 4:
          vApexTopControl[0] = x;
          vApexTopControl[1] = y;
          break;
        case 5:
          vSideDistance[1][1][0] = x;
          vSideDistance[1][1][1] = y;
          break;
        case 6:
          vSideDistance[1][0][0] = x;
          vSideDistance[1][0][1] = y;
          break;
      }
    } else if (currentLetter.equals("E")) {
      switch (selectedCircle) {
        case 0:
          eBackbonePositions[0][0] = x;
          eBackbonePositions[0][1] = y;
          break;
        case 1:
          eBackbonePositions[1][0] = x;
          eBackbonePositions[1][1] = y;
          break;
        case 2:
          eTopLinePositions[0][0] = x;
          eTopLinePositions[0][1] = y;
          break;
        case 3:
          eTopLinePositions[1][0] = x;
          eTopLinePositions[1][1] = y;
          break;
        case 4:
          eTopLinePositions[2][0] = x;
          eTopLinePositions[2][1] = y;
          break;
        case 5:
          eMiddleLinePositions[0][0] = x;
          eMiddleLinePositions[0][1] = y;
          break;
        case 6:
          eMiddleLinePositions[1][0] = x;
          eMiddleLinePositions[1][1] = y;
          break;
        case 7:
          eMiddleLinePositions[2][0] = x;
          eMiddleLinePositions[2][1] = y;
          break;
        case 8:
          eMiddleHorizontalEnd[0] = x;
          eMiddleHorizontalEnd[1] = y;
          break;
        case 9:
          eBottomLinePositions[0][0] = x;
          eBottomLinePositions[0][1] = y;
          break;
        case 10:
          eBottomLinePositions[1][0] = x;
          eBottomLinePositions[1][1] = y;
          break;
        case 11:
          eBottomLinePositions[2][0] = x;
          eBottomLinePositions[2][1] = y;
          break;
      }
    } else if (currentLetter.equals("F")) {
      switch (selectedCircle) {
        case 0:
          eBackbonePositions[0][0] = x;
          eBackbonePositions[0][1] = y;
          break;
        case 1:
          eBackbonePositions[1][0] = x;
          eBackbonePositions[1][1] = y;
          break;
        case 2:
          eTopLinePositions[0][0] = x;
          eTopLinePositions[0][1] = y;
          break;
        case 3:
          eTopLinePositions[1][0] = x;
          eTopLinePositions[1][1] = y;
          break;
        case 4:
          eTopLinePositions[2][0] = x;
          eTopLinePositions[2][1] = y;
          break;
        case 5:
          eMiddleLinePositions[0][0] = x;
          eMiddleLinePositions[0][1] = y;
          break;
        case 6:
          eMiddleLinePositions[1][0] = x;
          eMiddleLinePositions[1][1] = y;
          break;
        case 7:
          eMiddleLinePositions[2][0] = x;
          eMiddleLinePositions[2][1] = y;
          break;
        case 8:
          eMiddleHorizontalEnd[0] = x;
          eMiddleHorizontalEnd[1] = y;
          break;
        case 9:
          eBaselineEnd[0] = x;
          eBaselineEnd[1] = y;
          break;
      }
    } else if (currentLetter.equals("J")) {
      switch (selectedCircle) {
        case 0:
          jTopPoints[0][0] = x;
          jTopPoints[0][1] = y;
          break;
        case 1:
          jTopPoints[1][0] = x;
          jTopPoints[1][1] = y;
          break;
        case 2:
          jStemEnd[0] = x;
          jStemEnd[1] = y;
          break;
        case 3:
          jCurveEnd[0] = x;
          jCurveEnd[1] = y;
          break;
        case 4:
          jCurveControl[0] = x;
          jCurveControl[1] = y;
          break;
        case 5:
          jCurveControl2[0] = x;
          jCurveControl2[1] = y;
          break;
        case 6:
          jConnectingPoint[0] = x;
          jConnectingPoint[1] = y;
          break;
        case 7:
          jInnerCurveControl[0] = x;
          jInnerCurveControl[1] = y;
          break;
        case 8:
          jInnerCurveControl2[0] = x;
          jInnerCurveControl2[1] = y;
          break;
        case 9:
          point10[0] = x;
          point10[1] = y;
          break;
        case 10:
          point11[0] = x;
          point11[1] = y;
          break;
      }
    } else if (currentLetter.equals("I")) {
      switch (selectedCircle) {
        case 0:
          iTopPositions[0][0] = x;
          iTopPositions[0][1] = y;
          break;
        case 1:
          iTopPositions[1][0] = x;
          iTopPositions[1][1] = y;
          break;
        case 2:
          iBottomPositions[0][0] = x;
          iBottomPositions[0][1] = y;
          break;
        case 3:
          iBottomPositions[1][0] = x;
          iBottomPositions[1][1] = y;
          break;
      }
    } else if (currentLetter.equals("N")) {
      switch (selectedCircle) {
        case 0:
          nPoints[0][0] = x;
          nPoints[0][1] = y;
          break;
        case 1:
          nPoints[1][0] = x;
          nPoints[1][1] = y;
          break;
        case 2:
          nPoints[2][0] = x;
          nPoints[2][1] = y;
          break;
        case 3:
          nPoints[3][0] = x;
          nPoints[3][1] = y;
          break;
        case 4:
          nPoints[4][0] = x;
          nPoints[4][1] = y;
          break;
        case 5:
          nPoints[5][0] = x;
          nPoints[5][1] = y;
          break;
        case 6:
          nPoints[6][0] = x;
          nPoints[6][1] = y;
          break;
        case 7:
          nPoints[7][0] = x;
          nPoints[7][1] = y;
          break;
        case 8:
          nPoints[8][0] = x;
          nPoints[8][1] = y;
          break;
        case 9:
          nPoints[9][0] = x;
          nPoints[9][1] = y;
          break;
      }
    } else if (currentLetter.equals("D")) {
      if (selectedCircle < dOuterPoints.length) {
        dOuterPoints[selectedCircle][0] = x;
        dOuterPoints[selectedCircle][1] = y;
      } else {
        dInnerPoints[selectedCircle - dOuterPoints.length][0] = x;
        dInnerPoints[selectedCircle - dOuterPoints.length][1] = y;
      }
    }
    generateAllEdgesWithDeformation(); 
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
    int x = int(random(280, 320));
    int y = 100;
    if (i == 1) { 
      int firstApexX = positions[0][0];
      int firstApexY = positions[0][1];
      int maxDistanceX = 30; 
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
  legs[0][0][1] = 500;       
  legs[0][1][0] = legs[0][0][0] + unifiedLeg;
  legs[0][1][1] = 500;
  legs[1][0][0] = int(random(400, 550));
  legs[1][0][1] = 500;         
  legs[1][1][0] = legs[1][0][0] - unifiedLeg;
  legs[1][1][1] = 500;  
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
  triangle[2][0] = apexPositions[0][0];
  triangle[2][1] = baseY - int(random(100, 160));
  return triangle;
}

int[][] generateCirclePositions() {
    int[][] positions;
    
    if (currentLetter.equals("A")) {
        positions = new int[11][2];
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
    } else if (currentLetter.equals("V")) {
        positions = new int[7][2];
        positions[0][0] = vApexPositions[0][0];
        positions[0][1] = vApexPositions[0][1];
        if (vApexNumber == 2) {
            positions[1][0] = vApexPositions[1][0];
            positions[1][1] = vApexPositions[1][1];
        } else {
            positions[1][0] = -1;
            positions[1][1] = -1;
        }
        positions[2][0] = vSideDistance[0][0][0];
        positions[2][1] = vSideDistance[0][0][1];
        positions[3][0] = vSideDistance[0][1][0];
        positions[3][1] = vSideDistance[0][1][1];
        positions[4][0] = vApexTopControl[0];
        positions[4][1] = vApexTopControl[1];
        positions[5][0] = vSideDistance[1][1][0];
        positions[5][1] = vSideDistance[1][1][1];
        positions[6][0] = vSideDistance[1][0][0];
        positions[6][1] = vSideDistance[1][0][1];
    } else if (currentLetter.equals("E")) {
        positions = new int[12][2];
        positions[0][0] = eBackbonePositions[0][0];
        positions[0][1] = eBackbonePositions[0][1];
        positions[1][0] = eBackbonePositions[1][0];
        positions[1][1] = eBackbonePositions[1][1];
        positions[2][0] = eTopLinePositions[0][0];
        positions[2][1] = eTopLinePositions[0][1];
        positions[3][0] = eTopLinePositions[1][0];
        positions[3][1] = eTopLinePositions[1][1];
        positions[4][0] = eTopLinePositions[2][0];
        positions[4][1] = eTopLinePositions[2][1];
        positions[5][0] = eMiddleLinePositions[0][0];
        positions[5][1] = eMiddleLinePositions[0][1];
        positions[6][0] = eMiddleLinePositions[1][0];
        positions[6][1] = eMiddleLinePositions[1][1];
        positions[7][0] = eMiddleLinePositions[2][0];
        positions[7][1] = eMiddleLinePositions[2][1];
        positions[8][0] = eMiddleHorizontalEnd[0];
        positions[8][1] = eMiddleHorizontalEnd[1];
        positions[9][0] = eBottomLinePositions[0][0];
        positions[9][1] = eBottomLinePositions[0][1];
        positions[10][0] = eBottomLinePositions[1][0];
        positions[10][1] = eBottomLinePositions[1][1];
        positions[11][0] = eBottomLinePositions[2][0];
        positions[11][1] = eBottomLinePositions[2][1];
    } else if (currentLetter.equals("F")) {
        positions = new int[10][2];
        positions[0][0] = eBackbonePositions[0][0];
        positions[0][1] = eBackbonePositions[0][1];
        positions[1][0] = eBackbonePositions[1][0];
        positions[1][1] = eBackbonePositions[1][1];
        positions[2][0] = eTopLinePositions[0][0];
        positions[2][1] = eTopLinePositions[0][1];
        positions[3][0] = eTopLinePositions[1][0];
        positions[3][1] = eTopLinePositions[1][1];
        positions[4][0] = eTopLinePositions[2][0];
        positions[4][1] = eTopLinePositions[2][1];
        positions[5][0] = eMiddleLinePositions[0][0];
        positions[5][1] = eMiddleLinePositions[0][1];
        positions[6][0] = eMiddleLinePositions[1][0];
        positions[6][1] = eMiddleLinePositions[1][1];
        positions[7][0] = eMiddleLinePositions[2][0];
        positions[7][1] = eMiddleLinePositions[2][1];
        positions[8][0] = eMiddleHorizontalEnd[0];
        positions[8][1] = eMiddleHorizontalEnd[1];
        positions[9][0] = eBaselineEnd[0];
        positions[9][1] = eBaselineEnd[1];
    } else if (currentLetter.equals("J")) {
        positions = new int[11][2];
        positions[0][0] = jTopPoints[0][0];
        positions[0][1] = jTopPoints[0][1];
        positions[1][0] = jTopPoints[1][0];
        positions[1][1] = jTopPoints[1][1];
        positions[2][0] = jStemEnd[0];
        positions[2][1] = jStemEnd[1];
        positions[3][0] = jCurveEnd[0];
        positions[3][1] = jCurveEnd[1];
        positions[4][0] = jCurveControl[0];
        positions[4][1] = jCurveControl[1];
        positions[5][0] = jCurveControl2[0];
        positions[5][1] = jCurveControl2[1];
        positions[6][0] = jConnectingPoint[0];
        positions[6][1] = jConnectingPoint[1];
        positions[7][0] = jInnerCurveControl[0];
        positions[7][1] = jInnerCurveControl[1];
        positions[8][0] = jInnerCurveControl2[0];
        positions[8][1] = jInnerCurveControl2[1];
        positions[9][0] = point10[0];
        positions[9][1] = point10[1];
        positions[10][0] = point11[0];
        positions[10][1] = point11[1];
    } else if (currentLetter.equals("I")) {
        positions = new int[4][2];
        positions[0][0] = iTopPositions[0][0];
        positions[0][1] = iTopPositions[0][1];
        positions[1][0] = iTopPositions[1][0];
        positions[1][1] = iTopPositions[1][1];
        positions[2][0] = iBottomPositions[0][0];
        positions[2][1] = iBottomPositions[0][1];
        positions[3][0] = iBottomPositions[1][0];
        positions[3][1] = iBottomPositions[1][1];
    } else if (currentLetter.equals("N")) {
        positions = new int[10][2];
        positions[0][0] = nPoints[0][0];
        positions[0][1] = nPoints[0][1];
        positions[1][0] = nPoints[1][0];
        positions[1][1] = nPoints[1][1];
        positions[2][0] = nPoints[2][0];
        positions[2][1] = nPoints[2][1];
        positions[3][0] = nPoints[3][0];
        positions[3][1] = nPoints[3][1];
        positions[4][0] = nPoints[4][0];
        positions[4][1] = nPoints[4][1];
        positions[5][0] = nPoints[5][0];
        positions[5][1] = nPoints[5][1];
        positions[6][0] = nPoints[6][0];
        positions[6][1] = nPoints[6][1];
        positions[7][0] = nPoints[7][0];
        positions[7][1] = nPoints[7][1];
        positions[8][0] = nPoints[8][0];
        positions[8][1] = nPoints[8][1];
        positions[9][0] = nPoints[9][0];
        positions[9][1] = nPoints[9][1];
    } else if (currentLetter.equals("D")) {
        positions = new int[14][2];
        for (int i = 0; i < 7; i++) {
            positions[i][0] = dOuterPoints[i][0];
            positions[i][1] = dOuterPoints[i][1];
            positions[i + 7][0] = dInnerPoints[i][0];
            positions[i + 7][1] = dInnerPoints[i][1];
        }
    } else {
        positions = new int[0][0]; 
    }
    
    return positions;
}

void initializeLetterV() {
    vApexPositions = new int[2][2];
    vSideDistance = new int[2][2][2];
    vApexTopControl = new int[2];
    
    vApexNumber = random(1) > 0.5 ? 2 : 1;
    

    vApexPositions[0][0] = width / 2; 
    vApexPositions[0][1] = canvasSize - 100;
    
    if (vApexNumber == 2) {
        vApexPositions[1][0] = width / 2 + int(random(30, 60));
        vApexPositions[1][1] = canvasSize - int(random(40, 140));
    }
    
    vApexTopControl[0] = vApexPositions[0][0];
    vApexTopControl[1] = vApexPositions[0][1] - int(random(50, 100));
    
   
    vSideDistance[0][0][0] = width / 2 - randomVLegsDistanceX;
    vSideDistance[0][0][1] = 100;
    vSideDistance[0][1][0] = vSideDistance[0][0][0] + int(random(30, 60));
    vSideDistance[0][1][1] = 100;
    
   
    vSideDistance[1][0][0] = width / 2 + randomVLegsDistanceX;
    vSideDistance[1][0][1] = 100;
    vSideDistance[1][1][0] = vSideDistance[1][0][0] - int(random(30, 60));
    vSideDistance[1][1][1] = 100;
}
void initializeLetterA() {
  apexNumber = generateRandomBetweenOneAndTwo();
  letterHeight = generateHeight();
  apexPositions = generateApexPositions(apexNumber);
  letterSideDistance = generateLegs(letterHeight);
  horizontalLinePos = generateHorizontalLinePos();
  innerTriangle = generateInnerTriangle();
  circlePositions = generateCirclePositions();

 
 

  edgesWithDeformations = new ArrayList<ArrayList<PVector>>();
  generateAllEdgesWithDeformation();
}


void initializeLetterE() {
    float capHeightY = 100;
    float baselineY = 500;
    float canvasSizePart = canvasSize / 10.0f;
    float stemWidth = random(20, 40); 
    float horizontalCenterLineY = 50; 
    float shortEnd = 250 + random(0, 50); 

    float middleY = capHeightY + ((baselineY - capHeightY) * (horizontalCenterLineY / 100.0f)) / 1.7f;
    float longEnd = 350 + random(0, 100); 

    eBackbonePositions = new int[2][2];
    eTopLinePositions = new int[3][2];
    eMiddleLinePositions = new int[3][2];
    eBottomLinePositions = new int[3][2];

    eBackbonePositions[0][0] = 150 + (int)random(0, 50);
    eBackbonePositions[0][1] = (int)baselineY;
    eBackbonePositions[1][0] = eBackbonePositions[0][0];
    eBackbonePositions[1][1] = (int)capHeightY;

   
    eTopLinePositions[0][0] = (int)longEnd;
    eTopLinePositions[0][1] = (int)capHeightY;
    eTopLinePositions[1][0] = (int)longEnd;
    eTopLinePositions[1][1] = (int)(capHeightY + stemWidth / 1.3f);
    eTopLinePositions[2][0] = (int)(eBackbonePositions[0][0] + stemWidth);
    eTopLinePositions[2][1] = (int)(capHeightY + stemWidth);

   
    eMiddleLinePositions[0][0] = (int)(eBackbonePositions[0][0] + stemWidth);
    eMiddleLinePositions[0][1] = (int)middleY;
    eMiddleLinePositions[1][0] = (int)shortEnd;
    eMiddleLinePositions[1][1] = (int)middleY;
    eMiddleLinePositions[2][0] = (int)shortEnd;
    eMiddleLinePositions[2][1] = (int)(middleY + stemWidth / 1.3f);


    eBottomLinePositions[0][0] = (int)(eBackbonePositions[0][0] + stemWidth);
    eBottomLinePositions[0][1] = (int)(baselineY - stemWidth);
    eBottomLinePositions[1][0] = (int)longEnd;
    eBottomLinePositions[1][1] = (int)(baselineY - stemWidth / 1.3f);
    eBottomLinePositions[2][0] = (int)longEnd;
    eBottomLinePositions[2][1] = (int)baselineY;

    
    eMiddleHorizontalEnd = new int[2];
    eMiddleHorizontalEnd[0] = (int)(eBackbonePositions[0][0] + stemWidth);
    eMiddleHorizontalEnd[1] = (int)middleY + (int)stemWidth;
}

void initializeLetterF() {
    float capHeightY = 100;
    float baselineY = 500;
    float canvasSizePart = canvasSize / 10.0f;
    float stemWidth = random(20, 40); 
    float horizontalCenterLineY = 50; 
    float shortEnd = 250 + random(0, 50); 

    float middleY = capHeightY + ((baselineY - capHeightY) * (horizontalCenterLineY / 100.0f)) / 1.7f;
    float longEnd = 350 + random(0, 100); 

    
    eBackbonePositions = new int[2][2];
    eTopLinePositions = new int[3][2];
    eMiddleLinePositions = new int[3][2];

   
    eBackbonePositions[0][0] = 150 + (int)random(0, 50);
    eBackbonePositions[0][1] = (int)baselineY;
    eBackbonePositions[1][0] = eBackbonePositions[0][0];
    eBackbonePositions[1][1] = (int)capHeightY;


    eTopLinePositions[0][0] = (int)longEnd;
    eTopLinePositions[0][1] = (int)capHeightY;
    eTopLinePositions[1][0] = (int)longEnd;
    eTopLinePositions[1][1] = (int)(capHeightY + stemWidth / 1.3f);
    eTopLinePositions[2][0] = (int)(eBackbonePositions[0][0] + stemWidth);
    eTopLinePositions[2][1] = (int)(capHeightY + stemWidth);

   
    eMiddleLinePositions[0][0] = (int)(eBackbonePositions[0][0] + stemWidth);
    eMiddleLinePositions[0][1] = (int)middleY;
    eMiddleLinePositions[1][0] = (int)shortEnd;
    eMiddleLinePositions[1][1] = (int)middleY;
    eMiddleLinePositions[2][0] = (int)shortEnd;
    eMiddleLinePositions[2][1] = (int)(middleY + stemWidth / 1.3f);

    
    eMiddleHorizontalEnd = new int[2];
    eMiddleHorizontalEnd[0] = (int)(eBackbonePositions[0][0] + stemWidth);
    eMiddleHorizontalEnd[1] = (int)middleY + (int)stemWidth;

  
    eBaselineEnd = new int[2];
    eBaselineEnd[0] = eMiddleHorizontalEnd[0];
    eBaselineEnd[1] = (int)baselineY;
}

void initializeLetterJ() {
    float capHeightY = 100;
    float baselineY = 500;
    float canvasSizePart = canvasSize / 10.0f;
    float stemWidth = random(20, 40); 

    
    jTopPoints = new int[2][2];
    jStemEnd = new int[2];
    jCurveControl = new int[2];
    jCurveEnd = new int[2];
    jInnerCurveControl = new int[2];
    jCurveControl2 = new int[2];
    jConnectingPoint = new int[2];
    jInnerCurveControl2 = new int[2];
    point10 = new int[2];
    point11 = new int[2];

   
    jTopPoints[0][0] = (int)(canvasSizePart * 6 - stemWidth + random(-10, 10)); 
    jTopPoints[0][1] = (int)capHeightY;
    
    jTopPoints[1][0] = (int)(canvasSizePart * 6 + random(-10, 10)); 
    jTopPoints[1][1] = (int)capHeightY;
    
    jStemEnd[0] = jTopPoints[1][0]; 
    jStemEnd[1] = 440 + (int)random(-10, 10);
    
    jCurveEnd[0] = jTopPoints[1][0] - (int)stemWidth * 2 + (int)random(-10, 10); 
    jCurveEnd[1] = (int)baselineY;
    
    jCurveControl[0] = jTopPoints[1][0] - (int)stemWidth * 4 + (int)random(-10, 10); 
    jCurveControl[1] = (int)baselineY;
    
    jCurveControl2[0] = jTopPoints[1][0] - (int)stemWidth * 6 + (int)random(-10, 10); 
    jCurveControl2[1] = 450 + (int)random(-10, 10);
    
    jConnectingPoint[0] = jTopPoints[1][0] - (int)stemWidth * 7 + (int)random(-10, 10); 
    jConnectingPoint[1] = 400 + (int)random(-10, 10);
    
    jInnerCurveControl[0] = jConnectingPoint[0] + (int)stemWidth + (int)random(-5, 5); 
    jInnerCurveControl[1] = 400 + (int)random(-5, 5);
    
    jInnerCurveControl2[0] = jInnerCurveControl[0] + (int)stemWidth + (int)random(-5, 5); 
    jInnerCurveControl2[1] = 430 + (int)random(-5, 5);
    
    point10[0] = jInnerCurveControl2[0] + (int)stemWidth * 2 + (int)random(-5, 5); 
    point10[1] = 460 + (int)random(-5, 5);
    
    point11[0] = jTopPoints[1][0] - (int)stemWidth + (int)random(-5, 5); 
    point11[1] = 400 + (int)random(-5, 5);
}

void initializeLetterI() {
    float capHeightY = 100;
    float baselineY = 500;
    float canvasSizePart = canvasSize / 10.0f;
    float stemWidth = 20; 

    iTopPositions = new int[2][2];
    iBottomPositions = new int[2][2];

   
    iTopPositions[0][0] = (int)(canvasSizePart * 5.5);
    iTopPositions[0][1] = (int)capHeightY;
    iTopPositions[1][0] = iTopPositions[0][0] + (int)stemWidth;
    iTopPositions[1][1] = (int)capHeightY;
    
    
    iBottomPositions[0][0] = (int)(canvasSizePart * 5.5);
    iBottomPositions[0][1] = (int)baselineY;
    iBottomPositions[1][0] = iBottomPositions[0][0] + (int)stemWidth;
    iBottomPositions[1][1] = (int)baselineY;
}

void initializeLetterN() {
    float capHeightY = 100;
    float baselineY = 500;
    float stemWidth = random(20, 40);
    float randomDiagonal = random(1.1, 1.5);
    float startX = 150; 
    float endX = 450; 


    nPoints = new int[10][2];

    nPoints[0][0] = (int)startX;
    nPoints[0][1] = (int)baselineY;

    nPoints[1][0] = (int)startX;
    nPoints[1][1] = (int)capHeightY;

    nPoints[2][0] = (int)(startX + stemWidth * randomDiagonal);
    nPoints[2][1] = (int)capHeightY;

    nPoints[3][0] = (int)(endX - stemWidth);
    nPoints[3][1] = (int)(baselineY - stemWidth);

    nPoints[4][0] = nPoints[3][0];
    nPoints[4][1] = (int)capHeightY;

    nPoints[5][0] = nPoints[4][0] + (int)stemWidth;
    nPoints[5][1] = (int)capHeightY;

    nPoints[6][0] = nPoints[5][0];
    nPoints[6][1] = (int)baselineY;

    nPoints[7][0] = (int)(nPoints[6][0] - stemWidth * randomDiagonal);
    nPoints[7][1] = (int)baselineY;

    nPoints[8][0] = (int)(startX + stemWidth);
    nPoints[8][1] = (int)(capHeightY + stemWidth);

    nPoints[9][0] = nPoints[8][0];
    nPoints[9][1] = (int)baselineY;
}

void initializeLetterD() {
    float capHeightY = 100;
    float baselineY = 500;
    float stemWidth = random(20, 60);
    float randomOutterStraight = random(300, 350);
    float randomSecond = random(30, 60);
    float randomThird = random(10, 40);
 
    dOuterPoints = new int[7][2];

    dOuterPoints[0][0] = 200;
    dOuterPoints[0][1] = (int)baselineY;

    dOuterPoints[1][0] = 200;
    dOuterPoints[1][1] = (int)capHeightY;

    dOuterPoints[2][0] = (int)randomOutterStraight;
    dOuterPoints[2][1] = (int)capHeightY;

    dOuterPoints[3][0] = (int)randomOutterStraight+ (int)randomSecond;
    dOuterPoints[3][1] = 200;

    dOuterPoints[4][0] = (int)randomOutterStraight+ (int)randomSecond + (int)randomThird;
    dOuterPoints[4][1] = 300;

    dOuterPoints[5][0] = (int)randomOutterStraight+ (int)randomSecond;
    dOuterPoints[5][1] = 400;

    dOuterPoints[6][0] = (int)randomOutterStraight;
    dOuterPoints[6][1] = (int)baselineY;


    dInnerPoints = new int[7][2];

    dInnerPoints[0][0] = 200 + (int)stemWidth;
    dInnerPoints[0][1] = (int)(baselineY - stemWidth);

    dInnerPoints[1][0] = 200 + (int)stemWidth;
    dInnerPoints[1][1] = (int)(capHeightY + stemWidth);

    dInnerPoints[2][0] = (int)randomOutterStraight - (int)stemWidth;
    dInnerPoints[2][1] = (int)(capHeightY + stemWidth);

    dInnerPoints[3][0] = (int)randomOutterStraight+ (int)randomSecond - (int)stemWidth;
    dInnerPoints[3][1] = 200;

    dInnerPoints[4][0] = (int)randomOutterStraight+ (int)randomSecond + (int)randomThird - (int)stemWidth;
    dInnerPoints[4][1] = 300;

    dInnerPoints[5][0] = (int)randomOutterStraight+ (int)randomSecond - (int)stemWidth;
    dInnerPoints[5][1] = 400;

    dInnerPoints[6][0] = 300;
    dInnerPoints[6][1] = (int)(baselineY - stemWidth);
}

void recordToggle(boolean theFlag) {
  isRecording = theFlag;
}

void drawDashedEdges() {
  pg.strokeWeight(lineWidth);
  pg.noFill();
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
          pg.stroke(gradientColors[colorIndex]);
          pg.line(x1, y1, x2, y2);
        }
        done += step;
      }
      distanceSoFar += segLen;
      prev = curr;
    }
  }
}

void drawEdges() {
  pg.stroke(0, 0, 255);
  pg.strokeWeight(lineWidth);
  pg.noFill();
  for (ArrayList<PVector> edge : edgesWithDeformations) {
    if (edge.size() > 1) {
      pg.beginShape();
      for (PVector p : edge) {
        pg.curveVertex(p.x, p.y);
      }
      pg.endShape();
    }
  }
}
