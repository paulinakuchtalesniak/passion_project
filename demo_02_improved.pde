import processing.svg.*;
import geomerative.*;
import controlP5.*;

ControlP5 cp5;
int canvasSize = 800;
float distortionRange = 10;
float segments = 1;
boolean isExportingSVG = false; 
boolean distortionChanged = false;
boolean segmentsChanged = false;


int circleRadius = 10;
int selectedCircle = -1; 

//general variables
float noiseFactor = 0.1;
int stemWidth = int(random(20, 100)); 
int horizontalCenterLineY;
float canvasSizePart = canvasSize/12;
int buttonX = 20; 
int buttonY = 20; 
int buttonWidth = 100; 
int buttonHeight = 40;

float distortionFactor = 0; 
float[][] finalOffsets; 

int strokeR = 211;
int strokeG = 114;
int strokeB = 139;
int baselineY = 700;
int capHeightY = 100;
Letter currentLetterObject;
String currentLetter = "A";

boolean useSineDistortion = false;
float time = 0; 
float animationSpeed = 0; 

// Variables for letter A
int apexNumber;
int letterHeight;
int[][] apexPositions;
int[][][] letterSideDistance;
int[][] horizontalLinePos;
int[][] innerTriangle;
int[][] circlePositions;
RShape shape;
RPath triangle;
RPolygon originalPolygon;
int deltaApexHeight = 0;
int deltaHorizontalLine = 0;
int deltaTriangle1 = 0; 
int deltaTriangle2 = 0;
int deltaTopTriangle = 0;


//letter B variables
int[] verticalLineB;
float controlX1, controlY1, controlX2, controlY2; 
float controlX3, controlY3, controlX4, controlY4; 
float innerControlX1, innerControlX2, innerControlX3, innerControlX4;
float innerEndX, innerEndX2;
float innerVerticalLineUpper; 
float innerVerticalLineLower; 
float innerVerticalLineOffset;
float stemBottomX, stemBottomY;
float stemTopX, stemTopY;
float upperBowlControl1X, upperBowlControl1Y;
float upperBowlControl2X, upperBowlControl2Y;
float lowerBowlControl1X, lowerBowlControl1Y;
float lowerBowlControl2X, lowerBowlControl2Y;
float middleX, middleY;
float innerUpperControl1X, innerUpperControl1Y;
float innerUpperControl2X, innerUpperControl2Y;
float innerLowerControl1X, innerLowerControl1Y;
float innerLowerControl2X, innerLowerControl2Y;
float innerEndPointX, innerEndPointY; 
float innerEndPointX1, innerEndPointY1; 
float innerStartX1, innerStartY1;
float innerStartX, innerStartY;
RShape bShape; 
RPolygon bPolygon; 



//letter C variables
float mainPointC;
float mainPointCY;
float outterBigCurveX, outterBigCurveY;
float outterBigCurveX2, outterBigCurveY2;
float innerBigCurve;
float streightLineX, streightLineY;
float innerSmallCurveXDown, innerSmallCurveYDown, innerSmallCurveX2Down, innerSmallCurveY2Down;
float lowerCurveControl1X, lowerCurveControl1Y;
float lowerCurveControl2X, lowerCurveControl2Y;
float upperCurveControl1X, upperCurveControl1Y;
float upperCurveControl2X, upperCurveControl2Y;
float innerBigCurveX1, innerBigCurveY1;
float innerBigCurveX2, innerBigCurveY2;
float arcToLineRatio;
float curveHeightFactor;

float smallOutterCurveX, smallOutterCurveY;
float smallOutterCurveX2, smallOutterCurveY2;
float smallOutterCurveXend, smallOutterCurveYend;
float endInneerBigCurveX, endInneerBigCurveY;
float innerSmallCurveX1Top, innerSmallCurveY1Top;
float innerSmallCurveX2Top, innerSmallCurveY2Top;
float innerSmallCurveXEnd, innerSmallCurveYEnd;
float upperStraightLineX, upperStraightLineY;

//letter D variables
float dVerticalStem =200;
float dVerticalStemXTop, dVerticalStemYTop; 
float dVerticalStemXBottom, dVerticalStemYBottom; 
float dBowlControlX1, dBowlControlY1; 
float dBowlControlX2, dBowlControlY2; 
float dInnerControlX1, dInnerControlY1;
float dInnerControlX2, dInnerControlY2; 
float dInnerOffset;
float randomDheight;
float outterCurveEndX, outterCurveEndY;
float innerCurveStartX, innerCurveStartY;
float innerCurveEndX, innerCurveEndY;


//letter E variables
float eTopLineEndX, eTopVerticalEndX, eTopReturnX;
float eMiddleStartX, eMiddleLineX, eMiddleVerticalX, eMiddleReturnX;
float eBottomStartX, eBottomEndX, eBottomVerticalEndX;
float eTopVerticalEndY, eTopReturnY;
float eMiddleStartY, eMiddleLineY, eMiddleVerticalY, eMiddleReturnY;
float eBottomStartY, eBottomEndY;


float eBackboneX, eBackboneY, eBackboneX2, eBackboneY2;
float shortEnd = canvasSizePart* random(5.5, 7.5);  

//letter F variables
float fBackboneX,fBackboneY,fBackboneX2, fBackboneY2, fTopLineEndX, fTopVerticalEndX, fTopReturnX;
float fMiddleStartX, fMiddleLineX, fMiddleVerticalX, fMiddleReturnX, fTopLineEndY;
float fTopVerticalEndY, fTopReturnY, fMiddleStartY, fMiddleLineY;
float fMiddleVerticalY, fMiddleReturnY, fBottomVerticalX, fBottomVerticalY;

//letter V variables
float[][] vApexPositions; 
float[][][] vSideDistance;  
float[] vApexControlPoint;  
float[] vApexTopControl; 

// letter J variables
float[][] jTopPoints;        
float[] jStemEnd;          
float[] jCurveControl;    
float[] jCurveEnd;         
float[] jInnerCurveControl; 
float[] jCurveControl1;      
float[] jCurveControl2;      
float[] jInnerCurveControl2; 
float jInnerCurveOffsetX = 50;  
float jInnerCurveOffsetY = -70; 
float[] jConnectingPoint;   
float jConnectingOffsetX = 50; 
float jConnectingOffsetY = -20; 

//letter I variables
int[][] iTopPositions;   
int[][] iBottomPositions;
float iTopPositionsX, iTopPositionsY, iTopPositionsX1, iTopPositionsY1;
float iBottomPositionsX, iBottomPositionsY, iBottomPositionsX1, iBottomPositionsY1;

//letter N variables
float nPoint1[] = new float[2];
float nPoint2[] = new float[2];
float nPoint3[] = new float[2];
float nPoint4[] = new float[2];
float nPoint5[] = new float[2];
float nPoint6[] = new float[2];
float nPoint7[] = new float[2];
float nPoint8[] = new float[2];
float nPoint9[] = new float[2];
float nPoint10[] = new float[2];

//letter update functions
HashMap<String, LetterUpdateFunction> updateFunctions;
HashMap<String, Runnable> drawFunctions;

interface LetterUpdateFunction {
    void update(int circleIndex, int x, int y);
}

class LetterPoint {
    float x, y;
    String name;
    
    LetterPoint(float x, float y, String name) {
        this.x = x;
        this.y = y;
        this.name = name;
    }
}


class Letter {
    ArrayList<LetterPoint> points;
    HashMap<String, Integer> pointIndex;
    
    Letter() {
        points = new ArrayList<LetterPoint>();
        pointIndex = new HashMap<String, Integer>();
    }
    
    void addPoint(float x, float y, String name) {
        pointIndex.put(name, points.size());
        points.add(new LetterPoint(x, y, name));
    }
    
    LetterPoint getPoint(String name) {
        Integer index = pointIndex.get(name);
        return (index != null) ? points.get(index) : null;
    }
    
    int[][] generateCirclePositions() {
        int[][] positions = new int[points.size()][2];
        for (int i = 0; i < points.size(); i++) {
            positions[i][0] = int(points.get(i).x);
            positions[i][1] = int(points.get(i).y);
        }
        return positions;
    }

    void updatePoint(int index, float x, float y) {
    if (index >= 0 && index < points.size()) {
        LetterPoint lp = points.get(index);
        lp.x = x;
        lp.y = y;
    }
}
}


Letter letterA;
Letter letterB;
Letter letterC;
Letter letterD; 
Letter letterE;
Letter letterJ;
Letter letterF;
Letter letterV;
Letter letterI;
Letter letterN;


