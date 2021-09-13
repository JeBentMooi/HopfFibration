//library for recording the screen
//import processing.video.*;
//import com.hamoid.*;

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
  HScrollbar s_gamma_1, s_gamma_2, s_gamma_3, s_gamma_4;
  HScrollbar s_Flow, s_noCircles;
  boolean VaryThetaMode = true;
  boolean VaryPhiMode = false;
  boolean SpiralMode = false;
  boolean RotationMode = true;
  boolean zoomMode = false;
  float rot = 0;
  int camMode = 0;
  boolean Mode1sectStd = false;
  boolean Mode1sect = false;
  boolean Mode2sect = false;
  
  //SETUP D SECTION GRIDS
  int varyR = 8;
  int varyTheta = 15;
  CxComplex[][] circularGrid = new CxComplex[varyR][varyTheta];
  CxComplex[][] circularGrid_flow = new CxComplex[varyR][varyTheta];
  CxComplex[][] circularGrid_rot = new CxComplex[varyR][varyTheta];
  PVector[][] tubes;

  //2.2.1
  CxComplex[][] V_1grid_1 = getV_1part(13,20);
  CxComplex[][] V_2grid_1 = getV_2part(13,20);
  CxComplex[][] V_1grid_1_rot = getV_1part(13,20);
  CxComplex[][] V_2grid_1_rot = getV_2part(13,20);
  CxComplex[][] V_1grid_1_flow = getV_1part(13,20);
  CxComplex[][] V_2grid_1_flow = getV_2part(13,20);
  
  
  //2.2.2
  CxComplex[][] V_1grid_2 = getV_1part_2Section(13,20);
  CxComplex[][] V_2grid_2 = getV_2part_2Section(13,20);
  CxComplex[][] V_1grid_2_rot = getV_1part_2Section(13,20);
  CxComplex[][] V_2grid_2_rot = getV_2part_2Section(13,20);
  CxComplex[][] V_1grid_2_flow = getV_1part_2Section(13,20);
  CxComplex[][] V_2grid_2_flow = getV_2part_2Section(13,20);

  //rotation modes & flow mode
  boolean rotMode1 = false;
  boolean rotMode2 = false;
  boolean rotMode3 = false;
  boolean flowMode = false;
  
void setup() {
  size(900, 800, P3D);
  frameRate(10); //fix-bug-thing, do not delete
  setupScrollbars();
  //grid
  circularGrid = getDSectionGridCircular(varyR, varyTheta);
  circularGrid_flow = getDSectionGridCircular(varyR, varyTheta);
  circularGrid_rot = getDSectionGridCircular(varyR, varyTheta);
  
  //SETUP TUBES
  //tubes = setupTubes(circularGrid, 2*PI);
}


