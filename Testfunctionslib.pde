void drawDotsAtGrid(CxComplex[][] grid){
  for(int i=0; i<grid.length; i++){
    for(int j=0; j<grid[0].length; j++){
      strokeWeight(0.2);
      stroke(0,255,0);
      fill(0,255,0);
      if(i==3 & j==3){ //make specific one blue
      stroke(0,0,255);
      }
      point((float)projectPoint(grid[i][j]).x, (float)projectPoint(grid[i][j]).y, (float)projectPoint(grid[i][j]).z);
    }
  }
}


void TubeTest(){
  CxComplex p = new CxComplex(0.09507359811416827, 0.13630633796277544, 0.05677098317229444, 0.08496381245272511);
  //CxComplex p = new CxComplex(70,100,0,230);
  //p = p.normalize();
  int iterations = 30;
  PVector[]points = new PVector[iterations];
  //i=0:
  points[0]= new PVector((float)projectPoint(p).x,(float) projectPoint(p).y, (float)projectPoint(p).z);
  for(int i=1;i<iterations;i++){
    p = getNewPoint(p);
    points[i]= new PVector((float)projectPoint(p).x,(float) projectPoint(p).y, (float)projectPoint(p).z);
  }
  
  BSpline3D path = new BSpline3D(points,20,S3D.ORTHO_Z);
  Oval oval = new Oval(0.1,10);
  Tube tube = new Tube(path,oval);
  tube.drawMode(S3D.SOLID);
  tube.fill(color(150,150,255));
  tube.draw(getGraphics());
}


Complex getPointInDSection(){
  Complex a = new Complex(0.09507359811416827, 0.13630633796277544);
  Complex b = new Complex(0.05677098317229444, 0.08496381245272511);
  a = a.div(b);
  //println(a.real, a.imag);
  return a;
}
