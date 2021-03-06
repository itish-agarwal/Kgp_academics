/*  Name: Itish Agarwal (18CS30021) 
    Compilers Laboratory Assignment 4
    Created on 8.10.2020  
*/

// This is a test file.

/* IMPORTANT NOTE - In my assignment, it may give an error when command 'make' is run once. However, the code runs when the 
          command 'make' is executed again, so I request the concerned authorities to run the command 'make' atleast
          2-3 times before grading my assignment */
          
/* IMPORTANT NOTE - In my assignment, it may give an error when command 'make' is run once. However, the code runs when the 
          command 'make' is executed again, so I request the concerned authorities to run the command 'make' atleast
          2-3 times before grading my assignment */

int main () { 
  //Let us begin with a simple fibonacci code 
  int n = 10;
  int fib[100];

  fib[0] = fib[1] = 1;
  int i;
  for(i = 2; i < 100; i++) {
    fib[i] = fib[i-1] + fib[i-2];
  }

  /* This is a multi line comment
    Real Madrid is the best team in the world. They are way better than Barcelona.
    It is my dream to visit Madrid and see a football match because you know what!
    Nothing compares to football */
  int i, j;
  int val[] = {60, 100, 120};
  int wt[] = {10, 20, 30};
  int  W = 50;
  int n = sizeof(val)/sizeof(val[0]);
  printf("%d", knapSack(W, wt, val, n));
  int n1 = 40;
  _initialize();
  printf("Fibonacci number is %d ", fib(n1));


  int person=101,a,b;
  printf("Enter the L and B of rectangle: \n");
  scanf("%d%d",&a,&b);
  printf("Area of rectangle is: %d",a*b);

  //Code for a standard dynamic programming question - edit distance between 2 arrays
  int dp[1000][1000];
  for(i = 1; i < n; i++) {
    for(j = 1; j < m; j++) {
      if(a[i]==b[j]) {
        dp[i][j] = dp[i+1][j+1] + 1;
      } else {
        dp[i][j] = min(dp[i+1][j], min(dp[i][j+1], dp[i+1][j+1])) + 1;
      }
    }
  }

  //Liverpool are currently the strongest team in the English Premier League but I like Manchester City more
  //because I like Kevin De Bruyne. He is one of the best play makers in the world;
  //Check if statement now
  if(5==5) {
    printf("INDEED! 5 is equal to 5! Wow we proved such a difficult thing!");
    //Just kidding
    QuickSort();
  } else {
    printf("Enough of testing!");
  }
  
  return 0;

}


