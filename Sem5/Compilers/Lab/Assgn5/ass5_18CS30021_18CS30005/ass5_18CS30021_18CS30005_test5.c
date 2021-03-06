// Dynamic Programming solution for Rod cutting problem 

int max(int a, int b) {
  if(a > b) {
    return a;
  } 
  return b;
}

int func(int price[100], int n)   {
  int val[100]; 
  val[0] = 0; 
  int i, j; 
  int max_val = 1000000;   
  for (i = 1; i<=n; i++) {
    for (j = 0; j < i; j++) {
      max_val = max(max_val, price[j] + val[i-j-1]); 
    }
    val[i] = max_val; 
  } 
  return val[n]; 
} 

//Barcelona vs Juventus - December 8, 2020

int main() {
  
  char c='a',b='x';
  
  int arr[100]; 
  int i,n=100;
  
  for(i = 0; i < n; i++) {
    arr[i]=i; 
  }
  int ans = 0;
  ans = func(arr, size); 
  return 0; 
} 
