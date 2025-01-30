import controlP5.*;
import processing.svg.*;

ControlP5 cp5;
int columns = 80; 
boolean exportSVG = false; 


class Line {
  float x1, y1, x2, y2;

  Line(float x1, float y1, float x2, float y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }
}

ArrayList<Line> verticalLines = new ArrayList<Line>();
ArrayList<Line> serifsLeft = new ArrayList<Line>();
ArrayList<Line> serifsRight = new ArrayList<Line>();
ArrayList<Line> apexLines = new ArrayList<Line>();
ArrayList<Line> linesToApexLeft = new ArrayList<Line>();
ArrayList<Line> linesToApexRight = new ArrayList<Line>();


float serifHeight;
int serifStart1;
int serifStart2;
float apexHeight;
float longAlines;
float apexMargin;


float lineWidth = 8; 


float waveAmplitude = 20;
float waveFrequency = 0.1; 
int previousColumns = -1;
float previousLineWidth = -1;


String lineStyle = "SOLID";


boolean isRotating = false;
float[] rotationAngles; 
float rotationSpeed = 0.05;
boolean isMultiplying = false;
boolean isNoise = false;
float glitchIntensity = 0;
float noiseScale = 0.003; 
float morphProgress = 0;
int[] multiplyCount;
float[] multiplyAngles; 

float[] rotationSpeeds; 


String colorMode = "WHITE";
color[] palette = {
  #EAE6C7,  
  #D0DB3D,  
  #65BA8A,  
  #D3728B,  
  #D33213   
};
boolean isRainbow = false;
boolean isGradient = false;
color backgroundColor = #1F1819;

float[] initialMultiplyAngles;

boolean isAnimating = true;

void setup() {
  size(600, 600);
  cp5 = new ControlP5(this);

  int sliderWidth = 100;
  int sliderHeight = 10;
  int buttonWidth = 40;
  int buttonHeight = 12;
  int spacing = 4;
  int startX = 10;
  int startY = 10;
  int currentY = startY;

  
  cp5.addSlider("lineWidth")
     .setPosition(startX, currentY)
     .setSize(sliderWidth, sliderHeight)
     .setRange(1, 20)
     .setValue(lineWidth)
     .setCaptionLabel("THICKNESS");
  currentY += sliderHeight + spacing;

  cp5.addSlider("waveAmplitude")
     .setPosition(startX, currentY)
     .setSize(sliderWidth, sliderHeight)
     .setRange(0, 50)
     .setValue(waveAmplitude)
     .setCaptionLabel("WAVE SIZE");
  currentY += sliderHeight + spacing;

  cp5.addSlider("waveFrequency")
     .setPosition(startX, currentY)
     .setSize(sliderWidth, sliderHeight)
     .setRange(0.01, 0.3)
     .setValue(waveFrequency)
     .setCaptionLabel("WAVE SPEED");
  currentY += sliderHeight + spacing * 2;


  cp5.addButton("solidLine")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("SOLID");
  currentY += buttonHeight + spacing;

  cp5.addButton("dashedLine")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("DASH");
  currentY += buttonHeight + spacing;

  cp5.addButton("dottedLine")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("DOT");
  currentY += buttonHeight + spacing;

  currentY += spacing * 2;
  
  cp5.addToggle("isMultiplying")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("MULTIPLY")
     .setValue(false);
  currentY += buttonHeight + spacing;
  
  currentY += spacing * 2;
  
  cp5.addButton("whiteColor")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("WHITE");
  currentY += buttonHeight + spacing;
  
  cp5.addToggle("isRainbow")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("RAINBOW")
     .setValue(false);
  currentY += buttonHeight + spacing;
  
  cp5.addToggle("isGradient")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("GRADIENT")
     .setValue(false);
  
  initializeValues();
}

void draw() {
  if (isAnimating) {
    if (exportSVG) {
      beginRecord(SVG, "output-letters-" + frameCount + ".svg");
    }

    if (!exportSVG) {
      background(backgroundColor);
    } else {
      noStroke();
      fill(255);
      rect(0, 0, width, height);
    }
    
    pushMatrix();
    drawLines(verticalLines, color(255));
    drawLines(serifsLeft, color(255, 0, 0));
    drawLines(serifsRight, color(255, 0, 0));
    drawLines(apexLines, color(0, 255, 0));
    drawLines(linesToApexLeft, color(255, 0, 0));
    drawLines(linesToApexRight, color(255, 0, 0));
    popMatrix();

    if (exportSVG) {
      endRecord();
      exportSVG = false;
      println("SVG zapisany jako jednolite białe tło!");
    }
  }
}

