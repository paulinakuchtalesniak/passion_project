import controlP5.*;
import processing.svg.*;
import java.util.Arrays;

PGraphics svg;
boolean isSaving = false; 

ControlP5 cp5;
int cols = 30;
int rows = 30;
float circleScale = 1.5;
float diagonalScale = 1.05;

boolean useCircles = true;
boolean isPaused = false;
float pausedTime = 0;
float lastTime = 0;

String currentShape = "CIRCLE";
String currentLetter = "A";
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

  int sliderWidth = 100;
  int sliderHeight = 10;
  int buttonWidth = 40;
  int buttonHeight = 12;
  int spacing = 4;
  int startX = 10;
  int startY = 10;
  int currentY = startY;

  cp5.addSlider("cols")
     .setPosition(startX, currentY)
     .setRange(15, 60)
     .setValue(cols)
     .setSize(sliderWidth, sliderHeight)
     .setCaptionLabel("");
  currentY += sliderHeight + spacing;

  cp5.addSlider("rows")
     .setPosition(startX, currentY)
     .setRange(15, 60)
     .setValue(rows)
     .setSize(sliderWidth, sliderHeight)
     .setCaptionLabel("");
  currentY += sliderHeight + spacing;

  cp5.addSlider("circleScale")
     .setPosition(startX, currentY)
     .setRange(0.3, 2.8)
     .setValue(circleScale)
     .setSize(sliderWidth, sliderHeight)
     .setCaptionLabel("");
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
  currentY += buttonHeight + spacing;

  cp5.addButton("iButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("I");
  currentY += buttonHeight + spacing * 2;

  cp5.addButton("dButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("D");
  currentY += buttonHeight + spacing;

  cp5.addButton("nButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("N");
  currentY += buttonHeight + spacing;

  cp5.addButton("eButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("E");
  currentY += buttonHeight + spacing;

  cp5.addButton("vButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("V");
  currentY += buttonHeight + spacing;

  cp5.addButton("fButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("F");
  currentY += buttonHeight + spacing;

  cp5.addButton("jButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("J");
  currentY += buttonHeight + spacing;

  cp5.addButton("pButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("P");
  currentY += buttonHeight + spacing;

  cp5.addButton("uButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("U");
  currentY += buttonHeight + spacing;

  cp5.addButton("lButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("L");
  currentY += buttonHeight + spacing;

  cp5.addButton("kButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("K");
  currentY += buttonHeight + spacing;

  cp5.addButton("rButton")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("R");
  currentY += buttonHeight + spacing;

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
     .setCaptionLabel("");
  currentY += sliderHeight + spacing;

  cp5.addSlider("mouseInfluence")
     .setPosition(startX, currentY)
     .setRange(0, 300)
     .setValue(mouseInfluence)
     .setSize(sliderWidth, sliderHeight)
     .setCaptionLabel("");
  currentY += sliderHeight + spacing;
     
  cp5.addSlider("mouseRadius")
     .setPosition(startX, currentY)
     .setRange(50, 400)
     .setValue(mouseRadius)
     .setSize(sliderWidth, sliderHeight)
     .setCaptionLabel("");
  currentY += sliderHeight + spacing;

  cp5.addSlider("explosionForce")
     .setPosition(startX, currentY)
     .setRange(0, 20)
     .setValue(100)
     .setSize(sliderWidth, sliderHeight)
     .setCaptionLabel("");
  currentY += sliderHeight + spacing;

  cp5.addSlider("explosionSpeed")
     .setPosition(startX, currentY)
     .setRange(0.1, 5)
     .setValue(1.0)
     .setSize(sliderWidth, sliderHeight)
     .setCaptionLabel("");
  currentY += sliderHeight + spacing;

  cp5.addSlider("maxExplosionRadius")
     .setPosition(startX, currentY)
     .setRange(50, width/2)
     .setValue(width * 0.2)
     .setSize(sliderWidth, sliderHeight)
     .setCaptionLabel("");
  currentY += sliderHeight + spacing;

  cp5.addToggle("toggleRecording")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("REC");
  currentY += buttonHeight + spacing;

  cp5.addToggle("isPaused")
     .setPosition(startX, currentY)
     .setSize(buttonWidth, buttonHeight)
     .setCaptionLabel("PAUSE")
     .setValue(false);

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
    currentLetter = "R";
    currentShape = null;
  }
  if (key == 'a' || key == 'A') {
    currentLetter = "A";
    currentShape = null;
  }
  if (key == 'i' || key == 'I') {
    currentLetter = "I";
    currentShape = null;
  }
  if (key == 'd' || key == 'D') {
    currentLetter = "D";
    currentShape = null;
  }
  if (key == 'n' || key == 'N') {
    currentLetter = "N";
    currentShape = null;
  }
  if (key == 'e' || key == 'E') {
    currentLetter = "E";
    currentShape = null;
  }
  if (key == 'v' || key == 'V') {
    currentLetter = "V";
    currentShape = null;
  }
  if (key == 'f' || key == 'F') {
    currentLetter = "F";
    currentShape = null;
  }
  if (key == 'j' || key == 'J') {
    currentLetter = "J";
    currentShape = null;
  }
  if (key == 'p' || key == 'P') {
    currentLetter = "P";
    currentShape = null;
  }
  if (key == 'u' || key == 'U') {
    currentLetter = "U";
    currentShape = null;
  }
  if (key == 'l' || key == 'L') {
    currentLetter = "L";
    currentShape = null;
  }
  if (key == 'k' || key == 'K') {
    currentLetter = "K";
    currentShape = null;
  }
}

void draw() {
  float time;
  if (isPaused) {
    time = pausedTime;
  } else {
    time = millis() * 0.001;
    pausedTime = time;  
  }

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
      
      float timeSinceExplosion = (time - explosionTime) * explosionSpeed;
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
  if (currentShape != null) {
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
  } else if (currentLetter != null) {
    ellipse(0, 0, size, size);
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
  if (currentShape != null) {
    switch(currentShape) {
      case "CIRCLE":
        return px*px + py*py < radius*radius;
      case "SQUARE":
        return abs(px) < radius && abs(py) < radius;
      case "TRIANGLE":
        float h = radius * 1.732;
        float y2 = map(abs(px), 0, radius, -h/2, h/2);
        return py > -h/2 && py < y2;
    }
  } else if (currentLetter != null) {
    return px*px + py*py < radius*radius;
  }
  return false;
}

boolean shouldDrawCircle(int i, int j, int centerX, int apexRow, int diagonalEnd, int legsStart, int legsEnd, int horizontalRow, int horizontalHeight, int horizontalWidth, float thickness) {
  if (currentLetter != null) {
    if (currentLetter.equals("I")) {
      // vertical bar
      int verticalBarWidth = floor(thickness); 
      
      //  horizontal bars
      int topBottomBarWidth = floor(cols * 0.3); 
      int topBottomBarHeight = floor(rows * 0.08);  
      
      int startY = floor(rows * 0.1);
      int endY = floor(rows * 0.9);
      
      // drawing of vertical bar
      if (i >= centerX - verticalBarWidth/2 && i <= centerX + verticalBarWidth/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      // drawing of top and bottom bars 
      if (j >= startY && j <= startY + topBottomBarHeight &&
          i >= centerX - topBottomBarWidth/2 && i <= centerX + topBottomBarWidth/2) {
        return true;
      }
      if (j >= endY - topBottomBarHeight && j <= endY &&
          i >= centerX - topBottomBarWidth/2 && i <= centerX + topBottomBarWidth/2) {
        return true;
      }
      
      return false;
    }
    
    if (currentLetter.equals("A")) {
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
    }
    
    if (currentLetter.equals("D")) {
      // dimensions
      int verticalBarWidth = floor(thickness);
      int startY = floor(rows * 0.1);  
      int endY = floor(rows * 0.9);    
      int curveWidth = floor(cols * 0.37); 
      
      //  vertical stem 
      if (i >= centerX - cols/4 - verticalBarWidth/2 && 
          i <= centerX - cols/4 + verticalBarWidth/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      // right side 
      if (j >= startY && j <= endY) {
        float verticalProgress = map(j, startY, endY, -PI/2, PI/2);  
        float curveX = centerX - cols/2.5 + curveWidth;  
        float expectedX = centerX - cols/4 + cos(verticalProgress) * curveWidth;  
        
        //  horizontal connections at top and bottom
        if ((j <= startY + thickness || j >= endY - thickness) && 
            i >= centerX - cols/4 && i <= expectedX) {
          return true;
        }
        
        //  curved part
        if (i >= expectedX - thickness/2 && 
            i <= expectedX + thickness/2) {
          return true;
        }
      }
      
      return false;
    }
    
    if (currentLetter.equals("N")) {
      int verticalBarWidth = floor(thickness);
      int startY = floor(rows * 0.1);  
      int endY = floor(rows * 0.9);    
      
      // left vertical bar
      if (i >= centerX - cols/4 - verticalBarWidth/2 && 
          i <= centerX - cols/4 + verticalBarWidth/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      // right vertical bar
      if (i >= centerX + cols/4 - verticalBarWidth/2 && 
          i <= centerX + cols/4 + verticalBarWidth/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      // diagonal line
      float progress = map(j, startY, endY, 0, 1);
      float diagonalX = map(progress, 0, 1, 
                           centerX - cols/4,  
                           centerX + cols/4); 
      
      if (i >= diagonalX - thickness/2 && 
          i <= diagonalX + thickness/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      return false;
    }
    
    if (currentLetter.equals("E")) {
      int verticalBarWidth = floor(thickness);
      int middleBarWidth = floor(cols * 0.3);     
      int topBottomBarWidth = floor(cols * 0.35);  
      int horizontalBarHeight = floor(rows * 0.08);
      int startY = floor(rows * 0.1);
      int endY = floor(rows * 0.9);
      
      // vertical bar
      if (i >= centerX - cols/4 - verticalBarWidth/2 && 
          i <= centerX - cols/4 + verticalBarWidth/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      // upper horizontal bar
      if (j >= startY && j <= startY + horizontalBarHeight &&
          i >= centerX - cols/4 && i <= centerX - cols/4 + topBottomBarWidth) {
        return true;
      }
      
      // middle horizontal bar
      float middleY = startY + (endY - startY) / 2;
      if (j >= middleY - horizontalBarHeight/2 && j <= middleY + horizontalBarHeight/2 &&
          i >= centerX - cols/4 && i <= centerX - cols/4 + middleBarWidth) {
        return true;
      }
      
      // lower horizontal bar
      if (j >= endY - horizontalBarHeight && j <= endY &&
          i >= centerX - cols/4 && i <= centerX - cols/4 + topBottomBarWidth) {
        return true;
      }
      
      return false;
    }
    
    if (currentLetter.equals("V")) {
      int verticalBarWidth = floor(thickness);
      int startY = floor(rows * 0.1);  
      int endY = floor(rows * 0.9);    
      
      float progress = map(j, startY, endY, 0, 1);
      int maxOffset = floor(cols * 0.25); 
      float offset = (1 - progress) * maxOffset;  
      
      // left diagonal
      if (i >= centerX - offset - thickness/2 && 
          i <= centerX - offset + thickness/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      // right diagonal
      if (i >= centerX + offset - thickness/2 && 
          i <= centerX + offset + thickness/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      return false;
    }
    
    if (currentLetter.equals("F")) {
      int verticalBarWidth = floor(thickness);
      int middleBarWidth = floor(cols * 0.3);     
      int topBarWidth = floor(cols * 0.35);     
      int horizontalBarHeight = floor(rows * 0.08);
      int startY = floor(rows * 0.1);
      int endY = floor(rows * 0.9);
      
      // vertical bar
      if (i >= centerX - cols/4 - verticalBarWidth/2 && 
          i <= centerX - cols/4 + verticalBarWidth/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      // upper horizontal bar
      if (j >= startY && j <= startY + horizontalBarHeight &&
          i >= centerX - cols/4 && i <= centerX - cols/4 + topBarWidth) {
        return true;
      }
      
      // middle horizontal bar
      float middleY = startY + (endY - startY) / 2;
      if (j >= middleY - horizontalBarHeight/2 && j <= middleY + horizontalBarHeight/2 &&
          i >= centerX - cols/4 && i <= centerX - cols/4 + middleBarWidth) {
        return true;
      }
      
      return false;
    }
    
    if (currentLetter.equals("J")) {
      int verticalBarWidth = floor(thickness);
      int startY = floor(rows * 0.1);    
      float stemEndY = rows * 0.7;   
      float endY = floor(rows * 0.88);   
      
      // upper horizontal bar
      int topBarWidth = floor(cols * 0.40);
      int horizontalBarHeight = floor(rows * 0.08);
      if (j >= startY && j <= startY + horizontalBarHeight &&
          i >= centerX - topBarWidth/2 && i <= centerX + topBarWidth/2) {
        return true;
      }
      
      // vertical stem
      if (j >= startY && j <= stemEndY &&
          i >= centerX + cols/6 - verticalBarWidth/2 && 
          i <= centerX + cols/6 + verticalBarWidth/2) {
        return true;
      }
      
      // first diagonal line
      float stemX = centerX + cols/6;
      float diagonalEndX = stemX - cols * 0.1;
      if (j >= stemEndY && j <= endY) {
        float progress = map(j, stemEndY, endY, 0, 1);
        float diagonalX = lerp(stemX, diagonalEndX, progress);
        if (i >= diagonalX - thickness/2 && i <= diagonalX + thickness/2) {
          return true;
        }
      }
      
      // horizontal bottom line
      float horizontalStartX = diagonalEndX;
      float horizontalEndX = horizontalStartX - cols * 0.15;
      if (j >= endY - thickness/2 && j <= endY + thickness/2 &&
          i >= horizontalEndX && i <= horizontalStartX) {
        return true;
      }
      
      // second diagonal line
      float upEndX = horizontalEndX - cols * 0.1;
      float upEndY = rows * 0.7;  
      if (j >= upEndY && j <= endY) {
        float progress = map(j, endY, upEndY, 0, 1);
        float upX = lerp(horizontalEndX, upEndX, progress);
        if (i >= upX - thickness/2 && i <= upX + thickness/2) {
          return true;
        }
      }
      
      return false;
    }
    
    if (currentLetter.equals("P")) {
      int verticalBarWidth = floor(thickness);
      int startY = floor(rows * 0.1);    
      int endY = floor(rows * 0.9);     
      int curveWidth = floor(cols * 0.35);  
      float bowlStartY = startY; 
      float bowlEndY = startY + (endY - startY) * 0.65; 
      
      // vertical stem
      float stemX = centerX - cols/4;
      if (i >= stemX - verticalBarWidth/2 && 
          i <= stemX + verticalBarWidth/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      // upper curved part
      if (j >= bowlStartY && j <= bowlEndY) {
        float verticalProgress = map(j, bowlStartY, bowlEndY, -PI/2, PI/2);
        float expectedX = stemX + cos(verticalProgress) * curveWidth;
        
     
        if ((j <= bowlStartY + thickness || j >= bowlEndY - thickness) && 
            i >= stemX && i <= expectedX) {
          return true;
        }
        
        // curved part
        if (i >= expectedX - thickness/1.8 && 
            i <= expectedX + thickness/1.8) {
          return true;
        }
      }
      
      return false;
    }
    
    if (currentLetter.equals("U")) {
      int verticalBarWidth = floor(thickness);
      int startY = floor(rows * 0.1);    
      float stemEndY = rows * 0.7;      
      float endY = floor(rows * 0.87);   
      int curveWidth = floor(cols * 0.40);  
      
      // left
      if (i >= centerX - curveWidth/2 - verticalBarWidth/2 && 
          i <= centerX - curveWidth/2 + verticalBarWidth/2 &&
          j >= startY && j <= stemEndY) {
        return true;
      }
      
      // right
      if (i >= centerX + curveWidth/2 - verticalBarWidth/2 && 
          i <= centerX + curveWidth/2 + verticalBarWidth/2 &&
          j >= startY && j <= stemEndY) {
        return true;
      }
      
      // diagonal lines
      if (j >= stemEndY && j <= endY) {
        // left diagonal line
        float leftProgress = map(j, stemEndY, endY, 0, 1);
        float leftX = lerp(centerX - curveWidth/2, centerX, leftProgress);
        if (i >= leftX - thickness/2 && i <= leftX + thickness/2) {
          return true;
        }
        
        // right diagonal line
        float rightProgress = map(j, stemEndY, endY, 0, 1);
        float rightX = lerp(centerX + curveWidth/2, centerX, rightProgress);
        if (i >= rightX - thickness/2 && i <= rightX + thickness/2) {
          return true;
        }
      }
      
      return false;
    }
    
    if (currentLetter.equals("L")) {
      int verticalBarWidth = floor(thickness);
      int startY = floor(rows * 0.1);    
      int endY = floor(rows * 0.9);      
      int horizontalBarWidth = floor(cols * 0.35);  
      int horizontalBarHeight = floor(rows * 0.08);  
      
      // vertical bar
      if (i >= centerX - cols/4 - verticalBarWidth/2 && 
          i <= centerX - cols/4 + verticalBarWidth/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      // horizontal bar
      if (j >= endY - horizontalBarHeight && j <= endY &&
          i >= centerX - cols/4 && i <= centerX - cols/4 + horizontalBarWidth) {
        return true;
      }
      
      return false;
    }
    
    if (currentLetter.equals("K")) {
      int verticalBarWidth = floor(thickness);
      int startY = floor(rows * 0.1);  
      int endY = floor(rows * 0.9);      
      float middleY = (startY + endY) / 2;  
      int armWidth = floor(cols * 0.35);  
      
      // vertical bar
      float stemX = centerX - cols/4;
      if (i >= stemX - verticalBarWidth/2 && 
          i <= stemX + verticalBarWidth/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      // upper diagonal line
      if (j >= startY && j <= middleY) {
        float progress = map(j, middleY, startY, 0, 1);
        float armX = lerp(stemX, stemX + armWidth, progress);
        if (i >= armX - thickness/2 && i <= armX + thickness/2) {
          return true;
        }
      }
      
      // bottom diagonal line
      if (j >= middleY && j <= endY) {
        float progress = map(j, middleY, endY, 0, 1);
        float armX = lerp(stemX, stemX + armWidth, progress);
        if (i >= armX - thickness/2 && i <= armX + thickness/2) {
          return true;
        }
      }
      
      return false;
    }
    
    if (currentLetter.equals("R")) {
      int verticalBarWidth = floor(thickness);
      int startY = floor(rows * 0.1);  
      int endY = floor(rows * 0.9);      
      int curveWidth = floor(cols * 0.35);  
      float bowlStartY = startY;  
      float bowlEndY = startY + (endY - startY) * 0.55; 
      
      // vertical bar
      float stemX = centerX - cols/4;
      if (i >= stemX - verticalBarWidth/2 && 
          i <= stemX + verticalBarWidth/2 &&
          j >= startY && j <= endY) {
        return true;
      }
      
      // curved upper 
      if (j >= bowlStartY && j <= bowlEndY) {
        float verticalProgress = map(j, bowlStartY, bowlEndY, -PI/2, PI/2);
        float expectedX = stemX + cos(verticalProgress) * curveWidth;
        
        // horizontal connections
        if ((j <= bowlStartY + thickness || j >= bowlEndY - thickness) && 
            i >= stemX && i <= expectedX) {
          return true;
        }
        
        //  curved part
        if (i >= expectedX - thickness/1.8 && 
            i <= expectedX + thickness/1.8) {
          return true;
        }
      }
      
      // bottom diagonal
      float legStartY = bowlEndY - (endY - startY) * 0.1;  
      if (j >= legStartY && j <= endY) {
        float progress = map(j, legStartY, endY, 0, 1);
        float startX = stemX + cos(PI/2) * curveWidth * 0.9; 
        float diagonalX = lerp(startX, stemX + curveWidth * 1.2, progress);
        if (i >= diagonalX - thickness/1.7 && i <= diagonalX + thickness/1.7) {
          return true;
        }
      }
      
      return false;
    }
  }
  
  return false;
}

void circleButton() {
  currentShape = "CIRCLE";
  currentLetter = null;
}

void squareButton() {
  currentShape = "SQUARE";
  currentLetter = null;
}

void triangleButton() {
  currentShape = "TRIANGLE";
  currentLetter = null;
}

void iButton() {
  currentLetter = "I";
  currentShape = null;
}

void dButton() {
  currentLetter = "D";
  currentShape = null;
}

void nButton() {
  currentLetter = "N";
  currentShape = null;
}

void eButton() {
  currentLetter = "E";
  currentShape = null;
}

void vButton() {
  currentLetter = "V";
  currentShape = null;
}

void fButton() {
  currentLetter = "F";
  currentShape = null;
}

void jButton() {
  currentLetter = "J";
  currentShape = null;
}

void pButton() {
  currentLetter = "P";
  currentShape = null;
}

void uButton() {
  currentLetter = "U";
  currentShape = null;
}

void lButton() {
  currentLetter = "L";
  currentShape = null;
}

void kButton() {
  currentLetter = "K";
  currentShape = null;
}

void rButton() {
  currentLetter = "R";
  currentShape = null;
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

void togglePause() {
  isPaused = !isPaused;
  if (isPaused) {
    pausedTime = millis() * 0.001;  
  }
}
