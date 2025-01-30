import controlP5.*;
import processing.svg.*;
import java.util.Arrays;

PGraphics svg;
boolean isSaving = false; 

ControlP5 cp5;
int cols = 10;
int rows = 10;
float circleScale = 1.5;
float diagonalScale = 1.05;

boolean useCircles = true;
boolean isPaused = false;
float pausedTime = 0;

String currentShape = "CIRCLE";
String currentEffect = "NORMAL";
color backgroundColor = #1F1819;
float effectIntensity = 1.0;

float mouseInfluence = 150;
float mouseRadius = 200;
boolean isExploding = false;
float explosionTime = 0;
float explosionForce = 100;
ArrayList<PVector> originalPositions = new ArrayList<PVector>();
ArrayList<PVector> currentPositions = new ArrayList<PVector>();

int lastCols = 10;
int lastRows = 10;

float explosionSpeed = 1.0;

float maxExplosionRadius;

float explosionX;
float explosionY;

ArrayList<PVector> explosionPoints = new ArrayList<PVector>();
ArrayList<Float> explosionTimes = new ArrayList<Float>();

boolean isRecording = false;

void setup() {
  size(800, 800);
  cp5 = new ControlP5(this);

  int sliderWidth = 150;
  int sliderHeight = 15;
  int buttonWidth = 50;
  int buttonHeight = 15;
  int spacing = 5;
  int startX = 10;
  int startY = 10;
  int currentY = startY;

  cp5.addSlider("cols")
     .setPosition(startX, currentY)
     .setRange(1, 50)
     .setValue(cols)
     .setSize(sliderWidth, sliderHeight);
  currentY += sliderHeight + spacing;

  cp5.addSlider("rows")
     .setPosition(startX, currentY)
     .setRange(1, 50)
     .setValue(rows)
     .setSize(sliderWidth, sliderHeight);
  currentY += sliderHeight + spacing;

  cp5.addSlider("circleScale")
     .setPosition(startX, currentY)
     .setRange(0.3, 2.8)
     .setValue(circleScale)
     .setSize(sliderWidth, sliderHeight);
  currentY += sliderHeight + spacing * 2;

  cp5.addButton("circleButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("CIRCLE");
  currentY += buttonHeight + spacing;
     
  cp5.addButton("squareButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("SQUARE");
  currentY += buttonHeight + spacing;
     
  cp5.addButton("triangleButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("TRIANGLE");
  currentY += buttonHeight + spacing * 2;

  String[] effects = {"NORMAL", "GLOW", "OUTLINE", "PIXELATED", "WAVE", "NEON", "SPIRAL"};
  
  for (int i = 0; i < effects.length; i++) {
    cp5.addButton("effect" + i)
       .setPosition(startX, currentY)
       .setSize(buttonWidth, buttonHeight)
       .setCaptionLabel(effects[i]);
    currentY += buttonHeight + spacing;
  }
  
  currentY += spacing;
     
  cp5.addSlider("effectIntensity")
     .setPosition(startX, currentY)
     .setRange(0, 2)
     .setValue(1)
     .setSize(sliderWidth, sliderHeight)
     .setLabel("Effect Intensity");
  currentY += sliderHeight + spacing;

  cp5.addSlider("mouseInfluence")
     .setPosition(startX, currentY)
     .setRange(0, 300)
     .setValue(mouseInfluence)
     .setSize(sliderWidth, sliderHeight)
     .setLabel("Repel Force");
  currentY += sliderHeight + spacing;
     
  cp5.addSlider("mouseRadius")
     .setPosition(startX, currentY)
     .setRange(50, 400)
     .setValue(mouseRadius)
     .setSize(sliderWidth, sliderHeight)
     .setLabel("Effect Radius");
  currentY += sliderHeight + spacing;

  cp5.addSlider("explosionForce")
     .setPosition(startX, currentY)
     .setRange(0, 20)
     .setValue(100)
     .setSize(sliderWidth, sliderHeight)
     .setLabel("Explosion Force");
  currentY += sliderHeight + spacing;

  cp5.addSlider("explosionSpeed")
     .setPosition(startX, currentY)
     .setRange(0.1, 5)
     .setValue(1.0)
     .setSize(sliderWidth, sliderHeight)
     .setLabel("Explosion Speed");
  currentY += sliderHeight + spacing;

  cp5.addSlider("maxExplosionRadius")
     .setPosition(startX, currentY)
     .setRange(50, width/2)
     .setValue(width * 0.2)
     .setSize(sliderWidth, sliderHeight)
     .setLabel("Explosion Radius");
  currentY += sliderHeight + spacing;

  cp5.addToggle("toggleRecording")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("Record");

  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      float x = i * (width / cols) + (width / cols) / 2;
      float y = j * (height / rows) + (height / rows) / 2;
      originalPositions.add(new PVector(x, y));
      currentPositions.add(new PVector(x, y));
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    isSaving = true;
  }
  if (key == 'r' || key == 'R') {
    toggleRecording(!isRecording);
    cp5.getController("toggleRecording").setValue(isRecording ? 1 : 0);
  }
}

void draw() {
  if (lastCols != cols || lastRows != rows) {
    originalPositions.clear();
    currentPositions.clear();
    
    for (int j = 0; j < rows; j++) {
      for (int i = 0; i < cols; i++) {
        float x = i * (width / cols) + (width / cols) / 2;
        float y = j * (height / rows) + (height / rows) / 2;
        originalPositions.add(new PVector(x, y));
        currentPositions.add(new PVector(x, y));
      }
    }
    
    lastCols = cols;
    lastRows = rows;
    
    isExploding = false;
    explosionTime = 0;
    resetExplosions();
  }

  for (int i = 0; i < currentPositions.size(); i++) {
    PVector original = originalPositions.get(i);
    PVector current = currentPositions.get(i);
    
    for (int e = 0; e < explosionPoints.size(); e++) {
      PVector explosionPoint = explosionPoints.get(e);
      float explosionTime = explosionTimes.get(e);
      
      float timeSinceExplosion = (millis() * 0.001 - explosionTime) * explosionSpeed;
      timeSinceExplosion = min(timeSinceExplosion, 0.5);
      
      float dx = current.x - explosionPoint.x;
      float dy = current.y - explosionPoint.y;
      float dist = sqrt(dx*dx + dy*dy);
      
      if (dist != 0) {
        dx /= dist;
        dy /= dist;
        
        float randomOffset = random(0.8, 1.2);
        current.x += dx * explosionForce * 0.2 * timeSinceExplosion * randomOffset;
        current.y += dy * explosionForce * 0.2 * timeSinceExplosion * randomOffset;
      }
    }
    
    float currentOffset = dist(original.x, original.y, current.x, current.y);
    if (currentOffset > maxExplosionRadius) {
      float scale = maxExplosionRadius / currentOffset;
      current.x = original.x + (current.x - original.x) * scale;
      current.y = original.y + (current.y - original.y) * scale;
    }
  }
  
  background(backgroundColor);
  stroke(10);
  
  if (isSaving) {
    svg = createGraphics(width, height, SVG, "output.svg");
    beginRecord(svg);
  }

  float cellWidth = width / cols;
  float cellHeight = height / rows;
  float thickness = floor(cols * 0.1);

  int apexRow = floor(rows * 0.1);
  int diagonalEnd = floor(rows * 0.35);
  int legsStart = diagonalEnd;
  int legsEnd = floor(rows * 0.85);
  int horizontalRow = floor(rows * 0.55);
  int horizontalHeight = floor(rows * 0.1);
  int centerX = cols / 2;
  int horizontalWidth = floor(cols * 0.57); 

  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      float x = i * cellWidth + cellWidth / 2;
      float y = j * cellHeight + cellHeight / 2;

      if (shouldDrawCircle(i, j, centerX, apexRow, diagonalEnd, legsStart, legsEnd, horizontalRow, horizontalHeight, horizontalWidth, thickness)) {
        drawCircle(x, y, cellWidth, cellHeight, true, true);
      }
    }
  }

  for (int j = 0; j < rows; j++) {
    for (int i = 0; i < cols; i++) {
      float x = i * cellWidth + cellWidth / 2;
      float y = j * cellHeight + cellHeight / 2;

      if (shouldDrawCircle(i, j, centerX, apexRow, diagonalEnd, legsStart, legsEnd, horizontalRow, horizontalHeight, horizontalWidth, thickness)) {
        drawCircle(x, y, cellWidth, cellHeight, false, false);
      }
    }
  }
  
  if (isSaving) {
    endRecord();
    isSaving = false;
  }

  if (isRecording) {
    saveFrame("frames/frame-######.png");
  }

  fill(0);
  textSize(16);
  text("Columns: " + cols, 20, 160);
  text("Rows: " + rows, 20, 180);
  text("Circle Scale: " + nf(circleScale, 1, 2), 20, 200);
}