void setup() {
  size(800, 800);
  smooth();

  cp5 = new ControlP5(this);
  cp5.addSlider("distortionRange")
     .setPosition(20, 20)
     .setRange(1, 50) 
     .setValue(2)
     .onChange((event) -> {
       distortionRange = event.getController().getValue();
       distortionChanged = true;
     });

  cp5.addSlider("segments")
     .setPosition(20, 50)
     .setRange(1, 20) 
     .setValue(1)
     .onChange((event) -> {
       segments = event.getController().getValue();
       segmentsChanged = true;
     });

  cp5.addButton("TransformLetter")
     .setPosition(20, 80)
     .setSize(120, 40)
     .setCaptionLabel("Save Svg")
     .onClick((event) -> startTransformation());

  cp5.addButton("ResetElement")
     .setPosition(20, 140)
     .setSize(120, 40)
     .setCaptionLabel("Reset")
     .onClick((event) -> resetElement());

     cp5.addToggle("toggleDistortionType")
       .setPosition(20, 760)
       .setSize(50, 25)
       .setCaptionLabel("Sine/Noise")
       .setValue(false)
       .onChange((event) -> {
           useSineDistortion = event.getController().getValue() == 1.0;
           distortionChanged = true;
       });

         cp5.addSlider("stemWidth")
       .setPosition(20, 200) 
       .setRange(10, 110)
       .setValue(stemWidth) 
       .onChange((event) -> {
           stemWidth = (int) event.getController().getValue();
           println("Updated stemWidth: " + stemWidth); 

        
           switch (currentLetter) {
               case "A":
                   initializeLetterA();
                   break;
               case "B":
                   initializeLetterB();
                   break;
               case "C":
                   initializeLetterC();
                   break;
               case "D":
                   initializeLetterD();
                   break;
               case "E":
                   initializeLetterE();
                   break;
               case "F":
                   initializeLetterF();
                   break;
               case "J":
                   initializeLetterJ();
                   break;
               case "I":
                   initializeLetterI();
                   break;
               case "N":
                   initializeLetterN();
                   break;
               case "V":
                   initializeLetterV();
                   break;
            
           }

           if (drawFunctions.containsKey(currentLetter)) {
               drawFunctions.get(currentLetter).run();
           }
       });

        cp5.addSlider("noiseFactor")
       .setPosition(20, 230)
       .setRange(0.05, 0.4)
       .setValue(noiseFactor)
       .onChange((event) -> {
           noiseFactor = event.getController().getValue();
           distortionChanged = true; 
       });

  RG.init(this);

  currentLetter = "A";  
  if (currentLetter.equals("A")) {
          initializeLetterA();
      circlePositions = letterA.generateCirclePositions();
        drawAShape();
 
  }
  

  updateFunctions = new HashMap<String, LetterUpdateFunction>();
  updateFunctions.put("A", (i, x, y) -> updateLetterAPoints(i, x, y));
  updateFunctions.put("B", (i, x, y) -> updateLetterBPoints(i, x, y));
  updateFunctions.put("C", (i, x, y) -> updateLetterCPoints(i, x, y));
  updateFunctions.put("D", (i, x, y) -> updateLetterDPoints(i, x, y));
  updateFunctions.put("E", (i, x, y) -> updateLetterEPoints(i, x, y));
  updateFunctions.put("F", (i, x, y) -> updateLetterFPoints(i, x, y));
  updateFunctions.put("V", (i, x, y) -> updateLetterVPoints(i, x, y));
  updateFunctions.put("J", (i, x, y) -> updateLetterJPoints(i, x, y));
  updateFunctions.put("I", (i, x, y) -> updateLetterIPoints(i, x, y));
  updateFunctions.put("N", (i, x, y) -> updateLetterNPoints(i, x, y));

  drawFunctions = new HashMap<String, Runnable>();
  drawFunctions.put("A", () -> drawAShape());
  drawFunctions.put("B", () -> drawBShape());
  drawFunctions.put("C", () -> drawCShape());
  drawFunctions.put("D", () -> drawDShape());
  drawFunctions.put("E", () -> drawEShape());
  drawFunctions.put("F", () -> drawFShape());
  drawFunctions.put("V", () -> drawVShape());
  drawFunctions.put("J", () -> drawJShape());
  drawFunctions.put("I", () -> drawIShape());
  drawFunctions.put("N", () -> drawNShape());

  finalOffsets = null; 
  background(30, 24, 25);
  shape = new RShape();

}


void draw() {
background(30, 24, 25);

if (distortionChanged || segmentsChanged) {
        RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
        RCommand.setSegmentLength(segments);

        if (distortionChanged) {
            RPolygon polygon = copyPolygon(originalPolygon);
            polygonizeAndDistort(polygon);
        }
        distortionChanged = false;
        segmentsChanged = false;
    }

     if (drawFunctions.containsKey(currentLetter)) {
    drawFunctions.get(currentLetter).run();
  }
    drawTypographicZones();

   drawVerticalLinesAndProportion();
   

}

void drawVerticalLinesAndProportion() {
    float startX = 0;
    float endX = 0;
    String proportion = "";

    switch (currentLetter) {
        case "A":
            startX = canvasSizePart * 3;
            endX = canvasSizePart * 9;
            proportion = "Proportion: 6";
            break;
        case "B":
            startX = canvasSizePart * 3.5;
            endX = canvasSizePart * 8.5;
            proportion = "Proportion: 5";
            break;
        case "C":
            startX = canvasSizePart * 3.25;
            endX = canvasSizePart * 8.75;
            proportion = "Proportion: 5 1/2";
            break;
        case "D":
            startX = canvasSizePart * 3.25;
            endX = canvasSizePart * 8.75;
            proportion = "Proportion: 5 1/2";
            break;
        case "E":
            startX = canvasSizePart * 3.5;
            endX = canvasSizePart * 8.5;
            proportion = "Proportion: 5";
            break;
        case "F":
            startX = canvasSizePart * 3.75;
            endX = canvasSizePart * 8.25;
            proportion = "Proportion: 4 1/2";
            break;
        case "N":
            startX = canvasSizePart * 3.25;
            endX = canvasSizePart * 8.75;
            proportion = "Proportion: 5 1/4";
            break;
        case "J":
            startX = canvasSizePart * 3.75;
            endX = canvasSizePart * 8.25;
            proportion = "Proportion: 4 1/2";
            break;
        case "I":
            startX = canvasSizePart * 5.5;
            endX = canvasSizePart * 5.5 + stemWidth;
            proportion = "Proportion: 1";
            break;
        case "V":
            startX = canvasSizePart * 3.25;
            endX = canvasSizePart * 8.75 + stemWidth;
            proportion = "Proportion: 5 1/2";
            break;
    }


    stroke(255, 255, 255, 128); 
    strokeWeight(0.5);
    line(startX, 0, startX, height);
    line(endX, 0, endX, height);
    fill(255);
    textSize(16);
    text(proportion, width / 2 - textWidth(proportion) / 2, 20);
}




void drawAShape() {
  shape = new RShape();

  // outer shape
  shape.addMoveTo(horizontalLinePos[0][0], horizontalLinePos[0][1]);
  shape.addLineTo(horizontalLinePos[1][0], horizontalLinePos[1][1]);
  shape.addLineTo(letterSideDistance[0][1][0], letterSideDistance[0][1][1]);
  shape.addLineTo(letterSideDistance[0][0][0], letterSideDistance[0][0][1]);
  // Apex
  shape.addLineTo(apexPositions[0][0], apexPositions[0][1]);
  if (apexNumber == 2) {
    shape.addLineTo(apexPositions[1][0], apexPositions[1][1]);
  }
  shape.addLineTo(letterSideDistance[1][0][0], letterSideDistance[1][0][1]);
  shape.addLineTo(letterSideDistance[1][1][0], letterSideDistance[1][1][1]);
  shape.addLineTo(horizontalLinePos[0][0], horizontalLinePos[0][1]);

  // inner triangle
  shape.addMoveTo(innerTriangle[0][0], innerTriangle[0][1]);
  shape.addLineTo(innerTriangle[1][0], innerTriangle[1][1]);
  shape.addLineTo(innerTriangle[2][0], innerTriangle[2][1]);
  shape.addLineTo(innerTriangle[0][0], innerTriangle[0][1]);

drawDistortedShape(shape);
}

void drawBShape() {
    RShape bShape = new RShape();

    //outer shape
    bShape.addMoveTo(stemBottomX, stemBottomY);
    bShape.addLineTo(stemTopX, stemTopY);

    bShape.addBezierTo(upperBowlControl1X, upperBowlControl1Y, upperBowlControl2X, upperBowlControl2Y, middleX, middleY);
    bShape.addBezierTo(lowerBowlControl1X, lowerBowlControl1Y, lowerBowlControl2X, lowerBowlControl2Y, stemBottomX, stemBottomY);

    // Inner shape
    bShape.addMoveTo(innerStartX1, innerStartY1);
    bShape.addBezierTo(innerUpperControl1X, innerUpperControl1Y, innerUpperControl2X, innerUpperControl2Y, innerEndPointX1,  innerEndPointY1);
    bShape.addLineTo(innerStartX1, innerStartY1);

    bShape.addMoveTo(innerStartX, innerStartY);
    bShape.addBezierTo(innerLowerControl1X, innerLowerControl1Y, innerLowerControl2X, innerLowerControl2Y, innerEndPointX, innerEndPointY);
    bShape.addLineTo(innerStartX, innerStartY);

  drawDistortedShape(bShape);
}