void initializeValues() {
  verticalLines.clear();
  serifsLeft.clear();
  serifsRight.clear();
  apexLines.clear();
  linesToApexLeft.clear();
  linesToApexRight.clear();

  float spacing = width / (float) columns;
  
  for (int i = 0; i < columns; i++) {
    float x = i * spacing + spacing / 2;
    verticalLines.add(new Line(x, 0, x, height));
  }

  serifStart1 = (int) (columns * 0.15); 
  serifStart2 = columns - serifStart1 - (int) (columns * 0.1); 

  serifHeight = random(10, 20); 
  apexHeight = random(15, 30); 
  longAlines = random(20, 50); 
  apexMargin = random(-10, 20); 


  generateSerifs(serifStart1, serifsLeft);
  mirrorSerifs(serifsLeft, serifsRight);

  
  generateLinesToApexLeft();
  mirrorLinesToApex(linesToApexLeft, linesToApexRight);

 
  addHorizontalLine();


  rotationAngles = new float[columns * 4];
  

  for (int i = 0; i < rotationAngles.length; i++) {
    rotationAngles[i] = random(TWO_PI);
  }

 
  multiplyCount = new int[columns * 4];
  multiplyAngles = new float[columns * 4 * 10]; 
  initialMultiplyAngles = new float[columns * 4 * 10]; 
  

  for (int i = 0; i < multiplyCount.length; i++) {
    multiplyCount[i] = int(random(3, 7)); 
    for (int j = 0; j < 10; j++) {
      multiplyAngles[i * 10 + j] = map(j, 0, 9, -PI/6, PI/6); 
      initialMultiplyAngles[i * 10 + j] = random(-PI/8, PI/8); 
    }
  }


  rotationSpeeds = new float[columns * 4];
  for (int i = 0; i < rotationSpeeds.length; i++) {
    rotationSpeeds[i] = random(0.01, 0.03); 
  }
}

void addHorizontalLine() {
  float yStart = height * 0.6; 
  int startColumn = columns / 3; 
  int endColumn = 2 * columns / 3; 
  
  for (int i = startColumn; i <= endColumn; i++) {
    float x = (i * width / (float) columns) + (width / (float) columns) / 2; 
    apexLines.add(new Line(x, yStart, x, yStart + random(15, 25))); 
  }
}

void drawLines(ArrayList<Line> lines, color col) {
  noFill();
  
  boolean isBackground = (lines == verticalLines);
  int lineIndex = 0;
  
  for (Line l : lines) {
    if (isBackground) {
      stroke(40);
      strokeWeight(lineWidth);
      line(l.x1, l.y1, l.x2, l.y2);
    } else {
      float x1 = l.x1;
      float y1 = l.y1;
      float x2 = l.x2;
      float y2 = l.y2;
      
      float waveOffsetStart = waveAmplitude * sin(x1 * waveFrequency + frameCount * 0.05);
      float waveOffsetEnd = waveAmplitude * sin(x2 * waveFrequency + frameCount * 0.05);
      
      color currentColor;
      if (isRainbow) {
        float hue = (frameCount * 0.5 + lineIndex * 5) % 255;
        colorMode(HSB, 255);
        currentColor = palette[int(map(hue, 0, 255, 0, palette.length))];
        colorMode(RGB);
      } else if (isGradient) {
        float progress = map(lineIndex, 0, lines.size(), 0, palette.length - 1);
        int index1 = floor(progress);
        int index2 = min(index1 + 1, palette.length - 1);
        float lerpAmt = progress - index1;
        currentColor = lerpColor(palette[index1], palette[index2], lerpAmt);
      } else {
        currentColor = palette[0];
      }
      
      if (isMultiplying) {
        int copies = multiplyCount[lineIndex];
        
        for (int i = 0; i < copies; i++) {
          pushMatrix();
          translate((x1 + x2) / 2, (y1 + y2) / 2);
          
          float angle = multiplyAngles[lineIndex * 10 + i];
          float initialAngle = initialMultiplyAngles[lineIndex * 10 + i];
          
          float timeRotation = frameCount * 0.001;
          rotate(angle + initialAngle + timeRotation);
          
          translate(-(x1 + x2) / 2, -(y1 + y2) / 2);
          
          stroke(currentColor, 150);
          drawLineWithStyle(x1, y1 + waveOffsetStart, x2, y2 + waveOffsetEnd, lineStyle);
          
          popMatrix();
        }
      } else {
        stroke(currentColor);
        drawLineWithStyle(x1, y1 + waveOffsetStart, x2, y2 + waveOffsetEnd, lineStyle);
      }
      
      lineIndex++;
    }
  }
}


