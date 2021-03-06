//test file 5
//Program to find and print the reverse of a number 

int reverse(int n) {
  int ans, rem;
  ans = 0;
  while(n>0) {
    rem = n%10;
    ans = ans*10;
    ans = ans+rem;
    n = n/10;
  }
  return ans;
}

int main() 
{ 
  int n, phi = 1;

  printStr("TEST FILE 5 running....\n\n");

  printStr("Program to reverse a number\n\n");

  printStr("Enter the number: "); 
  
  n = readInt(&phi);
  printStr("\n");

  printStr("Number on reversing becomes : ");
  printInt(reverse(n));
  printStr("\n");
  return 0; 
} 