//-------get any disc-like d section----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

int dSectionNoPoints = 20;

void setupDSectionBoundary(int dSectionNoPoints, CxComplex z){
  z = z.normalize();
  boundaryPoints = getBoundaryPoints(dSectionNoPoints, z);
}

void setupDSectionGrid(int noCol, int noRow, CxComplex z){
  CxComplex p = new CxComplex(z.normalize());
  grid = getDSectionGrid(noCol, noRow, p);
}


PVector[][] setupTubes(CxComplex[][] grid, float t){// t is the time that it will flow in the Hopf flow
  int noTotalCoord = 50; //noCoord is how many coordinates will be passed into the curve
  //------------------------
  //get an array of vectors out of that array of points from that grid
  PVector[][] tubeVectors =new PVector[grid.length * grid[0].length][noTotalCoord];
  for(int i=0; i<grid.length; i++){//go through cols of grid
    for(int j=0; j<grid[0].length; j++){//go through rows of grid
      for(int k=0; k<noTotalCoord; k++){ //go through coordinates
      tubeVectors[i*grid[0].length +j][k] = new PVector((float)goWithFlowAndProject(grid[i][j], k*t/noTotalCoord).x, (float)goWithFlowAndProject(grid[i][j],k*t/noTotalCoord).y, (float)goWithFlowAndProject(grid[i][j],k*t/noTotalCoord).z);
      }
    }
  }
  return tubeVectors;
}

PVector[][] setupTubes(CxComplex[][] grid, float t, int noTotalCoord){// t is the time that it will flow in the Hopf flow
  //get an array of vectors out of that array of points from that grid
  PVector[][] tubeVectors =new PVector[grid.length * grid[0].length][noTotalCoord];
  for(int i=0; i<grid.length; i++){//go through cols of grid
    for(int j=0; j<grid[0].length; j++){//go through rows of grid
      for(int k=0; k<noTotalCoord; k++){ //go through coordinates
      tubeVectors[i*grid[0].length +j][k] = new PVector((float)goWithFlowAndProject(grid[i][j], k*t/noTotalCoord).x, (float)goWithFlowAndProject(grid[i][j],k*t/noTotalCoord).y, (float)goWithFlowAndProject(grid[i][j],k*t/noTotalCoord).z);
      }
    }
  }
  return tubeVectors;
}

void drawTube(PVector[][]tubeCoord, float NumCoord){ //NumCoord tells us how many coordinates we should draw
  float radius = 0.01; //radius of cross section
    for (int j=0; j<tubeCoord.length; j++){
      PVector[] coordinates;
       if(NumCoord >3){
        coordinates = new PVector[(int)NumCoord];
          for(int i=0; i<(int)NumCoord; i++){
            coordinates[i]=tubeCoord[j][i];
          }
        BSpline3D path = new BSpline3D(coordinates,20); //create path for these coordinates
        Oval oval = new Oval(radius, 10); //create cross section
        Tube tube = new Tube(path,oval); //create tube
        tube.drawMode(S3D.SOLID);
        tube.fill(color(150,150,255));
        tube.draw(getGraphics());
       }
    }
}

void drawTubes(Tube[][] tubes){ //draws all tubes completely
  for(int i=0; i<tubes.length; i++){//go through cols
    for(int j=0; j<tubes[0].length; j++){//go through rows
      tubes[i][j].drawMode(S3D.SOLID);
      tubes[i][j].fill(color(150,150,255));
      tubes[i][j].draw(getGraphics());
    }
  }
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
  //fill the first & last column of the grid
  CxComplex startHereFirst = grid[0][0].goWithFlow(7*PI/4); //start at p_tilde
  CxComplex startHereLast = grid[0][0].goWithFlow(3*PI/4); //start at p_opposite
  for(int i=0; i<noRows-1; i++){
   grid[0][noRows-1-i] = startHereFirst.goWithFlow(i*PI/(4*noRows)); //first col
   grid[noRows-1][i]= startHereLast.goWithFlow(i*PI/(4*noRows)); //last col
  }
  //fill the middle column for column
  for(int i = 1; i < noColumns-1; i++){ //go through cols
    for(double j = 1; j < noRows-1; j++){ //go through rows
      double rows = noRows;
      double multi = j/rows;
      CxComplex diff = new CxComplex(subtract(grid[i][noRows-1],grid[i][0]));
      diff = add(grid[i][0],mult(multi, diff));
      grid[i][(int)j] = diff.normalize2ndCoordinate();
      //println("Diff values:", i, j, "  ", diff.z_1.real, diff.z_1.imag, diff.z_2.real, diff.z_2.imag);
    }
  }
  //print grid
  //for (int i = 0; i< noColumns; i++){
  //  for(int j=0; j<noRows; j++){
  //      println(i,j,": ", grid[i][j].z_1.real, grid[i][j].z_1.imag, grid[i][j].z_2.real, grid[i][j].z_2.imag);
  //   }
  //}
  return grid; 
}

