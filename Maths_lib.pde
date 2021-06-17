//___________________________________MATHEMATICAL ALGORITHM FUNCTIONS_______________________________________________________________________________________________________________________________________

void fillArray(){ //gives #noPoints points on the circle in R3, (evenly spaced on the circle in C2)
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
  Complex t = new Complex(2*PI/noPoints);
  Complex z_1_second = p.z_1.mult(Complex.exp(i.mult(t)));
  Complex z_2_second = p.z_2.mult(Complex.exp(i.mult(t)));
  
  CxComplex p_2 = new CxComplex(z_1_second, z_2_second);
  return p_2;
}

Vector goWithFlowAndProject(CxComplex p, float t){
  //generate new point on same Fibre //go fourth of orbit to find next point
  Complex z_1_second = p.z_1.mult(Complex.exp(i.mult(t)));
  Complex z_2_second = p.z_2.mult(Complex.exp(i.mult(t)));
  CxComplex p_2 = new CxComplex(z_1_second, z_2_second);
  Vector v = projectPoint(p_2);
  //println(v.x, v.y, v.z);
  return v;
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
