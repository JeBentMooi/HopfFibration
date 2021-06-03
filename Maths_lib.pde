//____________________________________________SETUP COORDINATE SYSTEM FUNCTIONS__________________________________________________________________________________________________________________________________________________

void centerCoordinatesystem(){
  translate(width/2-50, height/2+50, -100);
  scale(50);
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

//___________________________________MATHEMATICAL ALGORITHM FUNCTIONS_______________________________________________________________________________________________________________________________________

void fillArray(){ //gives #noPoints points on the circle in R3, (evenly spaced on the circle in C2)
  //CxComplex p_i = new CxComplex(findFibrePoint(complex)); //create copy of p to change throughout the loop
  CxComplex[] PointsInC2 = new CxComplex[noCircles]; //array of points in C2
  for(int i=0; i<noCircles; i++){
    PointsInC2[i] = findFibrePoint(startingPoints[i]); //fill that array up:
  }
  for (int j=0; j<noCircles; j++){ 
    circlePoints[j][0]= projectPoint(PointsInC2[j]); //put starting points' projections in first entry
    for(int i=1; i< noPoints; i++){
      circlePoints[j][i] = projectPoint(getNewPoint(PointsInC2[j]));
      PointsInC2[j] = getNewPoint(PointsInC2[j]);
    }
  }
}
CxComplex findFibrePoint(Complex p){ //put in complex number p and get one point on circle in S^3
//  (x_1,y_2,x_2,y_2) is coordinate in C^2
//  trick: set y_2 =0.
float x_1;
float x_2;
float y_1;
x_2 = sqrt(1/(1+ pow((float)p.real,2)+ pow((float)p.imag,2)));
x_1 = (float)p.real*x_2;
y_1 = (float)p.imag*x_2;
CxComplex p_Fibre = new CxComplex(x_1,y_1,x_2,0);
return p_Fibre;
}

CxComplex getNewPoint (CxComplex p){ //generate new point on same Fibre
  //go fourth of orbit to find next point
  Complex t= new Complex(2*PI/noPoints);
  Complex z_1_second = p.z_1.mult(Complex.exp(i.mult(t)));
  Complex z_2_second = p.z_2.mult(Complex.exp(i.mult(t)));
  
  CxComplex p_2 = new CxComplex(z_1_second, z_2_second);
  return p_2;
}

CxComplex getNewPoint (CxComplex p, int noPoints){ //generate new point on same Fibre
  //go fourth of orbit to find next point
  Complex t= new Complex(2*PI/noPoints);
  Complex z_1_second = p.z_1.mult(Complex.exp(i.mult(t)));
  Complex z_2_second = p.z_2.mult(Complex.exp(i.mult(t)));
  
  CxComplex p_2 = new CxComplex(z_1_second, z_2_second);
  return p_2;
}

Vector projectPoint(CxComplex p){//put in point in 4D get it projected into R^3 via stereographic projection with N=(0,0,0,1)
                                 //for projecting p, p', M
Vector p_projected = new Vector(p.z_1.real/(1-p.z_2.imag),p.z_1.imag/(1-p.z_2.imag),p.z_2.real/(1-p.z_2.imag));
return p_projected;
}

Complex SphericalToComplex(float theta, float phi){ //converts spherical coordinates to cartesian and projects them down
                                                    //theta is angle from x-axis in x/y plane, phi is from z-axis in z/y plane
  //convert from spherical to cartesian
  double x = sin(phi)*cos(theta);
  double y = sin(phi)*sin(theta);
  double z =cos(phi);
  //stereographicProjection
  double Re = x/(1-z);
  double Im = y/(1-z);
  return new Complex(Re, Im);
}

Vector ComplexToCartesian(Complex cplx){ //converts complex number into cartesian coordinate on the riemann sphere
  //stereographic projection
  float x=2*(float)cplx.real /(1+pow((float)cplx.real,2)+pow((float)cplx.imag,2));
  float y=2*(float)cplx.imag /(1+pow((float)cplx.real,2)+pow((float)cplx.imag,2));
  double z=(-1+pow((float)cplx.real,2)+pow((float)cplx.imag,2))/(1+pow((float)cplx.real,2)+pow((float)cplx.imag,2));
  return new Vector(x,y,z);
}

float distance(Vector vector_1, Vector vector_2){
  return (float)(Vector.sub(vector_1,vector_2)).mag();
}


//_______________________________________________STARTING POINT FUNCTIONS_______________________________________________________________________________________________________________________________________________

void addPointsVaryTheta(int amount, float phi){ //look how theta changes fibres, constant phi
  for(int j=0; j<amount; j++){
    startingPoints[j]=SphericalToComplex(j*2*PI/amount, phi);
  }
}

void addPointsVaryTheta(int array_entry, int amount, float phi){ //gives #amount equidistant points on horizontal circle on S2, phi gives "height" in circle.
                                                      //starts in array_entry-th entry of the array
  for(int j=0; j<amount; j++){
    startingPoints[array_entry+j]=SphericalToComplex(j*2*PI/amount, phi);
  }
}

void addPointsVaryThetaAndPhi(int amount, float alpha){ //gives "vertical" circle
  for(int j=0; j<amount; j++){
    startingPoints[j]=SphericalToComplex(alpha*sin(j*PI/amount), alpha*cos(j*PI/amount));
  }
}

void addFewPointsVaryTheta(int amountHeights, float[] phi){//makes equidistant points on #amountHeights different Heights
  for(int j=0;j<amountHeights; j++){
  addPointsVaryTheta((noCircles/amountHeights)*j, noCircles/amountHeights, phi[j]);
  }
}

void addPointsVaryPhi(int amount, float theta){ //look how phi changes fibres, constant theta
  for(int j=0; j<amount; j++){
    startingPoints[j]=SphericalToComplex(theta, j*(2*PI/amount));
  }
}

void addPointsVaryPhi(int array_entry, int amount, float theta){ //look how phi changes fibres, constant theta
  for(int j=0; j<amount; j++){
    startingPoints[array_entry+j]=SphericalToComplex(theta, j*(2*PI/amount));
  }
}

void addFewPointsVaryPhi(int amountHeights, float[] theta){
  for(int j=0;j<amountHeights; j++){
  addPointsVaryPhi((noCircles/amountHeights)*j, noCircles/amountHeights, theta[j]);
  }
}

void addPointsSpiral(int amount){ //gives #amount points in a spiral around the sphere
  for(int j=0; j<amount; j++){
    startingPoints[j]=SphericalToComplex(j*(2*PI/amount)+scrollbarValue(s_Spiral, 2*PI), j*(PI/amount));
  }
}
//_______________________________________________GRAPHICS FUNCTIONS_______________________________________________________________________________________________________________________________________________


void drawColCircle(){ //draw coloured circle
  strokeWeight(0.05);
  noFill();
  curveTightness(0.5);
  for(int j=0; j<noCircles; j++){
    beginShape();
    stroke((float)circlePoints[j][0].x*105+150,(float)circlePoints[j][0].y*85+150,(float)circlePoints[j][0].z*70+160); //colorscheme 01
    for(int i=0; i<noPoints-1; i++){
      if(i>0 && distance(circlePoints[j][i],circlePoints[j][i-1])>noPoints/2+10){//distance too big - end shape and start new shape for rest of circle.
      endShape();
      beginShape();
      } else {
      curveVertex((float)circlePoints[j][i].x,(float)circlePoints[j][i].y,(float)circlePoints[j][i].z); 
      }
    }
    curveVertex((float)circlePoints[j][0].x,(float)circlePoints[j][0].y,(float)circlePoints[j][0].z); //1
    curveVertex((float)circlePoints[j][1].x,(float)circlePoints[j][1].y,(float)circlePoints[j][1].z); //2 
    curveVertex((float)circlePoints[j][2].x,(float)circlePoints[j][2].y,(float)circlePoints[j][2].z); //3 - need those three for anchor point in beginning and end
    endShape();
  }
}
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
 
float x_scrollbars; // - height_scrollbars-space;
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
  s_noCircles = new HScrollbar(x_scrollbars, height-space/2, width_scrollbars, height_scrollbars, 2);
  s_noCircles.spos = s_noCircles.xpos +30*width_scrollbars/100;
}

