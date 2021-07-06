//Here you will find everything about using the SO4 Matrices for rotating the d-section around.

PMatrix3D giveRotationMatrix(float angle_1, float angle_2, float angle_3, float angle_4){ //rotates first around angle 1,then 2, then 3
  PMatrix3D rot_1 = new PMatrix3D(cos(angle_1),-sin(angle_1),0,0, 
                                  sin(angle_1),cos(angle_1),0,0, 
                                  0,0,cos(angle_1),sin(angle_1), 
                                  0,0,-sin(angle_1),cos(angle_1));
                                  
  PMatrix3D rot_2 = new PMatrix3D(0,0,-cos(angle_2),-sin(angle_2), 
                                  0,0,sin(angle_2),-cos(angle_2), 
                                  cos(angle_2),-sin(angle_2),0,0 ,
                                  sin(angle_2),cos(angle_2),0,0);
                                  
  PMatrix3D rot_3 = new PMatrix3D(0,-sin(angle_3),-cos(angle_3),0, 
                                  sin(angle_3),0,0,-cos(angle_3), 
                                  cos(angle_3),0,0,sin(angle_3), 
                                  0,cos(angle_3),-sin(angle_3),0 );
                                  
  PMatrix3D rot_4 = new PMatrix3D(cos(angle_4),0,0,-sin(angle_4), 
                                  0,cos(angle_4),sin(angle_4),0, 
                                  0,-sin(angle_4),cos(angle_4),0, 
                                  sin(angle_4),0,0,cos(angle_4));
  rot_1.apply(rot_2); //rot_1 * rot_2
  rot_1.apply(rot_3); //(rot_1 * rot_2) * rot_3
  rot_1.apply(rot_4); //((rot_1 * rot_2) * rot_3) * rot_4
  return rot_1;
}

CxComplex[][] rotateDSection(CxComplex[][] grid, float angle_1, float angle_2, float angle_3, float angle_4){
  CxComplex[][] rotGrid = new CxComplex[grid.length][grid[0].length];
  PMatrix3D rot = new PMatrix3D(giveRotationMatrix(angle_1, angle_2, angle_3, angle_4));
  for(int i=0; i<grid.length; i++){
    for(int j=0; j<grid[0].length; j++){
      rotGrid[i][j] = grid[i][j].applyRotMatrix(rot);
    }
  }
  return rotGrid;
}
