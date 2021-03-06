//Test file 2
//This time, let us write code for a well known recursive problem, ie, the fibonacci code

int fibo(int n) {
  if(n <= 1) {
    return 1;
  }
  return fibo(n-1) + fibo(n-2);
}

//Let us also write code for binary exponentitation
int power(int a, int b) {
  if(b == 0) return 1;
  int res = power(a, b/2);
  res *= res;
  if(b % 2) {
    res *= a;
  }
  return res;
}

//Let us write code for a well known divide and conquer problem, merge sort
void bubblesort(int arr[], int n) {
  int i, j;
  for(i = 0; i < n-1; i++) {
    for(j = 0; j < n-1-i; j++) {
      if(arr[j] > arr[j+1]) {
        int tmp = arr[j];
        arr[j] = arr[j+1];
        arr[j+1] = tmp;
      }
    }
  }
  return;
}

int main() {
  
  //Read an integer n
  int n;
  read(n);
  
  //Print the integer
  print(n);
  
  n = fib(6);
  //Now this version of fibonacci numbers is very slow, ie, 
  //for input >= 50, it may well take more than 2-3 minutes
  
  int a[100];
  a[0] = 9;
  a[1] = 8;
  a[2] = 839;
  a[3] = 33;
  a[4] = 2;
  a[5] = 67;
  a[6] = 92312;
  a[7] = 90;
  a[8] = 7;
  //for(int i = 0; i < 10; i++) {
    //a[i] = 100 - i;
  //}
  bubblesort(a, 9);
  return 0;
}

