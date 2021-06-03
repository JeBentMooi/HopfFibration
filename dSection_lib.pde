//-------get random disc-like d section----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

int dSectionNoPoints = 20;


void setupDSection(int dSectionNoPoints, CxComplex z){
  boundaryPoints = getBoundaryPoints(dSectionNoPoints, z);
}


Vector[] getBoundaryPoints(int amount, CxComplex z){ //gives array of points on the boundary circle of the d section, z is one point on fibre in S^3
  CxComplex[]C2_Points = new CxComplex[amount];
  C2_Points[0] = z;
  for (int i=1; i<amount; i++){
    C2_Points[i]=getNewPoint(C2_Points[i-1], amount);
  }
  Vector[]boundaryPoints = new Vector[amount];
  for (int j=0; j<amount; j++){
    boundaryPoints[j]=projectPoint(C2_Points[j]);
  }
  return boundaryPoints;
}  


void drawBoundary(Vector[] bdryPoints){
  SetupDisplaySettingsDSection();
  curveTightness(0.5);
   
   beginShape();
     for(int i=0; i<bdryPoints.length; i++){
      if(i>0 && distance(bdryPoints[i],bdryPoints[i-1])>500){//distance too big - end shape and start new shape for rest of circle.
      endShape();
      beginShape();
      } else {
      curveVertex((float)bdryPoints[i].x,(float)bdryPoints[i].y,(float)bdryPoints[i].z); 
      }
    }
    curveVertex((float)bdryPoints[0].x,(float)bdryPoints[0].y,(float)bdryPoints[0].z); //1
    curveVertex((float)bdryPoints[1].x,(float)bdryPoints[1].y,(float)bdryPoints[1].z); //2 
    curveVertex((float)bdryPoints[2].x,(float)bdryPoints[2].y,(float)bdryPoints[2].z); //3 - need those three for anchor point in beginning and end
    endShape();
}

void SetupDisplaySettingsDSection(){
  strokeWeight(0.05);
  fill(150,150,250,30);
  stroke(255);
}