void drawCShape() {
    RShape cShape = new RShape();


    //outer curve
    cShape.addMoveTo(mainPointC, mainPointCY - 10);
    cShape.addBezierTo(
    outterBigCurveX, outterBigCurveY,
       outterBigCurveX2, outterBigCurveY2,
        mainPointC, baselineY + 10
    );

    // lower outer curve
    cShape.addBezierTo(
        smallOutterCurveX, smallOutterCurveY,
        smallOutterCurveX2, smallOutterCurveY2,
        smallOutterCurveXend, smallOutterCurveYend
    );

    // straight line to inner curve small curve
    cShape.addLineTo(streightLineX, streightLineY);

    // inner small down curve
    cShape.addBezierTo(
        innerSmallCurveXDown, innerSmallCurveYDown,
        innerSmallCurveX2Down, innerSmallCurveY2Down,
        innerSmallCurveX2Down, baselineY - stemWidth
    );

    // inner curve
    cShape.addBezierTo(
        innerBigCurveX1, innerBigCurveY1,
        innerBigCurveX2, innerBigCurveY2,
        endInneerBigCurveX, endInneerBigCurveY
    );


       // inner small upper curve
    cShape.addBezierTo(
        innerSmallCurveX1Top, innerSmallCurveY1Top,
        innerSmallCurveX2Top, innerSmallCurveY2Top,
        innerSmallCurveXEnd, innerSmallCurveYEnd
    );

    cShape.addLineTo(upperStraightLineX, upperStraightLineY);

    // end of shape
    cShape.addBezierTo(
        canvasSizePart *8.75, capHeightY + 60,
        canvasSizePart *7, capHeightY - 10,
        mainPointC, capHeightY -10
    );

  drawDistortedShape(cShape);
}


void drawDShape() {
    RShape dShape = new RShape();

    // vertical stem
    dShape.addMoveTo(dVerticalStemXBottom, dVerticalStemYBottom);
    dShape.addLineTo(dVerticalStemXTop, dVerticalStemYTop);

    // Outer bowl
    dShape.addBezierTo(
        dBowlControlX1, dBowlControlY1,       
        dBowlControlX2,  dBowlControlY2,  
        outterCurveEndX, outterCurveEndY    
    );

    dShape.addLineTo(dVerticalStemXTop, dVerticalStemYBottom);

    // Inner counter
    dShape.addMoveTo(innerCurveStartX, innerCurveStartY);
    dShape.addBezierTo(
        dInnerControlX1, dInnerControlY1,  
        dInnerControlX2, dInnerControlY2,  
       innerCurveEndX, innerCurveEndY   
    );
    dShape.addLineTo(innerCurveStartX, innerCurveStartY);

  drawDistortedShape(dShape);
}



void drawEShape() {
    RShape eShape = new RShape();
    
    eShape.addMoveTo(eBackboneX, eBackboneY);
    eShape.addLineTo(eBackboneX2, eBackboneY2);
    eShape.addLineTo(eTopLineEndX, capHeightY);
    eShape.addLineTo(eTopVerticalEndX, eTopVerticalEndY);
    eShape.addLineTo(eTopReturnX, eTopReturnY);

    //middle
    eShape.addLineTo(eMiddleStartX, eMiddleStartY);
    eShape.addLineTo(eMiddleLineX, eMiddleLineY);
    eShape.addLineTo(eMiddleVerticalX, eMiddleVerticalY);
    eShape.addLineTo(eMiddleReturnX, eMiddleReturnY);
    
    //bottom
    eShape.addLineTo(eBottomStartX, eBottomStartY);
    eShape.addLineTo(eBottomEndX, eBottomEndY);
    eShape.addLineTo(eBottomVerticalEndX, baselineY);
    eShape.addLineTo(eBackboneX, baselineY); 
    
   drawDistortedShape(eShape);
}

void drawFShape() {
    RShape fShape = new RShape();
    
    fShape.addMoveTo(fBackboneX, fBackboneY);
    fShape.addLineTo(fBackboneX2, fBackboneY2);

    fShape.addLineTo(fTopLineEndX, fTopLineEndY);
    fShape.addLineTo(fTopVerticalEndX, fTopVerticalEndY);
    fShape.addLineTo(fTopReturnX, fTopReturnY);
    fShape.addLineTo(fMiddleStartX, fMiddleStartY);
    fShape.addLineTo(fMiddleLineX, fMiddleLineY);
    fShape.addLineTo(fMiddleVerticalX, fMiddleVerticalY);
    fShape.addLineTo(fMiddleReturnX, fMiddleReturnY);

    fShape.addLineTo(fBottomVerticalX, fBottomVerticalY); 
    fShape.addLineTo(fBackboneX, baselineY); 
    

   drawDistortedShape(fShape);
}

void drawIShape() {
    RShape iShape = new RShape();
    
    iShape.addMoveTo(iTopPositionsX, iTopPositionsY);
    iShape.addLineTo(iTopPositionsX1, iTopPositionsY1);
    iShape.addLineTo(iBottomPositionsX1, iBottomPositionsY1);
    iShape.addLineTo(iBottomPositionsX, iBottomPositionsY1);
    iShape.addLineTo(iTopPositionsX, iTopPositionsY);
    
    drawDistortedShape(iShape);
}

void drawJShape() {
    RShape jShape = new RShape();
    
    jShape.addMoveTo(jTopPoints[0][0], jTopPoints[0][1]);
    jShape.addLineTo(jTopPoints[1][0], jTopPoints[1][1]);
    jShape.addLineTo(jStemEnd[0], jStemEnd[1]);
    jShape.addBezierTo(jCurveControl[0], jCurveControl[1],
                       jCurveControl2[0], jCurveControl2[1],
                       jCurveEnd[0], jCurveEnd[1]);
    jShape.addLineTo(jConnectingPoint[0], jConnectingPoint[1]);
    jShape.addBezierTo(jInnerCurveControl[0], jInnerCurveControl[1],
                       jInnerCurveControl2[0], jInnerCurveControl2[1],
                       jTopPoints[0][0], jTopPoints[0][1]);
    
    drawDistortedShape(jShape);
}

void drawNShape() {
    RShape nShape = new RShape();
    
    nShape.addMoveTo(nPoint1[0], nPoint1[1]);
    nShape.addLineTo(nPoint2[0], nPoint2[1]);
    nShape.addLineTo(nPoint3[0], nPoint3[1]);
    nShape.addLineTo(nPoint4[0], nPoint4[1]);
    nShape.addLineTo(nPoint5[0], nPoint5[1]);
    nShape.addLineTo(nPoint6[0], nPoint6[1]);
    nShape.addLineTo(nPoint7[0], nPoint7[1]);
    nShape.addLineTo(nPoint8[0], nPoint8[1]);
    nShape.addLineTo(nPoint9[0], nPoint9[1]);
    nShape.addLineTo(nPoint10[0], nPoint10[1]);
    nShape.addLineTo(nPoint1[0], nPoint1[1]); 
    
   drawDistortedShape(nShape);
}

void drawVShape() {
    RShape vShape = new RShape();
    
    vShape.addMoveTo(vSideDistance[0][0][0], vSideDistance[0][0][1]);
    vShape.addLineTo(vSideDistance[0][1][0], vSideDistance[0][1][1]);
    vShape.addLineTo(vApexTopControl[0], vApexTopControl[1]);
    vShape.addLineTo(vSideDistance[1][1][0], vSideDistance[1][1][1]);
    vShape.addLineTo(vSideDistance[1][0][0], vSideDistance[1][0][1]);
    
    if (apexNumber == 1) {
        vShape.addLineTo(vApexPositions[0][0], vApexPositions[0][1]);
    } else {
        vShape.addLineTo(vApexPositions[1][0], vApexPositions[1][1]);
        vShape.addLineTo(vApexPositions[0][0], vApexPositions[0][1]);
    }

    vShape.addLineTo(vSideDistance[0][0][0], vSideDistance[0][0][1]);
    
    drawDistortedShape(vShape);
}


//letters initialization

void initializeLetterA() {
    letterA = new Letter();
    apexNumber = generateRandomBetweenOneAndTwo();
    letterHeight = generateHeight();
    apexPositions = generateApexPositions(apexNumber);
    letterSideDistance = generateLegs(baselineY);
    horizontalLinePos = generateHorizontalLinePos();
    innerTriangle = generateInnerTriangle(apexNumber);
    
   
    letterA.addPoint(letterSideDistance[0][0][0], letterSideDistance[0][0][1], "leftLegStart");
    letterA.addPoint(letterSideDistance[1][0][0], letterSideDistance[1][0][1], "rightLegStart");
    letterA.addPoint(apexPositions[0][0], apexPositions[0][1], "firstApex");
    
    if (apexNumber > 1) {
        letterA.addPoint(apexPositions[1][0], apexPositions[1][1], "secondApex");
    }
    
    letterA.addPoint(horizontalLinePos[0][0], horizontalLinePos[0][1], "horizontalLeft");
    letterA.addPoint(horizontalLinePos[1][0], horizontalLinePos[1][1], "horizontalRight");
    letterA.addPoint(letterSideDistance[0][1][0], letterSideDistance[0][1][1], "leftLegEnd");
    letterA.addPoint(letterSideDistance[1][1][0], letterSideDistance[1][1][1], "rightLegEnd");
    letterA.addPoint(innerTriangle[0][0], innerTriangle[0][1], "innerTriangleLeft");
    letterA.addPoint(innerTriangle[1][0], innerTriangle[1][1], "innerTriangleRight");
    letterA.addPoint(innerTriangle[2][0], innerTriangle[2][1], "innerTriangleTop");
    circlePositions = letterA.generateCirclePositions();
}



