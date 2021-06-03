//-------get random disc-like d section----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

int dSectionNoPoints = 20;

void setupDSectionBoundary(int dSectionNoPoints, CxComplex z){
  z = z.normalize();
  boundaryPoints = getBoundaryPoints(dSectionNoPoints, z);
}

void setupDSectionGrid(int noCol, int noRow, CxComplex z){
  z = z.normalize();
  CxComplex p = new CxComplex(z);
  grid = getDSectionGrid(noCol, noRow, p);
  FlowingGrid = letGridFlow(grid, PI/2);
}


Vector[] getBoundaryPoints(int amount, CxComplex z){ //gives array of points on the boundary circle of the d section, z is one point on fibre in S^3
  CxComplex[]C2_Points = new CxComplex[amount];
  C2_Points[0] = z.normalize();
  for (int i=1; i<amount; i++){
    C2_Points[i]=getNewPoint(C2_Points[i-1], amount);
  }
  Vector[]boundaryPoints = new Vector[amount];
  for (int j=0; j<amount; j++){
    boundaryPoints[j]=projectPoint(C2_Points[j]);
  }
  return boundaryPoints;
}  


void drawDSectionBoundary(Vector[] bdryPoints){
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

void drawSouthernDSectionBoundary(){
  SetupDisplaySettingsDSection();
  pushMatrix();
  rotateX(PI/2);
  rotateZ(PI);
  rect(0,-200,400,400);
  popMatrix();
}

void SetupDisplaySettingsDSection(){
  strokeWeight(0.02);
  fill(150,200,150,130);
  stroke(255);
}

CxComplex[][] getDSectionGrid(int noColumns, int noRows, CxComplex p){
  CxComplex[][] grid= new CxComplex[noColumns][noRows];
  //fill the first & last row of the grid, [0][0]=p and [0][noRows-1]=p_opposite
  for(int i=0; i<noColumns; i++){
   grid[i][0] = p.goWithFlow(3*PI*i/(4*noColumns));
   grid[noColumns-1-i][noRows-1] = p.goWithFlow(PI + 3*PI*i/(4*noColumns));
  }
  //fill the middle column for column
  for(int i = 0; i < noColumns; i++){
    for(double j = 1; j < noRows-1; j++){
      double rows = noRows;
      double multi = j/rows;
      CxComplex diff = new CxComplex(subtract(grid[i][noRows-1],grid[i][0]));
      grid[i][(int)j] = add(grid[i][0],mult(multi, diff));
    }
  }
  return grid; 
}

CxComplex[][] letGridFlow(CxComplex[][] grid, float t){
  for(int i = 0; i < grid.length; i++){
    for(int j = 0; j < grid[0].length; j++){
    grid[i][j] = grid[i][j].goWithFlow(t);
    }
  }
  return grid;
}

void displayGrid(CxComplex[][] grid){
  strokeWeight(0.02);
  noFill();
  stroke(255);
  //make lines connecting each column
  for(int i = 0; i < grid[0].length; i++){ //go through rows
    for(int j = 1; j < grid.length; j++){ //go through cols
     Vector x = new Vector(projectPoint(grid[j-1][i]));
     Vector y = new Vector(projectPoint(grid[j][i]));
     line((float)x.x,(float)x.y,(float)x.z,(float)y.x,(float)y.y,(float)y.z);
    }
  }
  //draw rest of boundary ---------------------------------------------------------------DOES NOT WORK YET!!!------------------------------------------------------------------------
  beginShape(); //"right" side of circle
  stroke(0,200,0);
  CxComplex startHere = grid[0][grid[0].length-1].goWithFlow(-PI/(4*grid[0].length));
  for(int i=0; i<grid[0].length+1; i++){
    vertex((float)projectPoint(startHere.goWithFlow(i*PI/(4*grid[0].length))).x, (float)projectPoint(startHere.goWithFlow(PI/(i*4*grid[0].length))).y, (float)projectPoint(startHere.goWithFlow(i*PI/(4*grid[0].length))).z);
  }
  endShape();
  beginShape(); //"left" side of circle
  startHere = grid[0][grid[0].length-1].goWithFlow(PI);
  for(int i=0; i<grid[0].length; i++){
   vertex((float)projectPoint(startHere.goWithFlow(i*PI/(4*grid[0].length))).x, (float)projectPoint(startHere.goWithFlow(PI/(i*4*grid[0].length))).y, (float)projectPoint(startHere.goWithFlow(i*PI/(4*grid[0].length))).z);
  }
  endShape();
  stroke(255);
  //make lines connecting each row
  for(int i = 0; i < grid.length; i++){ //go through cols
    for(int j = 1; j < grid[0].length; j++){ //go through rows
     Vector x = new Vector(projectPoint(grid[i][j-1]));
     Vector y = new Vector(projectPoint(grid[i][j]));
     line((float)x.x,(float)x.y,(float)x.z,(float)y.x,(float)y.y,(float)y.z);
    }
  }
}
