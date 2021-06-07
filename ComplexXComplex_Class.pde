class CxComplex { //Complex x Complex -> 4D!

 Complex z_1;
 Complex z_2;
 
 //CONSTRUCTOR
 
   CxComplex(){
   this.z_1 = new Complex();
   this.z_1 = new Complex();
   }
   
   
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
 double y_1(){
 return this.z_1.imag;
 }
 double x_2(){
 return this.z_2.real;
 }
 double y_2(){
 return this.z_2.imag;
 }
 
 CxComplex normalize(){
 float len = sqrt(pow((float)this.x_1(),2)+pow((float)this.y_1(),2)+pow((float)this.x_2(),2)+pow((float)this.y_2(),2));
 float x_1 = (float)this.x_1() / len;
 float y_1 = (float)this.y_1() / len;
 float x_2 = (float)this.x_2() / len;
 float y_2= (float)this.y_2() / len;
 return new CxComplex(x_1,y_1,x_2,y_2);
 }
 
 CxComplex goWithFlow(float t){ //goes with the Hopf flow, baby
   Complex new_z_1 = this.z_1.mult(Complex.exp(i.mult(t)));
   Complex new_z_2 = this.z_2.mult(Complex.exp(i.mult(t)));
   return new CxComplex(new_z_1,new_z_2);
 }
}
// -----------------------------------------------

 CxComplex subtract(CxComplex x, CxComplex y){
   Complex a = x.z_1.sub(y.z_1);
   Complex b = x.z_2.sub(y.z_2);
    return new CxComplex(a,b);
  }
  
 CxComplex mult(double scalar, CxComplex z){
   Complex a = z.z_1;
   Complex b = z.z_2;
   a = new Complex(a.real*scalar, a.imag*scalar);
   b = new Complex(b.real*scalar, b.imag*scalar);
 return new CxComplex(a,b);
 }
 
 CxComplex add(CxComplex x, CxComplex y){
   Complex a = x.z_1;
   Complex b = x.z_2;
   Complex c = y.z_1;
   Complex d = y.z_2;
   
   a = a.add(c);
   b = b.add(d);
   return new CxComplex(a,b);
 }

 
 