void initializeLetterB() {
    stemBottomX = canvasSizePart * 3.5;
    stemBottomY = baselineY;
    stemTopX = canvasSizePart * 3.5;
    stemTopY = capHeightY;

    middleY = baselineY + (capHeightY - baselineY) * random(0.45, 0.75);
    middleX = canvasSizePart * 3.5 + random(canvasSizePart * 1.5, canvasSizePart * 3.5);

    upperBowlControl1X = canvasSizePart * 8.5;
    upperBowlControl1Y = capHeightY - random(60, 90);
    upperBowlControl2X = canvasSizePart * 9.5;
    upperBowlControl2Y = middleY - random(40, 80);

    lowerBowlControl1X = canvasSizePart * 9.5;
    lowerBowlControl1Y = middleY + random(10, 80);
    lowerBowlControl2X = canvasSizePart * 10.5;
    lowerBowlControl2Y = baselineY + random(60, 90);

    innerUpperControl1X = upperBowlControl1X - random(20, 60);
    innerUpperControl1Y = upperBowlControl1Y + 10;
    innerUpperControl2X = upperBowlControl2X - random(20, 60);
    innerUpperControl2Y = upperBowlControl2Y + 80;

    innerLowerControl1X = lowerBowlControl1X - random(40, 70);
    innerLowerControl1Y = lowerBowlControl1Y - 80;
    innerLowerControl2X = lowerBowlControl2X - random(40, 70);
    innerLowerControl2Y = lowerBowlControl2Y - 10;

    innerEndPointX1 = stemBottomX + stemWidth;
    innerEndPointY1 = middleY - stemWidth / 2;

    innerEndPointX = stemBottomX + stemWidth;
    innerEndPointY = baselineY - stemWidth / 2;

    innerStartX = stemBottomX + stemWidth;
    innerStartY = middleY + stemWidth / 2;

    innerStartX1 = stemBottomX + stemWidth;
    innerStartY1 = capHeightY + stemWidth / 2;

    letterB = new Letter();
    letterB.addPoint(stemBottomX, stemBottomY, "stemBottom");
    letterB.addPoint(stemTopX, stemTopY, "stemTop");
    letterB.addPoint(upperBowlControl1X, upperBowlControl1Y, "upperBowlControl1");
    letterB.addPoint(upperBowlControl2X, upperBowlControl2Y, "upperBowlControl2");
    letterB.addPoint(lowerBowlControl1X, lowerBowlControl1Y, "lowerBowlControl1");
    letterB.addPoint(lowerBowlControl2X, lowerBowlControl2Y, "lowerBowlControl2");
    letterB.addPoint(innerUpperControl1X, innerUpperControl1Y, "innerUpperControl1");
    letterB.addPoint(innerUpperControl2X, innerUpperControl2Y, "innerUpperControl2");
    letterB.addPoint(innerLowerControl1X, innerLowerControl1Y, "innerLowerControl1");
    letterB.addPoint(innerLowerControl2X, innerLowerControl2Y, "innerLowerControl2");
    letterB.addPoint(middleX, middleY, "middlePoint");
    letterB.addPoint(innerEndPointX, innerEndPointY, "innerEndPoint");
    letterB.addPoint(innerEndPointX1, innerEndPointY1, "innerEndPoint1");
    letterB.addPoint(innerStartX, innerStartY, "innerStart");
    letterB.addPoint(innerStartX1, innerStartY1, "innerStart1");
}

void initializeLetterC() {
letterC = new Letter();

mainPointC = canvasSizePart *6;
mainPointCY = capHeightY;
outterBigCurveX = canvasSizePart *2.5;
outterBigCurveY = capHeightY -20;
outterBigCurveX2 = canvasSizePart *2.5;
outterBigCurveY2 = baselineY +20;

smallOutterCurveX = canvasSizePart *7;
smallOutterCurveY = baselineY +10;
smallOutterCurveX2 = canvasSizePart *8.75;
smallOutterCurveY2 = baselineY -60;
smallOutterCurveXend = canvasSizePart *8.75;
smallOutterCurveYend = baselineY -140;
streightLineX  =  canvasSizePart *8.75 - stemWidth;
streightLineY = baselineY -130;

innerSmallCurveXDown = canvasSizePart *7.5;
innerSmallCurveYDown = baselineY -stemWidth;
innerSmallCurveX2Down = mainPointC;
innerSmallCurveY2Down = baselineY -stemWidth;


innerBigCurveX1 = canvasSizePart *2.5 + stemWidth;
innerBigCurveY1 = baselineY -70;
innerBigCurveX2 = canvasSizePart *2.5 + stemWidth;
innerBigCurveY2 = capHeightY +70;
endInneerBigCurveX = mainPointC;
endInneerBigCurveY = capHeightY + stemWidth;

innerSmallCurveX1Top = mainPointC;
innerSmallCurveY1Top = capHeightY +stemWidth;
innerSmallCurveX2Top = canvasSizePart *7.5;
innerSmallCurveY2Top = capHeightY+ stemWidth;

innerSmallCurveXEnd = streightLineX;
innerSmallCurveYEnd = capHeightY +140;

upperStraightLineX = innerSmallCurveXEnd + stemWidth;
upperStraightLineY = capHeightY +130;


letterC.addPoint(mainPointC, mainPointCY, "mainPoint");
letterC.addPoint(outterBigCurveX, outterBigCurveY, "outterCurve");
letterC.addPoint(outterBigCurveX2, outterBigCurveY2, "outterCurve2");
letterC.addPoint(smallOutterCurveX, smallOutterCurveY, "smallOutterCurve");
letterC.addPoint(smallOutterCurveX2, smallOutterCurveY2, "smallOutterCurve2");
letterC.addPoint(smallOutterCurveXend, smallOutterCurveYend, "smallOutterCurveEnd");
letterC.addPoint(streightLineX, streightLineY, "straightLine");
letterC.addPoint(innerBigCurveX1, innerBigCurveY1, "innerCurve1");
letterC.addPoint(innerBigCurveX2, innerBigCurveY2, "innerCurve2");
letterC.addPoint(innerSmallCurveXDown, innerSmallCurveYDown, "innerSmallCurveDown");
letterC.addPoint(innerSmallCurveX2Down, innerSmallCurveY2Down, "innerSmallCurve2Down");
letterC.addPoint(innerSmallCurveX1Top, innerSmallCurveY1Top, "innerSmallCurve1Top");
letterC.addPoint(innerSmallCurveX2Top, innerSmallCurveY2Top, "innerSmallCurve2Top");
letterC.addPoint(innerSmallCurveXEnd, innerSmallCurveYEnd, "innerSmallCurveEnd");
letterC.addPoint(upperStraightLineX, upperStraightLineY, "upperStraightLine");
circlePositions = letterC.generateCirclePositions();

}

void initializeLetterD() {
    letterD = new Letter();

    dVerticalStemXBottom = canvasSizePart * 3.25;
    dVerticalStemYBottom = baselineY;
    dVerticalStemXTop = canvasSizePart * 3.25;
    dVerticalStemYTop = capHeightY;
    dBowlControlX1 = canvasSizePart * 10.75;
    dBowlControlY1 = capHeightY;
    dBowlControlX2 = canvasSizePart * 10.75;
    dBowlControlY2 = baselineY;

    outterCurveEndX = dVerticalStemXBottom;
    outterCurveEndY = baselineY;

    innerCurveStartX = dVerticalStemXBottom + stemWidth;
    innerCurveStartY = capHeightY + stemWidth;

    dInnerOffset = random(20, 70);

    dInnerControlX1 = canvasSizePart * 10.75 - stemWidth;
    dInnerControlY1 = capHeightY + stemWidth;
    dInnerControlX2 = canvasSizePart * 10.75 - stemWidth;
    dInnerControlY2 = baselineY - stemWidth;
    randomDheight = random(20, 50);

    innerCurveEndX = dVerticalStemXBottom + stemWidth;
    innerCurveEndY = baselineY - stemWidth;

    letterD.addPoint(dVerticalStemXBottom, dVerticalStemYBottom, "stemBottom");
    letterD.addPoint(dVerticalStemXTop, dVerticalStemYTop, "stemTop");
    letterD.addPoint(dBowlControlX1, dBowlControlY1, "bowlControlTop1");
    letterD.addPoint(dBowlControlX2, dBowlControlY2, "bowlControlTop2");
    letterD.addPoint(outterCurveEndX, outterCurveEndY, "outterCurveEnd");
    letterD.addPoint(innerCurveStartX, innerCurveStartY, "innerCurveStart");
    letterD.addPoint(dInnerControlX1, dInnerControlY1, "innerControlTop1");
    letterD.addPoint(dInnerControlX2, dInnerControlY2, "innerControlTop2");
    letterD.addPoint(innerCurveEndX, innerCurveEndY, "innerCurveEnd");
    

    circlePositions = letterD.generateCirclePositions();
}

