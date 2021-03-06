//test file 4
//Recursive program to find whether a subset of an array has sum equal to the given target sum
//Time complexity -> O(2^n)
int subsetSum(int a[], int n, int s) {
  if(s == 0) {
    return 1;
  }
  if(n == 0) {
    return 0;
  }
  if(a[n-1] > s) {
    return subsetSum(a, n-1, s);
  }
  if(subsetSum(a, n-1, s)>0 || subsetSum(a, n-1, s-a[n-1])>0) {
    return 1;
  }
  return 0;
}

int main() {
  int a[20], n, i, s;
  int newton = 1;

  printStr("TEST FILE 4 running....\n\n");
  printStr("Program to find whether a subset of given array has sum equal to a given target sum\n\n");
  printStr("Enter number of elements of the array (< 20): ");
  n = readInt(&newton);

  printStr("Enter elements (each element in new line):\n");
  for(i = 0; i < n; i++) {
    a[i] = readInt(&newton);
  }
  printStr("Enter target sum: ");
  s = readInt(&newton);
  if(subsetSum(a, n, s)==1) {
    printStr("YES, there exits a subset with sum equal to given sum\n");
  } else {
    printStr("NO, there does not exist any subset with sum equal to given sum\n");
  }

  return 0;
}
