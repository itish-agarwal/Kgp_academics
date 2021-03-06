//Test file 3
//Let us make use of pointers

int max_self(int* a, int b) {
  if(b > *a) {
    *a = b;
  }
  return;
}

void min_self(int* a, int b) {
  if(b < *a) {
    *a = b;
  }
  return;
}

int max(int a, int b) {
  if(a > b) {
    return a;
  }
  return b;
}

int min(int a, int b) {
  return a + b - max(a, b);
}

int swap(int* a, int* b) {
  int use = *a;
  *a = *b;
  *b = use;
  return;
}

int sum(int* res, int a, int b) {
  *res = a + b;
  return;
}

int diff(int* res, int a, int b) {
  *res = a - b;
  return;
}

int main() {
  
  int a = 0, b = 122;
  max_self(&a, b);
  float x = 5.6345;
  swapTwoNumbers(&a,&B);
	return 0;
  
}

