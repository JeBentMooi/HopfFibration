//library for extrusions: Shapes 3D
import shapes3d.*;
import shapes3d.contour.*;
import shapes3d.org.apache.commons.math.*;
import shapes3d.org.apache.commons.math.geometry.*;
import shapes3d.path.*;
import shapes3d.utils.*;

//library for complex numbers: QScript
import org.qscript.*;
import org.qscript.editor.*;
import org.qscript.errors.*;
import org.qscript.events.*;
import org.qscript.eventsonfire.*;
import org.qscript.operator.*;



//______________________________________________________________________________________________________________________________________________________________________________________________
//______________________________________________________________________________________________________________________________________________________________________________________________

  Complex i = new Complex(0,1); //i
 
  //SETUP ARRAY OF CIRCLE POINTS
  int noPoints = 150; //how many points will be used to draw 1 circle; must be >=3
  int noCircles = 30; //how many circles do you want to plot? - can be changed with scrollbar
  Vector[][]circlePoints;
  Complex[]startingPoints;
  
  //SETUP SCROLLBARS
  HScrollbar s_VaryPhi, s_VaryTheta, s_VaryTheta2, s_Spiral;
  HScrollbar s_Flow, s_noCircles;
  boolean VaryThetaMode = true;
  boolean VaryPhiMode = false;
  boolean SpiralMode = false;
  boolean RotationMode = true;
  boolean zoomMode = false;
  float rot = 0;
  int camMode = 0;
  
  //SETUP DISC LIKE D SECTION
  Vector[]boundaryPoints;
  
  //SETUP FLOWING GRIDS
  int noCol = 15;
  int noRow = 15;
  CxComplex[][] grid = new CxComplex[noCol][noRow];
  CxComplex[][] FlowingGrid = new CxComplex[noCol][noRow];
  int varyR = 5;
  int varyTheta = 5;
  CxComplex[][] circularGrid = new CxComplex[varyR][varyTheta];
  PVector[][] tubes;

void setup() {
  size(800, 800, P3D);
  frameRate(10); //fix-bug-thing
  setupScrollbars();
  
  //SETUP DISC LIKE D SECTION
  CxComplex N = new CxComplex(1,0,0,0); //north pole projection
  //CxComplex S = new CxComplex(0,0,1,0); //south pole
  //CxComplex P = new CxComplex(4,200,0,123); //random point on sphere - gets normalized in setup
  setupDSectionGrid(noCol,noRow,N);
  setupDSectionBoundary(20, N);
  circularGrid = getDSectionGridCircular(varyR, varyTheta);
  
  //SETUP TUBES
  //tubes = setupTubes(grid, 2*PI, 40);
  
}


void draw(){
  background(0);
  
  //UPDATE NoCircles - always an even number!
  noCircles = 2*(int)scrollbarValue(s_noCircles, 50);
  //get everything in order to plot
  circlePoints = new Vector[noCircles][noPoints];
  //setup array of points of interest in C, whose fibres we want to find
  startingPoints = new Complex[noCircles];

  
  //SETUP STARTING POINTS
  if (VaryThetaMode == true){
  addPointsVaryTheta(noCircles/2, scrollbarValue(s_VaryTheta, PI));
  addPointsVaryTheta(noCircles/2,noCircles/2, scrollbarValue(s_VaryTheta2, PI));
  } else if(VaryPhiMode == true){
  addPointsVaryPhi(noCircles, scrollbarValue(s_VaryPhi, PI));
  } else if (SpiralMode == true){
  addPointsSpiral(noCircles);
  }
     
  //CHOOSE CAMERAMODE
  if(camMode%2 == 1){
    camera(mouseX*1.5, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0); //camera which rotates objects with MouseX
  } else if(camMode%2 == 0){
  camera(width/2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0); //centered camera
  }
  
    
  //SETUP COORDINATE SYSTEM
  centerCoordinatesystem();
  drawAxes(300);
  nameAxes(300);
  
  //DRAW D SECTION
  //drawSouthernDSection(); //Point S
  //drawDSectionBoundary(boundaryPoints); //all other Points
  //displayGrid(grid);
  FlowingGrid = letGridFlow(circularGrid, scrollbarValue(s_Flow,2.5*PI));
  displayGrid(FlowingGrid, true);
  displayGrid(circularGrid, true);
  //TUBES
  //drawTube(tubes, scrollbarValue(s_Flow, 35)+5);
 
  //DRAW Fibres
  fillArray();
  drawColCircle(); //draw fibres
  
  //DRAW SPHERE IN CORNER
  camera(); //back to normal camera settings for the overlay
  centerCoordinatesystemOverlay();
  if(RotationMode == true){
    rot = getRotation(rot);
  }
  rotateSphere(rot);
  drawAxes(80,3);
  drawSphere();
  drawPointsOnSphere(startingPoints);
  
  //DRAW SLIDERS
  camera(); //back to normal camera settings for second overlay
  updateScrollbars();
  displayScrollbars();
  drawButtons();
}

void mousePressed() {
  if (overVaryThetaButton()==true) {
    VaryThetaMode = true;
    VaryPhiMode = false;
    SpiralMode = false;
  }
  if (overVaryPhiButton()==true) {
    VaryThetaMode = false;
    VaryPhiMode = true;
    SpiralMode = false;
  }
  if(overSpiralButton() ==true){
    VaryThetaMode = false;
    VaryPhiMode = false;
    SpiralMode = true;
  }
  if(overSphere()==true && RotationMode == true){
    RotationMode = false;
  } else if(overSphere()==true && RotationMode == false){
    RotationMode = true;
  }
}

void keyPressed(){
  if (key == CODED) {
    if (keyCode == UP) {
      camMode++;
    }
  }
}
