//Here you will find everything about using the SO4 Matrices for rotating the d-section around.

PMatrix3D giveRotationMatrix1(float angle_1){
  PMatrix3D rot_1 = new PMatrix3D(cos(angle_1),-sin(angle_1),0,0, 
                                  sin(angle_1),cos(angle_1),0,0, 
                                  0,0,cos(angle_1),sin(angle_1), 
                                  0,0,-sin(angle_1),cos(angle_1));
  return rot_1;
}

PMatrix3D giveRotationMatrix2(float angle_2){

                                  
  PMatrix3D rot_2 = new PMatrix3D(0,0,-cos(angle_2),-sin(angle_2), 
                                  0,0,sin(angle_2),-cos(angle_2), 
                                  cos(angle_2),-sin(angle_2),0,0 ,
                                  sin(angle_2),cos(angle_2),0,0);
                       
  return rot_2;
}
PMatrix3D giveRotationMatrix3(float angle_3){
  PMatrix3D rot_3 = new PMatrix3D(0,-sin(angle_3),-cos(angle_3),0, 
                                  sin(angle_3),0,0,-cos(angle_3), 
                                  cos(angle_3),0,0,sin(angle_3), 
                                  0,cos(angle_3),-sin(angle_3),0 );
                                  

  return rot_3;
}

CxComplex[][] rotateDSection(CxComplex[][] grid, float angle, int kindOfRotation){
  CxComplex[][] rotGrid = new CxComplex[grid.length][grid[0].length];
  PMatrix3D rot;
  if(kindOfRotation == 1){
    rot = new PMatrix3D(giveRotationMatrix1(angle));
  } else if (kindOfRotation == 2){
    rot = new PMatrix3D(giveRotationMatrix2(angle));
  } else { //(kindOfRotation ==3) or faulty int
    rot = new PMatrix3D(giveRotationMatrix3(angle));
  }
  for(int i=0; i<grid.length; i++){
    for(int j=0; j<grid[0].length; j++){
      rotGrid[i][j] = grid[i][j].applyRotMatrix(rot);
    }
  }
  return rotGrid;
}
