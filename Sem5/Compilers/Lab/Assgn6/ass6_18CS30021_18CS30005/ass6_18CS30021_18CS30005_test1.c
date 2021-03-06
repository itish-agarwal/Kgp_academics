// Test program to calculate factorial of a number

int factorial(int n) {
  int i, f=1;
  for(i=1; i<=n; i++) {
    f = f*i;
  }
  return f;
} 
  
int main () 
{ 
  int n;
  int err=1;
  printStr("TEST FILE 1 running....\n\n");
  printStr("Program to compute factorial of a number\n\n"); 
  printStr("Enter the number (< 15) : ");
  n = readInt(&err);
  printStr("\nFactorial of number is: "); //0,1,1,2,3,5,8
  printInt(factorial(n));
  printStr("\n");
  return 0; 
} 
