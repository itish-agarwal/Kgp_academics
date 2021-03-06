//test file 3
//Test case that finds number of trailing zeros in n factorial
//Time complexity -> O(logn)

int trialingZeros(int n) {
  int ans=0;
  while(n>0) {
    ans = ans + n/5;
    n = n/5;
  }
  return ans;
}

int main () {
  int n;
  int tikitaka=1;
  printStr("TEST FILE 3 running....\n\n");
  printStr("Program to find number of trailing zeros in factorial of a number\n\n"); 

  printStr("Enter the number: ");

  n = readInt(&tikitaka);

  printStr("\nNumber of trailing zeros in ");

  printInt(n);
  printStr("! is "); 

  printInt(trialingZeros(n));

  printStr("\n");
  return 0; 
} 