void drawCircle(float x, float y, float cellWidth, float cellHeight, boolean isRed, boolean isLarger) {
  float time = isPaused ? pausedTime : millis() * 0.001;
  
  int index = (int)(y / (height/rows)) * cols + (int)(x / (width/cols));
  if (index >= 0 && index < currentPositions.size()) {
    PVector pos = currentPositions.get(index);
    x = pos.x;
    y = pos.y;
  }
  
  float dx = x - mouseX;
  float dy = y - mouseY;
  float distToMouse = dist(mouseX, mouseY, x, y);
  
  if (distToMouse < mouseRadius && mouseInfluence > 0) {
    float angle = atan2(dy, dx);
    float strength = map(distToMouse, 0, mouseRadius, mouseInfluence, 0);
    x += cos(angle) * strength * 0.2;
    y += sin(angle) * strength * 0.2;
  }
  
  float scale = circleScale * (1 + 0.1 * sin(time + x * 0.45 + y * 0.11));
  scale *= isLarger ? 1.3 : 1.0;
  float angle = sin(time + x * 0.1 + y * 0.1);

  pushMatrix();
  translate(x, y);
  rotate(angle);

  color[] palette = {
    color(208, 219, 61),
    color(101, 186, 138),
    color(211, 114, 139),
    color(211, 50, 19),
    color(147, 112, 219),
    color(64, 224, 208)
  };

  float size = cellWidth * scale;
  
  switch(currentEffect) {
    case "NORMAL":
      drawNormalEffect(size, palette, time, isLarger);
      break;
    case "GLOW":
      drawGlowEffect(size, palette, time);
      break;
    case "OUTLINE":
      drawOutlineEffect(size, palette, time);
      break;
    case "PIXELATED":
      drawPixelatedEffect(size, palette, time);
      break;
    case "WAVE":
      drawWaveEffect(size, palette, time);
      break;
    case "NEON":
      drawNeonEffect(size, palette, time);
      break;
    case "SPIRAL":
      drawSpiralEffect(size, palette, time);
      break;
  }

  popMatrix();
}