void drawDashedLine(float x1, float y1, float x2, float y2) {
  float dashLength = lineWidth * 3;
  float gapLength = lineWidth * 2;
  float dx = x2 - x1;
  float dy = y2 - y1;
  float distance = sqrt(dx*dx + dy*dy);
  float unitX = dx / distance;
  float unitY = dy / distance;
  
  strokeWeight(lineWidth);
  float currentX = x1;
  float currentY = y1;
  boolean drawing = true;
  
  while (distance > 0) {
    float stepLength = drawing ? dashLength : gapLength;
    stepLength = min(stepLength, distance);
    
    if (drawing) {
      line(currentX, currentY, 
           currentX + unitX * stepLength, 
           currentY + unitY * stepLength);
    }
    
    currentX += unitX * stepLength;
    currentY += unitY * stepLength;
    distance -= stepLength;
    drawing = !drawing;
  }
}


void drawDottedLine(float x1, float y1, float x2, float y2) {
  float dotSpacing = lineWidth * 2;
  float dx = x2 - x1;
  float dy = y2 - y1;
  float distance = sqrt(dx*dx + dy*dy);
  float unitX = dx / distance;
  float unitY = dy / distance;
  
  strokeWeight(lineWidth);
  float currentX = x1;
  float currentY = y1;
  
  while (distance > 0) {
    point(currentX, currentY);
    currentX += unitX * dotSpacing;
    currentY += unitY * dotSpacing;
    distance -= dotSpacing;
  }
}


void drawLineWithStyle(float x1, float y1, float x2, float y2, String style) {
  switch(style) {
    case "SOLID":
      strokeWeight(lineWidth);
      line(x1, y1, x2, y2);
      break;
    case "DASHED":
      drawDashedLine(x1, y1, x2, y2);
      break;
    case "DOTTED":
      drawDottedLine(x1, y1, x2, y2);
      break;
  }
}

void keyPressed() {
  if (key == ' ') {
    exportSVG = true;
  }
  if (key == 'r' || key == 'R') {
    resetEffects();
  }
  if (key == 's' || key == 'S') {
    isAnimating = !isAnimating; 
  }
}

void generateSerifs(int startColumn, ArrayList<Line> serifsList) {
  int serifColumns = (int) (columns * 0.1); 
  float spacing = width / (float) columns;
  float y1 = height * 0.9;
  float y2 = y1 - serifHeight;

  for (int i = 0; i < serifColumns; i++) {
    int currentColumn = startColumn + i;
    if (currentColumn >= columns) break;

    float x = currentColumn * spacing + spacing / 2;
    serifsList.add(new Line(x, y1, x, y2));
  }
}

void mirrorSerifs(ArrayList<Line> serifsLeft, ArrayList<Line> serifsRight) {
  for (Line l : serifsLeft) {
    float mirroredX = width - l.x1;
    serifsRight.add(new Line(mirroredX, l.y1, mirroredX, l.y2));
  }
}

void generateLinesToApexLeft() {
  int serifColumns = (int) (columns * 0.1); 
  int apexColumn = columns / 2; 
  float spacing = width / (float) columns;
  float yApex = height * 0.1 + apexMargin; 
  float y1 = height * 0.9 - serifHeight;
  float previousLineHeightLeft = y1 - longAlines; 


  for (int i = serifStart1 + serifColumns / 2; i <= apexColumn; i++) {
    if (i > serifStart1 + serifColumns / 2 && i < serifStart1 + serifColumns) {
      float x = i * spacing + spacing / 2;
      float y2 = max(previousLineHeightLeft, yApex); 
      y2 = max(y2, yApex); 
      y1 = min(y1, height * 0.9);
      linesToApexLeft.add(new Line(x, y1, x, y2));
      previousLineHeightLeft = y2;
    }
    if (i >= serifStart1 + serifColumns) {
      float storedPreviousLine = previousLineHeightLeft + random(50, 80); 
      float randomLine = random(10, 30); 
      float x = i * spacing + spacing / 2;
      float y2 = max(previousLineHeightLeft - randomLine, yApex + random(10, 20)); 
      y2 = max(y2, yApex);
      storedPreviousLine = min(storedPreviousLine, height * 0.9);
      linesToApexLeft.add(new Line(x, storedPreviousLine, x, y2));
      previousLineHeightLeft = y2;
    }
  }
}

void mirrorLinesToApex(ArrayList<Line> linesToApexLeft, ArrayList<Line> linesToApexRight) {
  for (Line l : linesToApexLeft) {
    float mirroredX = width - l.x1;
    linesToApexRight.add(new Line(mirroredX, l.y1, mirroredX, l.y2));
  }
}


void solidLine() {
  lineStyle = "SOLID";
}

void dashedLine() {
  lineStyle = "DASHED";
}

void dottedLine() {
  lineStyle = "DOTTED";
}


void resetEffects() {
  isMultiplying = false;
  
  cp5.getController("isMultiplying").setValue(0);
  
  initializeValues();
}


void whiteColor() {
  colorMode = "WHITE";
  isRainbow = false;
  isGradient = false;
  cp5.getController("isRainbow").setValue(0);
  cp5.getController("isGradient").setValue(0);
}