void updateScrollbars(){
  s_VaryTheta.update();
  s_VaryTheta2.update();  
  s_VaryPhi.update();
  s_Spiral.update();
  s_noCircles.update();
}

void displayScrollbars(){
  s_VaryTheta.display();
  s_VaryTheta2.display();
  s_VaryPhi.display();
  s_Spiral.display();
  s_noCircles.display();
}

float scrollbarValue(HScrollbar bar, float maxValue){ //converts position of scrollbar to float between 0 & maxValue
return (bar.spos-bar.xpos)*maxValue/(bar.swidth-bar.sheight);
}

void drawButtons(){
  //draw buttons
  fill(70,0,70);
  strokeWeight(2);
  stroke(255);
  rect(x_scrollbars- height_scrollbars-space, y_VaryTheta, height_scrollbars, height_scrollbars);
  rect(x_scrollbars- height_scrollbars-space, y_VaryPhi, height_scrollbars, height_scrollbars);
  rect(x_scrollbars- height_scrollbars-space, y_Spiral, height_scrollbars, height_scrollbars);
  //add text
  fill(255);
  textSize(space/2);
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

//____________________________TEST ALGORITHM__________________________________________________________________________________________________________________________________________________________________

void testAlgorithm(Complex p){
//TESTRUN OF ALGORITHM WITH SOUTH POLE:
//BUT: WITH OLD IDEA OF PROJECTING THE MIDDLE AND TWO POINTS ON THE Fibre
  Complex s = p;
  println("s", s);
  CxComplex s_4D = new CxComplex(findFibrePoint(s));
  println("point in Fibre of s", s_4D.z_1, s_4D.z_2 );
  CxComplex M_4D = new CxComplex(getMiddle(s_4D));
  println("middle point of fibre", M_4D.z_1, M_4D.z_2);
  CxComplex t_4D = new CxComplex(getNewPoint(s_4D));
  println("second point on fibre",t_4D.z_1, t_4D.z_2);
  Vector s_3D = new Vector(projectPoint(s_4D));
  Vector M_3D = new Vector(projectPoint(M_4D));
  Vector t_3D = new Vector(projectPoint(t_4D));
  println("projected s", s_3D, "projected M", M_3D, "projected t", t_3D);
  println("length of s",s_3D.mag(),"length of t",t_3D.mag());
}

void testPointsOnSphere(){
  //point();
}

//____________________________PROBABLY TRASH__________________________________________________________________________________________________________________________________________________________________

CxComplex getMiddle(CxComplex p){ //put in point in S^3 and get middle of fibre-circle
  //do half of a orbit to find opposite point
  Complex t= new Complex(PI);
  Complex z_1_opposite = p.z_1.mult(Complex.exp(i.mult(t)));
  Complex z_2_opposite = p.z_2.mult(Complex.exp(i.mult(t)));
  println(z_1_opposite, z_2_opposite);
  //find M
  Complex m_1 = p.z_1.add(Complex.div((z_1_opposite.sub(p.z_1)),2));
  Complex m_2 = p.z_2.add(Complex.div((z_2_opposite.sub(p.z_2)),2));
  CxComplex M = new CxComplex(m_1,m_2);
  
  return M;
}