void drawNormalEffect(float size, color[] palette, float time, boolean isLarger) {
  color baseColor = getInterpolatedColor(palette, time);
  if (isLarger) {
    fill(baseColor);
  } else {
    fill(lerpColor(baseColor, color(255), 0.2));
  }
  noStroke();
  drawSelectedShape(size);
}

void drawGlowEffect(float size, color[] palette, float time) {
  color baseColor = getInterpolatedColor(palette, time);
  for (int i = 3; i > 0; i--) {
    float glowSize = size * (1 + i * 0.1 * effectIntensity);
    fill(baseColor, 50 / i);
    noStroke();
    drawSelectedShape(glowSize);
  }
  fill(baseColor);
  drawSelectedShape(size);
}

void drawOutlineEffect(float size, color[] palette, float time) {
  color baseColor = getInterpolatedColor(palette, time);
  noFill();
  stroke(baseColor);
  strokeWeight(2 * effectIntensity);
  drawSelectedShape(size);
  fill(baseColor, 100);
  noStroke();
  drawSelectedShape(size * 0.9);
}

void drawPixelatedEffect(float size, color[] palette, float time) {
  color baseColor = getInterpolatedColor(palette, time);
  float pixelSize = 2 + (effectIntensity * 3);
  noStroke();
  fill(baseColor);
  for (float px = -size/2; px < size/2; px += pixelSize) {
    for (float py = -size/2; py < size/2; py += pixelSize) {
      if (isInShape(px, py, size/2)) {
        rect(px, py, pixelSize, pixelSize);
      }
    }
  }
}

void drawWaveEffect(float size, color[] palette, float time) {
  color baseColor = getInterpolatedColor(palette, time);
  float waveAmp = 10 * effectIntensity;
  float waveFreq = time * 2;
  
  for (int i = 0; i < 10; i++) {
    float offset = map(i, 0, 9, -waveAmp, waveAmp);
    float alpha = map(i, 0, 9, 255, 50);
    
    pushMatrix();
    translate(sin(waveFreq + i * 0.5) * offset, cos(waveFreq + i * 0.5) * offset);
    fill(baseColor, alpha);
    noStroke();
    drawSelectedShape(size * map(i, 0, 9, 1, 0.8));
    popMatrix();
  }
}

void drawNeonEffect(float size, color[] palette, float time) {
  color baseColor = getInterpolatedColor(palette, time);
  
  for (int i = 5; i > 0; i--) {
    float glowSize = size * (1 + i * 0.15 * effectIntensity);
    fill(baseColor, 20);
    noStroke();
    drawSelectedShape(glowSize);
  }
  
  fill(lerpColor(baseColor, color(255), 0.5));
  drawSelectedShape(size * 0.9);
  
  fill(255, 200);
  drawSelectedShape(size * 0.7);
}