void draw(){
  background(0);
  
  //CHOOSE CAMERAMODE
  if(camMode%3 == 1){
    camera(mouseX*2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0); //camera which rotates objects with MouseX
  } else if(camMode%3 == 0){
    camera(width/2, height/2, (height/2) / tan(PI/6), width/2, height/2, 0, 0, 1, 0); //centered camera
  } 
  
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
  if (Mode1sectStd == true){ //Std grids
    if(rotMode1 == true){
      circularGrid_rot = rotateDSection(circularGrid, scrollbarValue(s_gamma_1,2*PI),1);
      displayGrid(circularGrid_rot, true, 250,250,0);
      displayGrid(circularGrid, true);
      if (flowMode == true){
        circularGrid_flow = letGridFlow(circularGrid_rot, scrollbarValue(s_Flow,2*PI));
        displayGrid(circularGrid_flow, true, 200,0,200);
      }
    } else if (rotMode2 == true){
      circularGrid_rot = rotateDSection(circularGrid, scrollbarValue(s_gamma_2,2*PI),2);
      displayGrid(circularGrid_rot, true, 250,250,0);
      displayGrid(circularGrid, true);
      if (flowMode == true){
        circularGrid_flow = letGridFlow(circularGrid_rot, scrollbarValue(s_Flow,2*PI));
        displayGrid(circularGrid_flow, true, 200,0,200);
      }
    } else if (rotMode3 == true){
      circularGrid_rot = rotateDSection(circularGrid, scrollbarValue(s_gamma_3,2*PI),3);
      displayGrid(circularGrid_rot, true, 250,250,0);
      displayGrid(circularGrid, true);
      if (flowMode == true){
        circularGrid_flow = letGridFlow(circularGrid_rot, scrollbarValue(s_Flow,2*PI));
        displayGrid(circularGrid_flow, true, 200,0,200);
      }
    } else { //no rotation mode == true
      displayGrid(circularGrid, true);
      if (flowMode == true){
        circularGrid_flow = letGridFlow(circularGrid, scrollbarValue(s_Flow,2*PI));
        displayGrid(circularGrid_flow, true, 200,0,200);
        //TUBES
        //drawTubeCoord(tubes, scrollbarValue(s_Flow, 50));
      }
    }
  
  } else if (Mode1sect == true){ //2.2.1 - glue meridonal disc to annulus
    if(rotMode1 == true){
      V_1grid_1_rot = rotateDSection(V_1grid_1, scrollbarValue(s_gamma_1,2*PI),1); 
      V_2grid_1_rot = rotateDSection(V_2grid_1, scrollbarValue(s_gamma_1,2*PI),1); 
      displayGridsColoured(V_1grid_1_rot, V_2grid_1_rot);
      displayGrids(V_1grid_1, V_2grid_1);
      if (flowMode == true){
        V_1grid_1_flow = letGridFlow(V_1grid_1_rot, scrollbarValue(s_Flow,2*PI));
        V_2grid_1_flow = letGridFlow(V_2grid_1_rot, scrollbarValue(s_Flow,2*PI));
        displayGridsColoured(V_1grid_1_flow,V_2grid_1_flow);
      }
    } else if(rotMode2 == true){
      V_1grid_1_rot = rotateDSection(V_1grid_1, scrollbarValue(s_gamma_2,2*PI),2); 
      V_2grid_1_rot = rotateDSection(V_2grid_1, scrollbarValue(s_gamma_2,2*PI),2); 
      displayGridsColoured(V_1grid_1_rot, V_2grid_1_rot);
      displayGrids(V_1grid_1, V_2grid_1);
      if (flowMode == true){
        V_1grid_1_flow = letGridFlow(V_1grid_1_rot, scrollbarValue(s_Flow,2*PI));
        V_2grid_1_flow = letGridFlow(V_2grid_1_rot, scrollbarValue(s_Flow,2*PI));
        displayGridsColoured(V_1grid_1_flow,V_2grid_1_flow);
      }
    } else if(rotMode3 == true){
      V_1grid_1_rot = rotateDSection(V_1grid_1, scrollbarValue(s_gamma_3,2*PI),3); 
      V_2grid_1_rot = rotateDSection(V_2grid_1, scrollbarValue(s_gamma_3,2*PI), 3); 
      displayGridsColoured(V_1grid_1_rot, V_2grid_1_rot);
      displayGrids(V_1grid_1, V_2grid_1);
      if (flowMode == true){
        V_1grid_1_flow = letGridFlow(V_1grid_1_rot, scrollbarValue(s_Flow,2*PI));
        V_2grid_1_flow = letGridFlow(V_2grid_1_rot, scrollbarValue(s_Flow,2*PI));
        displayGridsColoured(V_1grid_1_flow,V_2grid_1_flow);
      }
    } else {
      displayGrids(V_1grid_1, V_2grid_1);
      if (flowMode == true){
        V_1grid_1_flow = letGridFlow(V_1grid_1, scrollbarValue(s_Flow,2*PI));
        V_2grid_1_flow = letGridFlow(V_2grid_1, scrollbarValue(s_Flow,2*PI));
        displayGridsColoured(V_1grid_1_flow,V_2grid_1_flow);
      //TUBES
      //drawTubeCoord(tubes, scrollbarValue(s_Flow, 50));
      }
    }
    
  } else if(Mode2sect == true){ //2.2.2 - glue two annuli
    if(rotMode1 == true){
      V_1grid_2_rot = rotateDSection(V_1grid_2, scrollbarValue(s_gamma_1,2*PI),1); 
      V_2grid_2_rot = rotateDSection(V_2grid_2, scrollbarValue(s_gamma_1,2*PI),1); 
      displayGridsColoured(V_1grid_2_rot, V_2grid_2_rot);
      displayGrids(V_1grid_2, V_2grid_2);
      if(flowMode == true){
        V_1grid_2_flow = letGridFlow(V_1grid_2_rot, scrollbarValue(s_Flow,2*PI));
        V_2grid_2_flow = letGridFlow(V_2grid_2_rot, scrollbarValue(s_Flow,2*PI));
        displayGridsColoured(V_1grid_2_flow,V_2grid_2_flow);
      }
    } else if(rotMode2 == true){
      V_1grid_2_rot = rotateDSection(V_1grid_2, scrollbarValue(s_gamma_2,2*PI),2); 
      V_2grid_2_rot = rotateDSection(V_2grid_2, scrollbarValue(s_gamma_2,2*PI),2); 
      displayGridsColoured(V_1grid_2_rot, V_2grid_2_rot);
      displayGrids(V_1grid_2, V_2grid_2);
      if(flowMode == true){
        V_1grid_2_flow = letGridFlow(V_1grid_2_rot, scrollbarValue(s_Flow,2*PI));
        V_2grid_2_flow = letGridFlow(V_2grid_2_rot, scrollbarValue(s_Flow,2*PI));
        displayGridsColoured(V_1grid_2_flow,V_2grid_2_flow);
      }
    } else if(rotMode3 == true){
      V_1grid_2_rot = rotateDSection(V_1grid_2, scrollbarValue(s_gamma_3,2*PI),3); 
      V_2grid_2_rot = rotateDSection(V_2grid_2, scrollbarValue(s_gamma_3,2*PI),3); 
      displayGridsColoured(V_1grid_2_rot, V_2grid_2_rot);
      displayGrids(V_1grid_2, V_2grid_2);
      if(flowMode == true){
        V_1grid_2_flow = letGridFlow(V_1grid_2_rot, scrollbarValue(s_Flow,2*PI));
        V_2grid_2_flow = letGridFlow(V_2grid_2_rot, scrollbarValue(s_Flow,2*PI));
        displayGridsColoured(V_1grid_2_flow,V_2grid_2_flow);
      }
    } else {
      displayGrids(V_1grid_2, V_2grid_2);
      if(flowMode == true){
        V_1grid_2_flow = letGridFlow(V_1grid_2, scrollbarValue(s_Flow,2*PI));
        V_2grid_2_flow = letGridFlow(V_2grid_2, scrollbarValue(s_Flow,2*PI));
        displayGridsColoured(V_1grid_2_flow,V_2grid_2_flow);
      }
    }
 } else {  }
 
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
  //rec();
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
  if (over1sectionStd()==true) {
    Mode1sectStd = true;
    Mode1sect = false;
    Mode2sect = false;
    
    rotMode1 = false;
    rotMode2 = false;
    rotMode3 = false;
    flowMode = false;
  }
  if (over1section()==true) {
    Mode1sectStd = false;
    Mode1sect = true;
    Mode2sect = false;
    
    rotMode1 = false;
    rotMode2 = false;
    rotMode3 = false;
    flowMode = false;
  }
  if (over2section()==true) {
    Mode1sectStd = false;
    Mode1sect = false;
    Mode2sect = true;
    
    rotMode1 = false;
    rotMode2 = false;
    rotMode3 = false;
    flowMode = false;
  }
  if (overGamma1()==true) {
    rotMode1 = true;
    rotMode2 = false;
    rotMode3 = false;
  }
  if (overGamma2()==true) {
    rotMode1 = false;
    rotMode2 = true;
    rotMode3 = false;
  }
  if (overGamma3()==true) {
    rotMode1 = false;
    rotMode2 = false;
    rotMode3 = true;
  }
  if (overFlow()==true) {
     flowMode = true;
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
