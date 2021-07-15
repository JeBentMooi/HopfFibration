
//_______________________________________________GRAPHICS FUNCTIONS_______________________________________________________________________________________________________________________________________________
//____________________________________________SETUP COORDINATE SYSTEM FUNCTIONS__________________________________________________________________________________________________________________________________________________

void centerCoordinatesystem(){
  translate(width/2-50, height/2+50, -100);
  scale(100);
  rotateX(3*PI/8);
  rotateZ(PI/8);
}

void resetCoordinatesystem(){
  rotateZ(2*PI-PI/8);
  rotateX(2*PI-3*PI/8);
  translate(-width/2, -height/2, 0);
}

void drawAxes(float size){
  //X  - red
  stroke(192,0,0);
  strokeWeight(0.07);
  line(0,0,0,size,0,0);
  //length indicator 
  //line(10,0,-20,10,0,20);
  
  //Y - green
  stroke(0,192,0);
  line(0,0,0,0,size,0);
  //Z - blue
  stroke(0,0,192);
  line(0,0,0,0,0,size);
}

void drawAxes(float size, float weight){
  //X  - red
  stroke(192,0,0);
  strokeWeight(weight);
  line(0,0,0,size,0,0);
  //length indicator 
  //line(10,0,-20,10,0,20);
  //Y - green
  stroke(0,192,0);
  line(0,0,0,0,size,0);
  //Z - blue
  stroke(0,0,192);
  line(0,0,0,0,0,size);
}

void nameAxes(float size){
  textSize(20);
  fill(200);
  text("x",size+2,0,0);
  text("y",0,size+2,0);
  text("z",0,0,size+2);
}

// overlay coordinate system

void centerCoordinatesystemOverlay(){
  translate(width/7, height/7,0);
  rotateX(3*PI/10);
  rotateY(PI/20);
  rotateZ(PI/10);
}

//____________________________________________GUI__________________________________________________________________________________________________________________________________________________

int sphere_size = 80;
void drawSphere(){
  strokeWeight(1);
  stroke(255, 70);
  noFill();
  sphere(sphere_size);
  text("N",0,0,83);
  text("x",83,0,0);
  text("y",0,83,0);
}
float getRotation(float rot){
  float currentRot = rot+PI/100;
  return currentRot;
}

void rotateSphere(float rot){
  rotateZ(rot);
}

void drawPointsOnSphere(Complex[]points){
  Vector p = new Vector();
  for (int i=0; i<points.length; i++){
    //get coordinates on sphere
    p = (ComplexToCartesian(points[i]));
    //draw them
    strokeWeight(5);
    stroke((float)projectPoint(findFibrePoint(points[i])).x*105+150,(float)projectPoint(findFibrePoint(points[i])).y*85+150,(float)projectPoint(findFibrePoint(points[i])).z*70+160); //colourscheme 01
    point(80*(float)p.x, 80*(float)p.y, 80*(float)p.z);
  }
}

boolean overSphere(){
  if(mouseX<sphere_size+width/7 && mouseY<sphere_size + height/7){
  return true;
  } else {
  return false;
  }
}

//____________________________SCROLLBARS & BUTTONS__________________________________________________________________________________________________________________________________________________________________
int width_scrollbars = 150;
int height_scrollbars = 15;
int space = 20; //space to left & top of screen
 
float x_scrollbars;
float y_VaryTheta = space;
float y_VaryPhi = space*2+height_scrollbars;
float y_Spiral = height-space-height_scrollbars;

 
void setupScrollbars(){
  x_scrollbars = width-width_scrollbars-space;
  y_VaryTheta = space+height_scrollbars/2;
  y_VaryPhi = y_VaryTheta+2*space+2*height_scrollbars;
  y_Spiral = y_VaryTheta+3*space+3*height_scrollbars;
  
  s_VaryTheta = new HScrollbar(x_scrollbars, y_VaryTheta, width_scrollbars, height_scrollbars, 2);
  s_VaryTheta2 = new HScrollbar(x_scrollbars, y_VaryTheta+space+height_scrollbars, width_scrollbars, height_scrollbars, 2);
  s_VaryPhi = new HScrollbar(x_scrollbars, y_VaryPhi, width_scrollbars, height_scrollbars, 2);
  s_Spiral = new HScrollbar(x_scrollbars, y_Spiral, width_scrollbars, height_scrollbars, 2);
  s_Flow = new HScrollbar(x_scrollbars, height-space/2-space-height_scrollbars, width_scrollbars, height_scrollbars, 2);
  s_noCircles = new HScrollbar(x_scrollbars, height-space/2, width_scrollbars, height_scrollbars, 2);
  s_noCircles.spos = s_noCircles.xpos +30*width_scrollbars/100;
}

void updateScrollbars(){
  s_VaryTheta.update();
  s_VaryTheta2.update();  
  s_VaryPhi.update();
  s_Spiral.update();
  s_Flow.update();
  s_noCircles.update();
}

void displayScrollbars(){
  s_VaryTheta.display();
  s_VaryTheta2.display();
  s_VaryPhi.display();
  s_Spiral.display();
  s_Flow.display();
  s_noCircles.display();
  //add text
  fill(200);
  textSize(2*space/3);
  text("D-Section Flow", x_scrollbars - space*5,  height-space/2-3*space/4-height_scrollbars);
  text("#fibres", x_scrollbars - space*5,  height-space/4);
}

float scrollbarValue(HScrollbar bar, float maxValue){ //converts position of scrollbar to float between 0 & maxValue
return (bar.spos-bar.xpos)*maxValue/(bar.swidth-bar.sheight);
}

void drawButtons(){
  //draw buttons
  fill(70,0,70);
  strokeWeight(2);
  stroke(255);
  rect(x_scrollbars- height_scrollbars-space, y_VaryTheta, height_scrollbars, height_scrollbars); //varyTheta
  rect(x_scrollbars- height_scrollbars-space, y_VaryPhi, height_scrollbars, height_scrollbars); //VaryPhi
  rect(x_scrollbars- height_scrollbars-space, y_Spiral, height_scrollbars, height_scrollbars); //Spiral
   //add text
  fill(200);
  textSize(2*space/3);
  text("Vary Theta", x_scrollbars - space*3, y_VaryTheta);
  text("Vary Phi", x_scrollbars - space*3, y_VaryPhi);
  text("Spiral", x_scrollbars - space*3, y_Spiral);
  
}

boolean overVaryThetaButton()  {
  if (mouseX >= x_scrollbars-height_scrollbars-space && mouseX <= x_scrollbars-space && 
      mouseY >= y_VaryTheta && mouseY <= y_VaryTheta+height_scrollbars) {
    return true;
  } else {
    return false;
  }
}

boolean overVaryPhiButton()  {
  if (mouseX >= x_scrollbars-height_scrollbars-space && mouseX <= x_scrollbars-space && 
      mouseY >= y_VaryPhi && mouseY <= y_VaryPhi+height_scrollbars) {
    return true;
  } else {
    return false;
  }
}

boolean overSpiralButton()  {
  if (mouseX >= x_scrollbars-height_scrollbars-space && mouseX <= x_scrollbars-space && 
      mouseY >= y_Spiral && mouseY <= y_Spiral+height_scrollbars) {
    return true;
  } else {
    return false;
  }
}