void drawSpiralEffect(float size, color[] palette, float time) {
  color baseColor = getInterpolatedColor(palette, time);
  float spiralCount = 8;
  float rotationSpeed = time * 2;
  
  for (int i = 0; i < spiralCount; i++) {
    float angle = (TWO_PI / spiralCount) * i + rotationSpeed;
    float spiralRadius = size * 0.2 * effectIntensity;
    float x = cos(angle) * spiralRadius;
    float y = sin(angle) * spiralRadius;
    
    pushMatrix();
    translate(x, y);
    rotate(angle);
    fill(baseColor, map(i, 0, spiralCount, 255, 100));
    noStroke();
    drawSelectedShape(size * map(i, 0, spiralCount, 1, 0.5));
    popMatrix();
  }
}

void drawBounceEffect(float size, color[] palette, float time) {
  color baseColor = getInterpolatedColor(palette, time);
  float bounce = abs(sin(time * 3)) * effectIntensity * 20;
  
  fill(0, 50);
  ellipse(0, size/2, size - bounce, size/4);
  
  pushMatrix();
  translate(0, -bounce);
  fill(baseColor);
  drawSelectedShape(size);
  fill(255, 100);
  drawSelectedShape(size * 0.7);
  popMatrix();
}

void drawSelectedShape(float size) {
  switch(currentShape) {
    case "CIRCLE":
      ellipse(0, 0, size, size);
      break;
    case "SQUARE":
      rectMode(CENTER);
      rect(0, 0, size, size);
      break;
    case "TRIANGLE":
      float h = size * 0.866;
      triangle(0, -h/2, -size/2, h/2, size/2, h/2);
      break;
  }
}

color getInterpolatedColor(color[] palette, float time) {
  float cycleDuration = 5.0;
  float progress = (time % cycleDuration) / cycleDuration;
  int index1 = (int)(progress * palette.length) % palette.length;
  int index2 = (index1 + 1) % palette.length;
  float blend = (progress * palette.length) % 1.0;
  return lerpColor(palette[index1], palette[index2], blend);
}

boolean isInShape(float px, float py, float radius) {
  switch(currentShape) {
    case "CIRCLE":
      return px*px + py*py < radius*radius;
    case "SQUARE":
      return abs(px) < radius && abs(py) < radius;
    case "TRIANGLE":
      float h = radius * 1.732;
      float y2 = map(abs(px), 0, radius, -h/2, h/2);
      return py > -h/2 && py < y2;
    default:
      return false;
  }
}

boolean shouldDrawCircle(int i, int j, int centerX, int apexRow, int diagonalEnd, int legsStart, int legsEnd, int horizontalRow, int horizontalHeight, int horizontalWidth, float thickness) {
  if (j >= horizontalRow - horizontalHeight / 2 && j <= horizontalRow + horizontalHeight / 2) {
    return (i >= centerX - horizontalWidth / 2 && i <= centerX + horizontalWidth / 2);
  } else if (j >= apexRow && j < diagonalEnd) {
    int offset = floor((j - apexRow) * (cols / 4.0) / (diagonalEnd - apexRow));
    return (i >= centerX - offset - thickness / 2 && i <= centerX - offset + thickness / 2) || 
           (i >= centerX + offset - thickness / 2 && i <= centerX + offset + thickness / 2);
  } else if (j >= legsStart && j <= legsEnd) {
    return (i >= centerX - cols / 4 - thickness / 2 && i <= centerX - cols / 4 + thickness / 2) || 
           (i >= centerX + cols / 4 - thickness / 2 && i <= centerX + cols / 4 + thickness / 2);
  }
  return false;
}

void circleButton() {
  currentShape = "CIRCLE";
}

void squareButton() {
  currentShape = "SQUARE";
}

void triangleButton() {
  currentShape = "TRIANGLE";
}

void effect0() { currentEffect = "NORMAL"; }
void effect1() { currentEffect = "GLOW"; }
void effect2() { currentEffect = "OUTLINE"; }
void effect3() { currentEffect = "PIXELATED"; }
void effect4() { currentEffect = "WAVE"; }
void effect5() { currentEffect = "NEON"; }
void effect6() { currentEffect = "SPIRAL"; }

void mousePressed() {
  if (!cp5.isMouseOver()) {
    explosionPoints.add(new PVector(mouseX, mouseY));
    explosionTimes.add(millis() * 0.001);
  }
}

void resetExplosions() {
  explosionPoints.clear();
  explosionTimes.clear();
}

void toggleRecording(boolean value) {
  isRecording = value;
  if (isRecording) {
    println("Started recording...");
  } else {
    println("Stopped recording.");
  }
}

void exitActual() {
  if (isRecording) {
    println("Stopped recording.");
  }
  exit();
}
