class CxComplex { //Complex x Complex -> 4D!

 Complex z_1;
 Complex z_2;
 
 //CONSTRUCTOR
 
   CxComplex(CxComplex z){
     this.z_1 = z.z_1;
     this.z_2 = z.z_2;
   }
   
   CxComplex(Complex x, Complex y) {
    this.z_1 = x;
    this.z_2 = y;
   }
 
   CxComplex(double x_1, double y_1, double x_2, double y_2) {
    this.z_1 = new Complex(x_1, y_1);
    this.z_2 = new Complex(x_2, y_2);
   }
 
 //FUNCTIONS
 double x_1(){
 return this.z_1.real;
 }
 
}
