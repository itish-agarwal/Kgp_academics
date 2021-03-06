//Test file 1
//Let us test declarations first of all;

//global declarations
int A, B, C = 10;
float X, Y = 4.565;
char ch = 'R';

int gcd(int a, int b) {
  if(a > b) {
    int tmp = a;
    a = b;
    b = tmp;
  }
  if(a == 0) {
    return b;
  }
  return gcd(a, b - a);
}

void main() {
  // Variable declaration
  
  int ipl = 120;
  int p = 120;
  int football = 45;
	
  char ball = 'i';
  float db = -456.3423;
  
  /*This is a multi-line comment
   * Real Madrid is better than Barcelona
   * Football is the best sport in the world
   */
  /*Real Madrid came from two goals down to salvage a 2-2 draw 
   * at the Borussia Park against Borussia Monchengladbach in the 
   * second round of the UEFA Champions League group stages
   */  
  int x = 10, y = 5, a = 67, b = 89;
  
  ipl = a + b;
  int k = ipl - football;
  k = x*y;
  l = x/y;
  l = x%y;
  n = x&y;
  o = x|y;
  
  //Unary operators
  y = i<<2;
  x = i>>1;
  
  y = (1 << x);
  
  return 0;
}