void initializeLetterE() {
    letterE = new Letter();
    float middleY = capHeightY + int((baselineY - capHeightY) * (horizontalCenterLineY / 100.0))/1.7;

    float longEnd = canvasSizePart* 8.5;
    

    eBackboneX = canvasSizePart* 3.5;
    eBackboneY = baselineY;
    eBackboneX2 = canvasSizePart* 3.5;
    eBackboneY2 = capHeightY;

    eTopLineEndX =  longEnd;
    eTopVerticalEndX =  longEnd;
    eTopVerticalEndY = capHeightY +stemWidth/1.3;
    eTopReturnX = eBackboneX +stemWidth;
    eTopReturnY = capHeightY +stemWidth;

    eMiddleStartX = eBackboneX + stemWidth;
    eMiddleStartY = middleY;

    eMiddleLineX =   shortEnd;
    eMiddleLineY = middleY;

    eMiddleVerticalX = shortEnd;
    eMiddleVerticalY = middleY + stemWidth/1.3;;

    eMiddleReturnX = eBackboneX + stemWidth;
    eMiddleReturnY = middleY + stemWidth;


    eBottomStartX = eBackboneX + stemWidth;
    eBottomStartY = baselineY - stemWidth;

    eBottomEndX =  longEnd;
    eBottomEndY = baselineY - stemWidth/1.3;
    eBottomVerticalEndX = longEnd;
        
    letterE.addPoint(eBackboneX, baselineY, "backboneStart");              
    letterE.addPoint(eBackboneX, capHeightY, "backboneTop");              
    letterE.addPoint(eTopLineEndX, capHeightY, "topLineEnd");             
    letterE.addPoint(eTopVerticalEndX, eTopVerticalEndY, "topVerticalEnd");
    letterE.addPoint(eTopReturnX, eTopReturnY, "topReturnEnd");           
    
    letterE.addPoint(eMiddleStartX, eMiddleStartY, "middleLineStart");    
    letterE.addPoint(eMiddleLineX, eMiddleLineY, "middleLine");           
    letterE.addPoint(eMiddleVerticalX, eMiddleVerticalY, "middleVertical");
    letterE.addPoint(eMiddleReturnX, eMiddleReturnY, "middleReturn");     
    
    letterE.addPoint(eBottomStartX, eBottomStartY, "bottomLineStart");    
    letterE.addPoint(eBottomEndX, eBottomEndY, "bottomLineEnd");          
    letterE.addPoint(eBottomVerticalEndX, baselineY, "bottomVerticalEnd"); 
    
    circlePositions = letterE.generateCirclePositions();
}

void initializeLetterF() {
    letterF = new Letter();
    float longEnd = canvasSizePart* 8.25;

    fBackboneX = canvasSizePart * 3.75;
    fBackboneY = baselineY;
    fBackboneX2 = canvasSizePart * 3.75;
    fBackboneY2 = capHeightY;

    fTopLineEndX =  longEnd;
    fTopLineEndY = capHeightY;

    fTopVerticalEndX = fTopLineEndX;
    fTopVerticalEndY = capHeightY + stemWidth/1.3;

    fTopReturnX = fBackboneX + stemWidth;
    fTopReturnY = capHeightY + stemWidth;

    float middleY = capHeightY + int((baselineY - capHeightY) * (horizontalCenterLineY / 100.0))/1.7;
    fMiddleStartX = fBackboneX + stemWidth;
    fMiddleStartY = middleY;

    fMiddleLineX = shortEnd;
    fMiddleLineY = middleY;

    fMiddleVerticalX = fMiddleLineX;
    fMiddleVerticalY = middleY + stemWidth/1.3;

    fMiddleReturnX = fMiddleStartX;
    fMiddleReturnY = middleY + stemWidth;
    
    fBottomVerticalX = fMiddleReturnX;
    fBottomVerticalY = baselineY;
    
   
    letterF.addPoint(fBackboneX, baselineY, "fBackboneStart");           
    letterF.addPoint(fBackboneX, capHeightY, "fBackboneTop");           
    letterF.addPoint(fTopLineEndX, capHeightY, "fTopLineEnd");          
    letterF.addPoint(fTopVerticalEndX, fTopVerticalEndY, "fTopVerticalEnd"); 
    letterF.addPoint(fTopReturnX, fTopReturnY, "fTopReturnEnd");        
    letterF.addPoint(fMiddleStartX, fMiddleStartY, "fMiddleLineStart");  
    letterF.addPoint(fMiddleLineX, fMiddleLineY, "fMiddleLine");        
    letterF.addPoint(fMiddleVerticalX, fMiddleVerticalY, "fMiddleVertical"); 
    letterF.addPoint(fMiddleReturnX, fMiddleReturnY, "fMiddleReturn");  
    letterF.addPoint(fBottomVerticalX, baselineY, "fBottomVertical"); 
    circlePositions = letterF.generateCirclePositions();
}

void initializeLetterV() {
    letterV = new Letter();
    
    vApexPositions = new float[2][2];
    vSideDistance = new float[2][2][2];
    vApexTopControl = new float[2];
    
    // base positions
    float leftSideX = canvasSizePart * 3.25;
    float rightSideX = canvasSizePart * 8.75;

    float mainApexX = (apexNumber == 1) ? canvasSizePart * 6 : canvasSizePart * 5.5;
    float secondApexX = (apexNumber == 1) ? 0 : width/2 + stemWidth;
    
    // apex positions
    vApexPositions[0] = new float[]{mainApexX, baselineY};
    vApexPositions[1] = new float[]{secondApexX, baselineY};
    

    vApexTopControl[0] = (apexNumber == 1) ? mainApexX : (mainApexX + secondApexX)/2;
    vApexTopControl[1] = baselineY - stemWidth;
    
    // side distances
    vSideDistance[0][0] = new float[]{leftSideX, capHeightY};                  
    vSideDistance[0][1] = new float[]{leftSideX + stemWidth, capHeightY};    
    vSideDistance[1][0] = new float[]{rightSideX, capHeightY};                 
    vSideDistance[1][1] = new float[]{rightSideX - stemWidth, capHeightY};     
    
    letterV.addPoint(vApexPositions[0][0], vApexPositions[0][1], "mainApex");
    letterV.addPoint(vApexPositions[1][0], vApexPositions[1][1], "secondApex");
    letterV.addPoint(vSideDistance[0][0][0], vSideDistance[0][0][1], "leftTop");
    letterV.addPoint(vSideDistance[0][1][0], vSideDistance[0][1][1], "leftControl");
    letterV.addPoint(vApexTopControl[0], vApexTopControl[1], "apexTopControl");
    letterV.addPoint(vSideDistance[1][1][0], vSideDistance[1][1][1], "rightControl");
    letterV.addPoint(vSideDistance[1][0][0], vSideDistance[1][0][1], "rightTop");
    
    circlePositions = letterV.generateCirclePositions();
}
void initializeLetterJ() {
    letterJ = new Letter();
    
    jTopPoints = new float[2][2];
    jStemEnd = new float[2];
    jCurveControl = new float[2];
    jCurveEnd = new float[2];
    jInnerCurveControl = new float[2];

    jCurveControl1 = new float[2];
    jCurveControl2 = new float[2];
    
    jTopPoints[0][0] = canvasSizePart* 8.25 - stemWidth;  
    jTopPoints[0][1] = capHeightY;    
    
    jTopPoints[1][0] = canvasSizePart* 8.25;  
    jTopPoints[1][1] = capHeightY;            
    
    
    jStemEnd[0] = jTopPoints[1][0];  
    jStemEnd[1] = baselineY - (baselineY - capHeightY) * 0.35;  
    

    jCurveEnd[0] = canvasSizePart* 3.75; 
    jCurveEnd[1] = baselineY - 160;

    jCurveControl[0] = jTopPoints[1][0] - random(10, 40);
    jCurveControl[1] = baselineY+190;
    
    jCurveControl2[0] = jCurveEnd[0] - 50;  
    jCurveControl2[1] = jCurveEnd[1] + 50;  
    
    jConnectingPoint = new float[2];
    jConnectingPoint[0] = jCurveEnd[0] + stemWidth;
    jConnectingPoint[1] = jCurveEnd[1] - random(10, 30);



    jInnerCurveControl[0] = canvasSizePart* 4.75;
    jInnerCurveControl[1] = baselineY-10;
  
    jInnerCurveControl2 = new float[2];
    jInnerCurveControl2[0] = canvasSizePart* 9;
    jInnerCurveControl2[1] = baselineY+110;
    
    letterJ.addPoint(jTopPoints[0][0], jTopPoints[0][1], "topLeft");
    letterJ.addPoint(jTopPoints[1][0], jTopPoints[1][1], "topRight");
    letterJ.addPoint(jStemEnd[0], jStemEnd[1], "stemEnd");
    letterJ.addPoint(jCurveControl[0], jCurveControl[1], "curveControl");
    letterJ.addPoint(jCurveControl2[0], jCurveControl2[1], "curveControl2");
    letterJ.addPoint(jCurveEnd[0], jCurveEnd[1], "curveEnd");
    letterJ.addPoint(jInnerCurveControl[0], jInnerCurveControl[1], "innerCurveControl");
    letterJ.addPoint(jInnerCurveControl2[0], jInnerCurveControl2[1], "innerCurveControl2");
    letterJ.addPoint(jConnectingPoint[0], jConnectingPoint[1], "connectingPoint");
    
        circlePositions = letterJ.generateCirclePositions();
}