CxComplex[][] getDSectionGridCircular(float varyR, float varyTheta){
  CxComplex[][]circularGrid = new CxComplex[(int)varyR][(int)varyTheta];
  for(int i=0; i<varyR; i++){
    for(int j=0; j<varyTheta; j++){
      Complex Im = new Complex(0,1); //i
      Complex r = new Complex(i/varyR-1);
      Complex Theta = new Complex(j*2*PI/varyTheta-1);
      Complex c_2 = new Complex(Complex.sqrt(Complex.sub(1,Complex.pow(r,2))));
      Complex c_1 = new Complex(r.mult(Complex.exp(Im.mult(Theta))));
      //println(i, j, "c_1", c_1.real, c_1.imag, "c_2", c_2.real, c_2.imag);
      circularGrid[i][j] = new CxComplex(c_1, c_2);
    }
  }
  return circularGrid;
}


CxComplex[][] letGridFlow(CxComplex[][] grid, float t){
  CxComplex[][] newGrid = new CxComplex[grid.length][grid[0].length];
  for(int i = 0; i < grid.length; i++){
    for(int j = 0; j < grid[0].length; j++){
    newGrid[i][j] = grid[i][j].goWithFlow(t);
    }
  }
  return newGrid;
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
  //make lines connecting each row
  for(int i = 0; i < grid.length; i++){ //go through cols
    for(int j = 1; j < grid[0].length; j++){ //go through rows
     Vector x = new Vector(projectPoint(grid[i][j-1]));
     Vector y = new Vector(projectPoint(grid[i][j]));
     line((float)x.x,(float)x.y,(float)x.z,(float)y.x,(float)y.y,(float)y.z);
    }
  }
}

void displayGrid(CxComplex[][] grid, boolean circular){
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
  //make lines connecting each row
  for(int i = 0; i < grid.length; i++){ //go through cols
    for(int j = 1; j < grid[0].length; j++){ //go through rows
     Vector x = new Vector(projectPoint(grid[i][j-1]));
     Vector y = new Vector(projectPoint(grid[i][j]));
     line((float)x.x,(float)x.y,(float)x.z,(float)y.x,(float)y.y,(float)y.z);
    }
  }
  if (circular == true){ //if circular grid, then connect first and last column
    for(int i= 0; i<grid.length; i++){
      Vector x = new Vector(projectPoint(grid[i][0]));
      Vector y = new Vector(projectPoint(grid[i][grid[0].length-1]));
      line((float)x.x,(float)x.y,(float)x.z,(float)y.x,(float)y.y,(float)y.z);
    }
  }
}

void displayGrid(CxComplex[][] grid, int r, int g, int b){
  strokeWeight(0.02);
  noFill();
  stroke(r, g, b);
  //make lines connecting each column
  for(int i = 0; i < grid[0].length; i++){ //go through rows
    for(int j = 1; j < grid.length; j++){ //go through cols
     Vector x = new Vector(projectPoint(grid[j-1][i]));
     Vector y = new Vector(projectPoint(grid[j][i]));
     line((float)x.x,(float)x.y,(float)x.z,(float)y.x,(float)y.y,(float)y.z);
    }
  }
  //make lines connecting each row
  for(int i = 0; i < grid.length; i++){ //go through cols
    for(int j = 1; j < grid[0].length; j++){ //go through rows
     Vector x = new Vector(projectPoint(grid[i][j-1]));
     Vector y = new Vector(projectPoint(grid[i][j]));
     line((float)x.x,(float)x.y,(float)x.z,(float)y.x,(float)y.y,(float)y.z);
    }
  }
}

void displayGrid(CxComplex[][] grid, boolean circular, int r, int g, int b){
  strokeWeight(0.02);
  noFill();
  stroke(r, g, b);
  //make lines connecting each column
  for(int i = 0; i < grid[0].length; i++){ //go through rows
    for(int j = 1; j < grid.length; j++){ //go through cols
     Vector x = new Vector(projectPoint(grid[j-1][i]));
     Vector y = new Vector(projectPoint(grid[j][i]));
     line((float)x.x,(float)x.y,(float)x.z,(float)y.x,(float)y.y,(float)y.z);
    }
 }
  //make lines connecting each row
  for(int i = 0; i < grid.length; i++){ //go through cols
    for(int j = 1; j < grid[0].length; j++){ //go through rows
     Vector x = new Vector(projectPoint(grid[i][j-1]));
     Vector y = new Vector(projectPoint(grid[i][j]));
     line((float)x.x,(float)x.y,(float)x.z,(float)y.x,(float)y.y,(float)y.z);
    }
  }
  
  if (circular == true){ //if circular grid, then connect first and last column
    for(int i= 0; i<grid.length; i++){
      Vector x = new Vector(projectPoint(grid[i][0]));
      Vector y = new Vector(projectPoint(grid[i][grid[0].length-1]));
      line((float)x.x,(float)x.y,(float)x.z,(float)y.x,(float)y.y,(float)y.z);
    }
  }
}
