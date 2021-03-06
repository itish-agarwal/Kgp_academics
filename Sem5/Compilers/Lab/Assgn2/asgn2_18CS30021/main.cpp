#include <bits/stdc++.h>
using namespace std;
#include "toylib.h"
int result;

int main() {
  int use = 0;
  float f = 1.0;
  //test function printStringUpper;
  char input[] = "abcdSD";
  result = printStringUpper(input);
  
  //test function readHexInteger;
  result = readHexInteger(&use);
  
  //test function printHexInteger;
  use = -65529;
  result = printHexInteger(use);
  
  //test function readFloat;
  result = readFloat(&f);
  
  //test function printFloat;
  f = 56.2343;
  result = printFloat(f);
  return 0;  
}