void initializeLetterI() {
    letterI = new Letter(); 

    iTopPositionsX = canvasSizePart * 5.5;
    iTopPositionsY= capHeightY;
    iTopPositionsX1 = iTopPositionsX+ stemWidth;
    iTopPositionsY1= capHeightY;
    
    iBottomPositionsX =  canvasSizePart * 5.5;
    iBottomPositionsY = baselineY;
    iBottomPositionsX1=  canvasSizePart * 5.5 + stemWidth;
    iBottomPositionsY1= baselineY;
    
    letterI.addPoint(iTopPositionsX , iTopPositionsY , "topLeft");
    letterI.addPoint(iTopPositionsX1, iTopPositionsY1, "topRight");
    letterI.addPoint(iBottomPositionsX, iBottomPositionsY, "bottomLeft");
    letterI.addPoint(iBottomPositionsX1, iBottomPositionsY1, "bottomRight");
    
    circlePositions = letterI.generateCirclePositions(); 
}



void initializeLetterN() {
    letterN = new Letter();
    float randomDiagonal = random(1.1, 1.5);
    float startX = canvasSizePart*3.25;
    nPoint1[0] = startX;
    nPoint1[1] = baselineY;
    letterN.addPoint(nPoint1[0], nPoint1[1], "point1");

    nPoint2[0] = startX;
    nPoint2[1] = capHeightY;
    letterN.addPoint(nPoint2[0], nPoint2[1], "point2");

    nPoint3[0] = startX + stemWidth * randomDiagonal;
    nPoint3[1] = capHeightY;
    letterN.addPoint(nPoint3[0], nPoint3[1], "point3");

    nPoint4[0] = canvasSizePart*8.75 - stemWidth;
    nPoint4[1] = baselineY - stemWidth;
    letterN.addPoint(nPoint4[0], nPoint4[1], "point4");

    nPoint5[0] = nPoint4[0];
    nPoint5[1] = capHeightY;
    letterN.addPoint(nPoint5[0], nPoint5[1], "point5");

    nPoint6[0] = nPoint5[0] + stemWidth;
    nPoint6[1] = capHeightY;
    letterN.addPoint(nPoint6[0], nPoint6[1], "point6");

    nPoint7[0] = nPoint6[0];
    nPoint7[1] = baselineY;
    letterN.addPoint(nPoint7[0], nPoint7[1], "point7");

    nPoint8[0] = nPoint7[0] - stemWidth * randomDiagonal;
    nPoint8[1] = baselineY;
    letterN.addPoint(nPoint8[0], nPoint8[1], "point8");

    nPoint9[0] = canvasSizePart*3.25 + stemWidth;
    nPoint9[1] = capHeightY + stemWidth;
    letterN.addPoint(nPoint9[0], nPoint9[1], "point9");

    nPoint10[0] = nPoint9[0];
    nPoint10[1] = baselineY;
    letterN.addPoint(nPoint10[0], nPoint10[1], "point10");

    circlePositions = letterN.generateCirclePositions();
}





void changeLetter(String letter) {
    currentLetter = letter;

    println("Zmiana litery na: " + currentLetter);
    if (letter.equals("A")) {
          if (letterA == null) {
        initializeLetterA();
          }
    currentLetterObject = letterA;
    circlePositions = letterA.generateCirclePositions();

    } else if (letter.equals("B")) {
        if (letterB == null) {
                initializeLetterB();
        }
    currentLetterObject = letterB;
    circlePositions = letterB.generateCirclePositions();
    }
    else if (letter.equals("C")) {
        if (letterC == null) {
            initializeLetterC();
        }
    currentLetterObject = letterC;
    circlePositions = letterC.generateCirclePositions();
    } else if (letter.equals("D")) {
        if (letterD == null) {
            initializeLetterD();
        }
    currentLetterObject = letterD;
    circlePositions = letterD.generateCirclePositions();
    } else if (letter.equals("E")) {
        if (letterE == null) {
            initializeLetterE();
        }
    currentLetterObject = letterE;
    circlePositions = letterE.generateCirclePositions();
    } else if (letter.equals("F")) {
        if (letterF == null) {
            initializeLetterF();
        }
    currentLetterObject = letterF;
    circlePositions = letterF.generateCirclePositions();
    }
    else if (currentLetter.equals("V")) { 
        if (letterV == null) {
            initializeLetterV();
        }
    currentLetterObject = letterV;
    circlePositions = letterV.generateCirclePositions();
    } else if (currentLetter.equals("J")) {
        if (letterJ == null) {
            initializeLetterJ();
        }
    currentLetterObject = letterJ;
    circlePositions = letterJ.generateCirclePositions();
    } else if (currentLetter.equals("I")) {
        if (letterI == null) {
            initializeLetterI();
        }
    currentLetterObject = letterI;
    circlePositions = letterI.generateCirclePositions();
    } else if (currentLetter.equals("N")) {
        if (letterN == null) {
            initializeLetterN();
        }
    currentLetterObject = letterN;
    circlePositions = letterN.generateCirclePositions();
    }   
}

//general functions, typography grid, stroke colors 

void drawTypographicZones() {
  stroke(255);
  strokeWeight(0.5);
  line(0, baselineY, width, baselineY); 
  line(0, capHeightY, width, capHeightY); 
  fill(255);
  textSize(12);
  text("baseline: " + baselineY, width - 100, baselineY - 5);
  text("capHeight: " + capHeightY, width - 100, capHeightY - 5);
}



//distortion functions

