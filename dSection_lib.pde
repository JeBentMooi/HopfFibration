
int dSectionNoPoints = 20;

void SetupDisplaySettingsDSection(){
  strokeWeight(0.02);
  fill(150,200,150,130);
  stroke(255);
}

//  ------------------------------------------- Southern 1-Section ------------------------------------------- 

void drawSouthernDSectionBoundary(){
  SetupDisplaySettingsDSection();
  pushMatrix();
  rotateX(PI/2);
  rotateZ(PI);
  rect(0,-200,400,400);
  popMatrix();
}

// ------------------------------------------- Grid of D-Section ------------------------------------------- 

CxComplex[][] setupDSectionGrid(CxComplex[][] grid, int noCol, int noRow, CxComplex z){
  CxComplex p = new CxComplex(z.normalize());
  grid = getDSectionGrid(noCol, noRow, p);
  return grid;
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
    }
  }
  return grid; 
}

CxComplex[][] getDSectionGridCircular(float varyR, float varyTheta){ //gives us north pole d-section
  CxComplex[][]circularGrid = new CxComplex[(int)varyR][(int)varyTheta];
  for(int i=0; i<varyR; i++){
    for(int j=0; j<varyTheta; j++){
      Complex Im = new Complex(0,1); //i
      Complex r = new Complex(i/varyR-1);
      Complex Theta = new Complex(j*2*PI/varyTheta-1);
      Complex c_2 = new Complex(Complex.sqrt(Complex.sub(1,Complex.pow(r,2))));
      Complex c_1 = new Complex(r.mult(Complex.exp(Im.mult(Theta))));
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
  //stroke(52,165,218); //blue tone from presentation
  stroke(250);
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

//  ------------------------------------------- 2.2.1 A helicoidal annulus ------------------------------------------- 

//lets set up that V_1 part

CxComplex[][] getV_1part(float varyR, float varyTheta){
  CxComplex[][]V_1_circularGrid = new CxComplex[(int)varyR][(int)varyTheta];
  for(int k=0; k<varyR; k++){
    for(int j=0; j<varyTheta; j++){
      Complex Im = new Complex(0,1); //i
      Complex r = new Complex(k/(varyR-1));
      println("r", k, j, " : ", r.real, r.imag);
      Complex Theta = new Complex(j*2*PI/varyTheta-1);
      Complex c_1 = new Complex(r.mult(sqrt(2)/2));
      Complex c_2 = new Complex(Complex.sqrt(Complex.sub(1,Complex.pow(r,2).mult(0.5))).mult(Complex.exp(Im.mult(Theta))));
      V_1_circularGrid[k][j] = new CxComplex(c_2, c_1);
    }
  }
  return V_1_circularGrid;
}

CxComplex[][] getV_2part(float varyR, float varyTheta){
  CxComplex[][]V_2_circularGrid = new CxComplex[(int)varyR][(int)varyTheta];
  for(int k=0; k<varyR; k++){
    for(int j=0; j<varyTheta; j++){
      Complex Im = new Complex(0,1); //i
      Complex r = new Complex(k*(sqrt(2)/2)/(varyR-1));
      println("r", k, j, " : ", r.real, r.imag);
      Complex Theta = new Complex(j*2*PI/varyTheta-1);
      Complex c_1 = new Complex(Complex.sqrt(Complex.sub(1,Complex.pow(r,2))));
      Complex c_2 = new Complex(r.mult(Complex.exp(Im.mult(Theta))));
      V_2_circularGrid[k][j] = new CxComplex(c_2, c_1);
    }
  }
  return V_2_circularGrid;
}

//  ------------------------------------------- 2.2.2 An annular 2-section ------------------------------------------- 

CxComplex[][] getV_1part_2Section(float varyR, float varyTheta){
  CxComplex[][]V_1_circularGrid = new CxComplex[(int)varyR][(int)varyTheta];
  for(int k=0; k<varyR; k++){
    for(int j=0; j<varyTheta; j++){
      Complex Im = new Complex(0,1); //i
      Complex MinIm = new Complex(0,-1);
      Complex r = new Complex(k/(varyR-1));
      println("r", k, j, " : ", r.real, r.imag);
      Complex Theta = new Complex(j*2*PI/varyTheta-1);
      Complex c_1 = new Complex(r.mult(sqrt(2)/2).mult(Complex.exp(MinIm.mult(Theta))));
      Complex c_2 = new Complex(Complex.sqrt(Complex.sub(1,Complex.pow(r,2).mult(0.5))).mult(Complex.exp(Im.mult(Theta))));
      V_1_circularGrid[k][j] = new CxComplex(c_1, c_2);
    }
  }
  return V_1_circularGrid;
}

CxComplex[][] getV_2part_2Section(float varyR, float varyTheta){
  CxComplex[][]V_2_circularGrid = new CxComplex[(int)varyR][(int)varyTheta];
  for(int k=0; k<varyR; k++){
    for(int j=0; j<varyTheta; j++){
      Complex Im = new Complex(0,1); //i
      Complex MinIm = new Complex(0,-1);
      Complex r = new Complex(k*(sqrt(2)/2)/(varyR-1));
      println("r", k, j, " : ", r.real, r.imag);
      Complex Theta = new Complex(j*2*PI/varyTheta-1);
      Complex c_1 = new Complex(Complex.sqrt(Complex.sub(1,Complex.pow(r,2))).mult(Complex.exp(MinIm.mult(Theta))));
      Complex c_2 = new Complex(r.mult(Complex.exp(Im.mult(Theta))));
      V_2_circularGrid[k][j] = new CxComplex(c_1, c_2);
    }
  }
  return V_2_circularGrid;
}

// for the last 2 sections we need this function to visualize the grids:

void displayGrids(CxComplex[][] V_1, CxComplex[][] V_2){
  displayGrid(V_2, true, 0, 150, 120);
  displayGrid(V_1, true, 205, 200, 0);
}

void displayGridsColoured(CxComplex[][] V_1, CxComplex[][] V_2){
  displayGrid(V_2, true, 0, 150, 170);
  displayGrid(V_1, true, 240, 160, 5);
}

// ------------------------------------------- Tubes ------------------------------------------- 

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

void drawTubeCoord(PVector[][]tubeCoord, float NumCoord){ //NumCoord tells us how many coordinates we should draw
  float radius = 0.01; //radius of cross section
    for (int j=0; j<tubeCoord.length; j++){
      PVector[] coordinates;
       if(NumCoord >3){
        coordinates = new PVector[(int)NumCoord+1];
          for(int i=0; i<(int)NumCoord+1; i++){
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

// -------------------------------------------    ------------------------------------------- 
