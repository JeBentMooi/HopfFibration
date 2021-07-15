//library for recording the screen
import processing.video.*;
import com.hamoid.*;

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
 
  //SETUP HOPF FIBRES
  int noPoints = 150; //how many points will be used to draw 1 circle; must be >=3
  int noCircles = 30; //how many circles do you want to plot? - can be changed with scrollbar
  Vector[][]circlePoints;
  Complex[]startingPoints;
  
  //SETUP SCROLLBARS & BUTTONS
  HScrollbar s_VaryPhi, s_VaryTheta, s_VaryTheta2, s_Spiral;
  HScrollbar s_Flow, s_noCircles;
  boolean VaryThetaMode = true;
  boolean VaryPhiMode = false;
  boolean SpiralMode = false;
  boolean RotationMode = true;
  boolean zoomMode = false;
  float rot = 0;
  int camMode = 0;
  
  
  //SETUP D SECTION GRIDS
  Vector[]boundaryPoints;
  int noCol = 15;
  int noRow = 15;
  CxComplex[][] grid = new CxComplex[noCol][noRow];
  CxComplex[][] FlowingGrid = new CxComplex[noCol][noRow];
  int varyR = 8;
  int varyTheta = 15;
  CxComplex[][] circularGrid = new CxComplex[varyR][varyTheta];
  PVector[][] tubes;

  //2.2.1
  CxComplex[][] V_1grid_1 = getV_1part(13,20);
  CxComplex[][] V_2grid_1 = getV_2part(13,20);
  
  //2.2.2
  CxComplex[][] V_1grid_2 = getV_1part2(13,20);
  CxComplex[][] V_2grid_2 = getV_2part2(13,20);

void setup() {
  size(800, 800, P3D);
  frameRate(10); //fix-bug-thing, do not delete
  setupScrollbars();
  
  //SETUP DISC LIKE D SECTION
  // - these are the "old" way of drawing the d section.
  CxComplex N = new CxComplex(1,0,0,0); //north pole projection
  //CxComplex S = new CxComplex(0,0,1,0); //south pole
  //CxComplex P = new CxComplex(4,200,0,123); //random point on sphere - gets normalized in setup
  setupDSectionGrid(noCol,noRow,N);
  //setupDSectionBoundary(20, N);
  // - new way:
  circularGrid = getDSectionGridCircular(varyR, varyTheta);
  circularGrid = rotateDSection(circularGrid, 0, PI/2 ,PI/4, 3*PI/4); 
  //2.2.1 - helicoidal annulus
  //circularGrid = getV_1part(10, 20);
  
  //SETUP TUBES
  //tubes = setupTubes(circularGrid, 2*PI);
}


void draw(){
  background(0);
  
  //CHOOSE CAMERAMODE
  //if(camMode%3 == 1){
  //  camera(mouseX*2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0); //camera which rotates objects with MouseX
  //} else if(camMode%3 == 0){
  //  camera(width/2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0); //centered camera
  //} 
  
  //UPDATE NoCircles
  noCircles = 2*(int)scrollbarValue(s_noCircles, 50); //always even number
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
  
  //SETUP COORDINATE SYSTEM
  centerCoordinatesystem();
  drawAxes(300);
  nameAxes(300);
  
  //DRAW D SECTION
  // - "old"
  //drawSouthernDSection(); //Point S
  //drawDSectionBoundary(boundaryPoints); //all other Points
  //displayGrid(grid);
  //FlowingGrid = letGridFlow(grid, scrollbarValue(s_Flow,2*PI));
  //displayGrid(FlowingGrid, false, 250,0,250);
  
  // - "new"
  //FlowingGrid = letGridFlow(circularGrid, scrollbarValue(s_Flow,2*PI));
  //FlowingGrid = letGridFlow(circularGrid, 3*PI/4);
  //displayGrid(FlowingGrid, true, 250,0,250);
  //displayGrid(circularGrid, true);
  //TUBES
  //drawTubeCoord(tubes, scrollbarValue(s_Flow, 50));
 
  //2.2.1 or 2.2.2 - helicoidal annulus or annular 2-section
  displayGrids(V_1grid, V_2grid);
 
  //DRAW FIBRES  
  fillArray(); //compute
  drawColCircle(); //draw fibres
  
  //  - GUI - 
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
  
  //enable to record screen:
  rec();
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
  } else if (key == 'q') {
    videoExport.endMovie();
    exit();
  }
}