void polygonizeAndDistort(RPolygon polygon) {
    int totalPoints = countPolygonPoints(polygon);

    if (finalOffsets == null || finalOffsets.length != totalPoints || distortionChanged) {
        finalOffsets = new float[totalPoints][2];
        
        if (!useSineDistortion) {
            float noiseOffsetX = random(1000);
            float noiseOffsetY = random(1000);
            int pointIndex = 0;
            
            for (int i = 0; i < polygon.contours.length; i++) {
                for (int j = 0; j < polygon.contours[i].points.length; j++) {
                    float noiseValueX = noise(noiseOffsetX + i * noiseFactor + j * noiseFactor);
                    float noiseValueY = noise(noiseOffsetY + i * noiseFactor + j * noiseFactor);
                    finalOffsets[pointIndex][0] = map(noiseValueX, 0, 1, -distortionRange, distortionRange);
                    finalOffsets[pointIndex][1] = map(noiseValueY, 0, 1, -distortionRange, distortionRange);
                    pointIndex++;
                }
            }
        }
    }

    int pointIndex = 0;
    for (int i = 0; i < polygon.contours.length; i++) {
        for (int j = 0; j < polygon.contours[i].points.length; j++) {
            RPoint curPoint = polygon.contours[i].points[j];
            
            if (useSineDistortion) {
              
                float offset = sin(time + pointIndex * 6.7) * distortionRange;
                float angle = atan2(curPoint.y, curPoint.x);
                curPoint.x += cos(angle) * offset;
                curPoint.y += sin(angle) * offset;
            } else {
        
                curPoint.x += finalOffsets[pointIndex][0];
                curPoint.y += finalOffsets[pointIndex][1];
            }
            
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



//Letter A functions
int[][] generateInnerTriangle(int numberOfApexes) {
    int[][] triangle = new int[3][2];
    triangle[0][0] = horizontalLinePos[0][0];
    triangle[0][1] = horizontalLinePos[0][1] - int(random(20, 50)); 
    triangle[1][0] = horizontalLinePos[1][0];
    triangle[1][1] = horizontalLinePos[1][1] - int(random(20, 50)); 
    if (numberOfApexes > 1) {
    triangle[2][0] =  apexPositions[0][0] +  ((apexPositions[1][0] - apexPositions[0][0])/2); 
    } else {
        triangle[2][0] = apexPositions[0][0];
    }

    triangle[2][1] = capHeightY + int(random(20, 40)); 
    return triangle;
}

int[][] generateHorizontalLinePos() {
    int[][] horizontalLinePos = new int[2][2]; 
    horizontalCenterLineY = generateRandomPercentage(); 
        int lineY = capHeightY + int((baselineY - capHeightY) * (horizontalCenterLineY / 100.0));
    
    int unifiedLength = int(random(50, 60));
    horizontalLinePos[0][0] = letterSideDistance[1][1][0] - unifiedLength;
    horizontalLinePos[0][1] = lineY;
    horizontalLinePos[1][0] = letterSideDistance[0][1][0] + unifiedLength;
    horizontalLinePos[1][1] = lineY;
  
    return horizontalLinePos;
}

int generateRandomPercentage(){
     return int(random(65, 85));
}

int[][][] generateLegs(int baselineY) {
    int[][][] legs = new int[2][2][2]; 
   // left
    legs[0][0][0] = 200; 
    legs[0][0][1] = baselineY;          
    legs[0][1][0] = legs[0][0][0] + stemWidth; 
    legs[0][1][1] = baselineY;          

    // right
    legs[1][0][0] = 600; 
    legs[1][0][1] = baselineY;             
    legs[1][1][0] = legs[1][0][0] - stemWidth; 
    legs[1][1][1] = baselineY;          

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
    // First apex:
    positions[0][0] = int(random(390, 410));
    positions[0][1] = capHeightY;

    if (numberOfApexes > 1) {
        int maxDistanceX = 100;
        int firstApexX = positions[0][0];
        int firstApexY = positions[0][1];
        int x, y;
        do {
            x = int(random(max(20, firstApexX), firstApexX + maxDistanceX));
            y = int(random(50, 150));
        } while (y < 0 || y > height || x < 20 || (x == firstApexX && y == firstApexY));

        positions[1][0] = x;
        positions[1][1] = y;
    }

    return positions;
}

//letter B functions
int[] generateVerticalBLine() {
    int[] points = new int[2];
    points[0] = 400;
    points[1] = points[0] + int(random(-20, 20));
    return points;
}


void resetElement() {
baselineY = 700;
capHeightY = 100;
background(30, 24, 25);
if (currentLetter.equals("A")) {
    initializeLetterA();
    drawAShape();
    currentLetterObject = letterA;
  }
  else if (currentLetter.equals("B")) {
    initializeLetterB();
    drawBShape();
    circlePositions = letterB.generateCirclePositions();
    currentLetterObject = letterB;
  }  else if (currentLetter.equals("C")) {
    initializeLetterC();
    drawCShape();
    currentLetterObject = letterC;
  } else if (currentLetter.equals("D")) {
    initializeLetterD();
    drawDShape();
    currentLetterObject = letterD;
  } else if (currentLetter.equals("E")) {
    initializeLetterE();
    drawEShape();
    currentLetterObject = letterE;
  } else if (currentLetter.equals("F")) {
    initializeLetterF();
    drawFShape();
    currentLetterObject = letterF;
  } else if (currentLetter.equals("J")) {
    initializeLetterJ();
    drawJShape();
    currentLetterObject = letterJ;
  }
  else if (currentLetter.equals("V")) {
    initializeLetterV();
    drawVShape();
    currentLetterObject = letterV;
  }
  else if (currentLetter.equals("N")) {
    initializeLetterN();
    drawNShape();
    currentLetterObject = letterN;
  }
  else if (currentLetter.equals("I")) {
    initializeLetterI();
    drawIShape();
    currentLetterObject = letterI;
  }

  distortionChanged = true;
  segmentsChanged = true;
}


void startTransformation() {
  exportSVG();
}



void exportSVG() {
  isExportingSVG = true;
  
  String filename = "letter_" + currentLetter + ".svg";
  beginRecord(SVG, filename);
  
  switch(currentLetter) {
    case "A":
      drawAShape();
      break;
    case "B": 
      drawBShape();
      break;
    case "C":
      drawCShape();
      break;
    case "D":
      drawDShape();
      break;
    case "E":
      drawEShape();
      break;
  case "F": 
      drawFShape();
      break;

  case "J":
      drawJShape();
      break;
  
  case "V": 
      drawVShape();
      break;

  case "N": 
      drawNShape();
      break;

  case "I": 
      drawIShape();
      break;
  
}
  endRecord();
  isExportingSVG = false;
}

void keyPressed() {
    switch (key) {
        case 'A': case 'a':
            changeLetter("A");
            break;
        case 'B': case 'b':
            changeLetter("B");
            break;
        case 'C': case 'c':
            changeLetter("C");
            break;
        case 'D': case 'd':
            changeLetter("D");
            break;
        case 'E': case 'e':
            changeLetter("E");
            break;
        case 'F': case 'f':
            changeLetter("F");
            break;
        case 'V': case 'v':
            changeLetter("V");
            break;
        case 'J': case 'j':
            changeLetter("J");
            break;
        case 'I': case 'i':
            changeLetter("I");
            break; 
        case 'N': case 'n':
            changeLetter("N");
            break;
    } 
}

void updateLetterDPoints(int circleIndex, int x, int y) {
    switch (selectedCircle) {
        case 0: 
            dVerticalStemXBottom = x; 
            dVerticalStemYBottom = baselineY; 
            break;
        case 1: 
            dVerticalStemXTop = x; 
            dVerticalStemYTop = capHeightY; 
            break;
        case 2: 
            dBowlControlX1 = x; 
            dBowlControlY1 = y; 
            break;
        case 3: 
            dBowlControlX2 = x; 
            dBowlControlY2 = y; 
            break;
        case 4: 
            outterCurveEndX = x; 
            outterCurveEndY = y; 
            break;
        case 5: 
            innerCurveStartX = x; 
            innerCurveStartY = y; 
            break;
        case 6: 
            dInnerControlX1 = x; 
            dInnerControlY1 = y; 
            break;
        case 7: 
            dInnerControlX2 = x; 
            dInnerControlY2 = y; 
            break;
        case 8: 
            innerCurveEndX = x; 
            innerCurveEndY = y; 
            break;
    }
}

void updateLetterEPoints(int circleIndex, int x, int y) {
    switch (circleIndex) {
        case 0:
            eBackboneX = x;
            break;
        case 1:
            eBackboneX2 = x;
            break;
        case 2:
            eTopLineEndX = x;
            break;
        case 3:
            eTopVerticalEndX = x;
            eTopVerticalEndY = y;
            break;
        case 4:
            eTopReturnX = x;
            eTopReturnY = y;
            break;
        case 5:
            eMiddleStartX = x;
            eMiddleStartY = y;
            break;
        case 6:
            eMiddleLineX = x;
            eMiddleLineY = y;
            break;
        case 7:
            eMiddleVerticalX = x;
            eMiddleVerticalY = y;
            break;
        case 8:
            eMiddleReturnX = x;
            eMiddleReturnY = y;
            break;
        case 9:
            eBottomStartX = x;
            eBottomStartY = y;
            break;
        case 10:
            eBottomEndX = x;
            eBottomEndY = y;
            break;
        case 11:
            eBottomVerticalEndX = x;
            break;
    }
}

void updateLetterFPoints(int circleIndex, int x, int y) {
    switch (circleIndex) {
        case 0:
            fBackboneX = x;
            break;
        case 1:
            fBackboneX2 = x;
            break;
        case 2:
            fTopLineEndX = x;
            break;
        case 3:
            fTopVerticalEndX = x;
            fTopVerticalEndY = y;
            break;
        case 4:
            fTopReturnX = x;
            fTopReturnY = y;
            break;
        case 5:
            fMiddleStartX = x;
            fMiddleStartY = y;
            break;
        case 6:
            fMiddleLineX = x;
            fMiddleLineY = y;
            break;
        case 7:
            fMiddleVerticalX = x;
            fMiddleVerticalY = y;
            break;
        case 8:
            fMiddleReturnX = x;
            fMiddleReturnY = y;
            break;
        case 9:
            fBottomVerticalX = x;
            break;
    }
}

void updateLetterVPoints(int circleIndex, int x, int y) {
    switch(circleIndex) {
        case 0:
            vApexPositions[0][0] = x;
            vApexPositions[0][1] = baselineY;
            break;
        case 1:
            vApexPositions[1][0] = x;
            vApexPositions[1][1] = baselineY;
            break;
        case 2:
            vSideDistance[0][0][0] = x;
            vSideDistance[0][0][1] = capHeightY;
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
            vSideDistance[1][0][1] = capHeightY;
            break;
    }
}

void updateLetterJPoints(int circleIndex, int x, int y) {
    switch (circleIndex) {
        case 0:
            jTopPoints[0][0] = x;
            jTopPoints[0][1] = capHeightY;
            break;
        case 1:
            jTopPoints[1][0] = x;
            jTopPoints[1][1] = capHeightY;
            break;
        case 2:
            jStemEnd[0] = x;
            jStemEnd[1] = y;
            break;
        case 3:
            jCurveControl[0] = x;
            jCurveControl[1] = y;
            break;
        case 4:
            jCurveControl2[0] = x;
            jCurveControl2[1] = y;
            break;
        case 5:
            jCurveEnd[0] = x;
            jCurveEnd[1] = y;
            break;
        case 6:
            jInnerCurveControl[0] = x;
            jInnerCurveControl[1] = y;
            break;
        case 7:
            jInnerCurveControl2[0] = x;
            jInnerCurveControl2[1] = y;
            break;
        case 8:
            jConnectingPoint[0] = x;
            jConnectingPoint[1] = y;
            break;
    }
}

void updateLetterIPoints(int circleIndex, int x, int y) {
    switch (circleIndex) {
        case 0:
            iTopPositionsX = x;
            iTopPositionsY = y;
            break;
        case 1:
            iTopPositionsX1 = x;
            iTopPositionsY1 = y;
            break;
        case 2:
            iBottomPositionsX = x;
            iBottomPositionsY = y;
            break;
        case 3:
            iBottomPositionsX1 = x;
            iBottomPositionsY1 = y;
            break;
    }
}

void updateLetterNPoints(int circleIndex, int x, int y) {
    switch (circleIndex) {
        case 0:
            nPoint1[0] = x;
            nPoint1[1] = baselineY;
            break;
        case 1:
            nPoint2[0] = x;
            nPoint2[1] = capHeightY;
            break;
        case 2:
            nPoint3[0] = x;
            nPoint3[1] = capHeightY;
            break;
        case 3:
            nPoint4[0] = x;
            nPoint4[1] = y;
            break;
        case 4:
            nPoint5[0] = x;
            nPoint5[1] = capHeightY;
            break;
        case 5:
            nPoint6[0] = x;
            nPoint6[1] = capHeightY;
            break;
        case 6:
            nPoint7[0] = x;
            nPoint7[1] = baselineY;
            break;
        case 7:
            nPoint8[0] = x;
            nPoint8[1] = baselineY;
            break;
        case 8:
            nPoint9[0] = x;
            nPoint9[1] = y;
            break;
        case 9:
            nPoint10[0] = x;
            nPoint10[1] = baselineY;
            break;
    }
}

//mouse functions

void mouseReleased() {
  selectedCircle = -1;
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
        if (currentLetterObject != null) {
            currentLetterObject.updatePoint(selectedCircle, mouseX, mouseY);
            circlePositions = currentLetterObject.generateCirclePositions();
        }

        circlePositions[selectedCircle][0] = mouseX;
        circlePositions[selectedCircle][1] = mouseY;

        LetterUpdateFunction updateFn = updateFunctions.get(currentLetter);
        Runnable drawFn = drawFunctions.get(currentLetter);
        
        if (updateFn != null && drawFn != null) {
            updateFn.update(selectedCircle, mouseX, mouseY);
            drawFn.run();
        }
    }
}


void updatePoint(int[] point, int x, int y) {
  point[0] = x;
  point[1] = y;
}


void updateLetterAPoints(int circleIndex, int x, int y) {
  if (apexNumber == 1 && circleIndex >= 3) {
   
    switch (circleIndex) {
      case 2:
        updatePoint(letterSideDistance[1][0], x, baselineY); 
        break;
      case 3:
        updatePoint(horizontalLinePos[0], x, y);      
        deltaHorizontalLine = y - baselineY;
        break;
      case 4:
        updatePoint(horizontalLinePos[1], x, y);       
        deltaHorizontalLine = y - baselineY;
        break;
      case 5:
        updatePoint(letterSideDistance[0][1], x, y); 
        break;
      case 6:
        updatePoint(letterSideDistance[1][1], x, y); 
        break;
      case 7:
        updatePoint(innerTriangle[0], x, y);           
        deltaTriangle1 = y - baselineY;
        break;
      case 8:
        updatePoint(innerTriangle[1], x, y);           
        deltaTriangle2 = y - baselineY;
        break;
      case 9:
        updatePoint(innerTriangle[2], x, y);          
        deltaTopTriangle = y - capHeightY;
        break;
    }
  } else {
    switch (circleIndex) {
      case 0:
        updatePoint(letterSideDistance[0][0], x, baselineY);
        break;
      case 1:
        updatePoint(letterSideDistance[1][0], x, baselineY);
        break;
      case 2:
        updatePoint(apexPositions[0], x, capHeightY);
        break;
      case 3:
        if (apexNumber == 2) {
          updatePoint(apexPositions[1], x, y);
        }
        break;
      case 4:
        updatePoint(horizontalLinePos[0], x, y);
        deltaHorizontalLine = y - baselineY;
        break;
      case 5:
        updatePoint(horizontalLinePos[1], x, y);
        deltaHorizontalLine = y - baselineY;
        break;
      case 6:
        updatePoint(letterSideDistance[0][1], x, y);
        break;
      case 7:
        updatePoint(letterSideDistance[1][1], x, y);
        break;
      case 8:
        updatePoint(innerTriangle[0], x, y);
        deltaTriangle1 = y - baselineY;
        break;
      case 9:
        updatePoint(innerTriangle[1], x, y);
        deltaTriangle2 = y - baselineY;
        break;
      case 10:
        updatePoint(innerTriangle[2], x, y);
        deltaTopTriangle = y - capHeightY;
        break;
    }
  }
}

void updateLetterBPoints(int circleIndex, int x, int y) {
  switch (circleIndex) {
    case 0: 
      stemBottomX = x;
      stemBottomY = baselineY;
      break;
    case 1: 
      stemTopX = x;
      stemTopY = capHeightY;
      break;
    case 2: 
      upperBowlControl1X = x;
      upperBowlControl1Y = y;
      break;
    case 3: 
      upperBowlControl2X = x;
      upperBowlControl2Y = y;
      break;
    case 4: 
      lowerBowlControl1X = x;
      lowerBowlControl1Y = y;
      break;
    case 5: 
      lowerBowlControl2X = x;
      lowerBowlControl2Y = y;
      break;
    case 6: 
      innerUpperControl1X = x;
      innerUpperControl1Y = y;
      break;
    case 7: 
      innerUpperControl2X = x;
      innerUpperControl2Y = y;
      break;
    case 8: 
      innerLowerControl1X = x;
      innerLowerControl1Y = y;
      break;
    case 9: 
      innerLowerControl2X = x;
      innerLowerControl2Y = y;
      break;
    case 10: 
      middleX = x;
      middleY = y;
      break;
    case 11: 
      innerEndPointX = x;
      innerEndPointY = y;
      break;
    case 12: 
      innerEndPointX1 = x;
      innerEndPointY1 = y;
      break;
    case 13: 
      innerStartX = x;
      innerStartY = y;
      break;
    case 14: 
      innerStartX1 = x;
      innerStartY1 = y;
      break;
  }
}

void updateLetterCPoints(int circleIndex, int x, int y) {
    switch (circleIndex) {
        case 0: 
            mainPointC = x; 
            mainPointCY = y; 
            break;
        case 1: 
            outterBigCurveX = x; 
            outterBigCurveY = y; 
            break;
        case 2: 
            outterBigCurveX2 = x; 
            outterBigCurveY2 = y; 
            break;
        case 3: 
            smallOutterCurveX = x; 
            smallOutterCurveY = y; 
            break;
        case 4: 
            smallOutterCurveX2 = x; 
            smallOutterCurveY2 = y; 
            break;
        case 5: 
            smallOutterCurveXend = x; 
            smallOutterCurveYend = y; 
            break;
        case 6: 
            streightLineX = x; 
            streightLineY = y; 
            break;
        case 7: 
            innerBigCurveX1 = x; 
            innerBigCurveY1 = y; 
            break;
        case 8: 
            innerBigCurveX2 = x; 
            innerBigCurveY2 = y; 
            break;
        case 9: 
            innerSmallCurveXDown = x; 
            innerSmallCurveYDown = y; 
            break;
        case 10: 
            innerSmallCurveX2Down = x; 
            innerSmallCurveY2Down = y; 
            break;
        case 11: 
            innerSmallCurveX1Top = x; 
            innerSmallCurveY1Top = y; 
            break;
        case 12: 
            innerSmallCurveX2Top = x; 
            innerSmallCurveY2Top = y; 
            break;
        case 13: 
            innerSmallCurveXEnd = x; 
            innerSmallCurveYEnd = y; 
            break;
        case 14: 
            upperStraightLineX = x; 
            upperStraightLineY = y; 
            break;
    }
}

void drawControlPoints() {
    if (!isExportingSVG) {
        for (int i = 0; i < circlePositions.length; i++) {
            fill(245, 245, 220);
            noStroke();
            ellipse(circlePositions[i][0], circlePositions[i][1], circleRadius * 2, circleRadius * 2);
        }
    }
}

void drawDistortedShape(RShape letterShape) {
    originalPolygon = letterShape.toPolygon();
    RPolygon distortedPolygon = copyPolygon(originalPolygon);
    polygonizeAndDistort(distortedPolygon);
    
    noFill();
    stroke(strokeR, strokeG, strokeB);
    strokeWeight(2);
    distortedPolygon.draw();
    
    drawControlPoints();
}
