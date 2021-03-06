// Test program that printStr factors of a number

void printFactors(int n) {
  int i;
  for (i = 1; i <= n; ++i) {
    if (n%i == 0) {
      printInt(i);
      printStr("\n");
    }
  }
}

int main() 
{ 
  int n, x;
  int err=1;
  printStr("TEST FILE 2 running....\n\n");
  printStr("Program to print factors of a number\n\n"); 
  printStr("Enter a Number : ");
  n = readInt(&err);
  printFactors(n);
  return 0; 
} 
