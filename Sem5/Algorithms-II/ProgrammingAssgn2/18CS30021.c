/*IMPORTANT NOTE - Since the library math.h is used in this assignment, the command to be used to compile this file is
                  
                   gcc 18CS30021.c -lm
 
*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

typedef struct POINT POINT;
typedef struct LSEGMENT LSEGMENT;
typedef struct ARC ARC;

//Defining structures here
struct POINT {
  double x, y;
};

struct LSEGMENT {
  POINT start, end;
};  

struct ARC {
  POINT center;
  double begin, end;
};

//Function to sort the points wrt x coordinates
//Implementing MERGE SORT here;
void sort(POINT pts[], int n) {
  if(n <= 1) {
    return;
  }
  int k1 = n/2;
  int k2 = n-k1;
  //divide array into half
  POINT arr1[k1], arr2[k2];
  for(int i = 0; i < k1; i++) {
    arr1[i].x = pts[i].x;
    arr1[i].y = pts[i].y;
  }
  for(int i = 0; i < k2; i++) {
    arr2[i].x = pts[i + k1].x;
    arr2[i].y = pts[i + k1].y;
  }
  sort(arr1, k1); //call recursion on first half
  sort(arr2, k2); //call recusrion on second half
  int i = 0, j = 0, k = 0;
  //merge two sorted arrays
  while(i<k1 && j<k2) {
    if(arr1[i].x > arr2[j].x) {
      pts[k].x = arr2[j].x;
      pts[k].y = arr2[j].y;
      j++;
      k++;
    } else {
      pts[k].x = arr1[i].x;
      pts[k].y = arr1[i].y;
      i++;
      k++;
    }
  }
  while(i<k1) {
    pts[k].x = arr1[i].x;
    pts[k].y = arr1[i].y;
    i++;
    k++;
  }
  while(j<k2) {
    pts[k].x = arr2[j].x;
    pts[k].y = arr2[j].y;
    j++;
    k++;
  }
  return;
}

//Function to check orientation of a point with respect to directed line formed by other two points
int orientation(POINT p, POINT q, POINT r) {
  //Here we return 1 if p->q>-r is a right turn and -1 if p->q->r is a left turn;
  /*Use the determinant | 1    1    1 | to determine on which of the directed line p->q does point r lie;
                        |p.x  q.x  r.x|
                        |p.y  q.y  r.y|  */
  //If value of this det > 0, point r lies to left of directed line p->q
  //else if value of det < 0 point r lies to right of directed line p->q;
  //else point r lies on line p->q;
  double val = r.x*q.y - q.x*r.y - p.x*q.y + p.y*q.x + p.x*r.y - p.y*r.x;
  if(val > 0.0) {
    return 1;
  }
  return -1;
}
//pts stores centers of circles
//flag==1 means compute upper hull
//flag==-1 means compute lower hull
int CH(POINT S[], int n, int flag, POINT H[]) {
  
  //handle case for n==2 separately 
  if(n == 2) {
    H[0] = S[0];
    H[1] = S[1];
    return 1;
  }    
    
  //if flag==1, means we need to find the upper hull
  if(flag == 1) {
    //using an array to implement a stack
    POINT stack[n+n];
    //maintain a pointer 'top' to indicate the top of the stack (ie, where the new element has to be placed);
    int top = 0;
    
    //Push leftmost point in the stack
    stack[top] = S[0];
    top++;
    
    //Implementing Graham's scan
    for(int i = 1; i < n; i++) {
      while(top >= 2 && orientation(stack[top-2], stack[top-1], S[i]) != 1) {
        //orientation (POINT p, POINT q, POINT r) returns 1 if p->q->r forms a right turn and
        //-1 if the portion p->q->r forms a wrong turn(ie, a left turn)
        top--;
      }
      stack[top] = S[i];
      top++;
    }    
    
    //Store the result in H[];
    for(int i = 0; i < top; i++) {
      H[i] = stack[i];
    }
    //top is number of vertices in the upper hull
    //return top-1 (ie, number of edges) (According to question, return number of edges in the hull)
    return top-1;
  }
  
  //If we reach here, means flag==-1 so we need to find the lower hull
  POINT stack[n+n];
  int top = 0;
  stack[top] = S[0];
  top++;
  
  //Implementing Graham's scan
  for(int i = 1; i < n; i++) {
    while(top >= 2 && orientation(stack[top-2], stack[top-1], S[i]) != -1) {
      //orientation (POINT p, POINT q, POINT r) returns 1 if p->q->r forms a right turn and
      //-1 if the portion p->q->r forms a wrong turn(ie, a left turn)
      
      //Since this is lower hull, we need that there are no right turns and we need only left turns
      top--;
    }
    stack[top] = S[i];
    top++;
  }
  
  //Store the result in H[];
  for(int i = 0; i < top; i++) {
    H[i] = stack[i];
  }
  
  //top is number of vertices in the lower hull
  //return top-1 (ie, number of edges) (According to question, return number of edges in the hull)
  return top-1;
}

//Function to print the sections of the boundary of the containment zone in the specified format
void printcontzone(int u, int l, LSEGMENT T[], ARC A[]) {
  
  //flag > -1 means that we are printing values for the upper hull
  printf("\n--- Upper section\n");
  for(int i = 0; i < (u-1); i++) {      
    //Print arcs followed by the lines segments
    printf("    Arc     : (%.15lf,%.15lf) From %.15lf to %.15lf\n", A[i].center.x, A[i].center.y, A[i].begin, A[i].end);
    printf("    Tangent : From (%.15lf, %.15lf) to (%.15lf, %.15lf)\n", T[i].start.x, T[i].start.y, T[i].end.x, T[i].end.y);
  }
  //In the end, finally print arc for the rightmost circle
  printf("    Arc     : (%.15lf,%.15lf) From %.15lf to %.15lf\n", A[u-1].center.x, A[u-1].center.y, A[u-1].begin, A[u-1].end);
  
  //print values for the lower hull
  printf("--- Lower section\n");
  
  for(int i = u+l; i >= u+2; i--) {
    //Print in reverse order as we need to process circles in descending order of their x coordinates
    printf("    Arc     : (%.15lf,%.15lf) From %.15lf to %.15lf\n", A[i].center.x, A[i].center.y, A[i].begin, A[i].end);
    printf("    Tangent : From (%.15lf, %.15lf) to (%.15lf, %.15lf)\n", T[i].start.x, T[i].start.y, T[i].end.x, T[i].end.y);
  }
  //Finally, print the arc for the leftmsot circle
  printf("    Arc     : (%.15lf,%.15lf) From %.15lf to %.15lf\n", A[u+1].center.x, A[u+1].center.y, A[u+1].begin, A[u+1].end);
  return;  
} 
  
  
//Function to compute and print the sections of the boundary of containment zone
void contzone(POINT UH[], int u, POINT LH[], int l, double r, LSEGMENT T[], ARC A[]) {
  
  printf("+++ The containment zone");
  const double pi = 3.141592653589793; //storing value of pi
  
  //Now we will populate the ARC array A[] for the upper hull;
  //Maintain an angle 'last' (equal to pi in the beginning);
  //As we move along the circles in the upper hull, last maintains the total angle remaining (wrt 0)
  //for a particular circle and then we calculate how much we need to subtract from last to move on
  //to the next circle;
  double last = pi;
  const double ninety = pi/2;
  for(int i = 1; i < u; i++) {
    if(UH[i].y > UH[i-1].y) {
      
      double alpha = atan((UH[i].y - UH[i-1].y)/(UH[i].x - UH[i-1].x));
      //Angle between x axis and the line joining the circles i and i-1;
      
      //Using geometry, we can get the angle in the arc as theta = last - ninety + alpha;
      double theta = last - ninety - alpha;  
      
      //Store this arc in A[i-1];
      A[i-1].center = UH[i-1];
      A[i-1].begin = last;
      A[i-1].end = last - theta;
      
      //update last as we have scribed an angle theta in the clockwise sense on (i-1)th circle
      last -= theta;  
      
    } else {      
      
      double alpha = -atan((UH[i].y - UH[i-1].y)/(UH[i].x - UH[i-1].x));
      //As slope is negative, take a minus;
      
      //Using geometry, we can get the angle in the arc as theta = last - ninety + alpha;
      double theta = last - ninety + alpha;
      
      //Store this arc in A[i-1];
      A[i-1].center = UH[i-1];
      A[i-1].begin = last;
      A[i-1].end = last - theta;
      
      //update last;
      last -= theta;
    }    
  }
  
  //For the last circle (ie, rightmost circle), ending angle will be 0.000;
  A[u-1].center = UH[u-1];
  A[u-1].begin = last;
  A[u-1].end = last-last;
  last = pi;
  
  //Now populate the array T[] for the upper hull; (array of line segments)
  
  for(int i = 1; i < u; i++) {
    double theta = pi - last + fabs(A[i-1].begin - A[i-1].end);
    last -= fabs(A[i-1].begin - A[i-1].end);
    double x = -r;
    double y = 0.0;
    
    //Apply rotation formula (in the clockwise sense);
    
    double xPr = x*cos(theta) + y*sin(theta); 
    double yPr = y*cos(theta) - x*sin(theta);
    
    //Now shift the origin to center of the (i-1)th circle    
    xPr += UH[i-1].x;
    yPr += UH[i-1].y;
    
    x = -r;
    y = 0.0;
    
    double xT = x*cos(theta) + y*sin(theta);
    double yT = y*cos(theta) - x*sin(theta);
    
    //Shift origin to center of ith circle
    xT += UH[i].x;
    yT += UH[i].y;
    
    //Store the line segment (xPr, yPr) -> (xT, yT) in T[i-1];
    T[i-1].start.x = xPr;
    T[i-1].start.y = yPr;
    T[i-1].end.x = xT;
    T[i-1].end.y = yT;
  }  
  
  ////Now we will populate the ARC array A[] for the lower hull;
  //Maintain an angle 'last' (equal to 0.0 in the beginning);
  //As we move along the circles in the lower hull, last maintains the clockwise angle that we have maintained
  //(wrt 0) and at a particular circle we will find the angle subtended, ie, theta and then subtract it from last;
  
  //Populate the ARCS array now from u+1 onwards
  
  last = 0.0;
  
  for(int i = l-1; i >= 1; i--) {
    if(LH[i-1].y < LH[i].y) {
      double alpha = atan((LH[i].y - LH[i-1].y)/(LH[i].x - LH[i-1].x));
      //Angle between x axis and line joining centers of ith and (i-1)th circles;
      
      double theta = pi + last - ninety - alpha;
      //Using geometry, we can find the actual angle subtended in the arc as theta = pi + lastt - ninety - alpha;
      
      //Store result in A[i]
      A[i+u+1].center = LH[i];
      A[i+u+1].begin = last;
      A[i+u+1].end = last - theta;
      
      //Update last
      last -= theta;
    } else {
      double alpha = -atan((LH[i].y - LH[i-1].y)/(LH[i].x - LH[i-1].x));
      //As slope is negative, take a minus;
      
      double theta = last + ninety + alpha;
      //Using geometry, we can find the actual angle subtended in the arc as theta = last + pi/2 + alpha;
      
      //Store result in A[i];
      A[i+u+1].center = LH[i];
      A[i+u+1].begin = last;
      A[i+u+1].end = last - theta;
      last -= theta;
    }
  }
  
  //For the leftmost circle, ending angle will be -pi; 
  A[u+1].center = LH[0];
  A[u+1].begin = last;
  A[u+1].end = -pi;
  
  last = 0.0;
  
  //Now populate the array T[] for the lower hull; (array of line segments) (from u+1 onwards)
  for(int i = l-1; i > 0; i--) {
    
    double theta = last + fabs(A[i+u+1].begin - A[i+u+1].end);
    last += fabs(A[i+u+1].begin - A[i+u+1].end);
    
    double x = r;
    double y = 0.0;
    
    //Apply rotation formula(in clockwise sense)
    double xPr = x*cos(theta) + y*sin(theta);
    double yPr = y*cos(theta) - x*sin(theta);
    
    //Now shift origin to center of ith circle
    xPr += LH[i].x;
    yPr += LH[i].y;
        
    x = r;
    y = 0.0;
    
    double xT = x*cos(theta) + y*sin(theta);
    double yT = y*cos(theta) - x*sin(theta);
    
    //Shift origin to center of (i-1)th circle
    xT += LH[i-1].x;
    yT += LH[i-1].y;
    
    //Store the line segment (xPr, yPr) -> (xT, yT) in T[i];    
    T[i+u+1].start.x = xPr;
    T[i+u+1].start.y = yPr;
    T[i+u+1].end.x = xT;
    T[i+u+1].end.y = yT;
  }   
  
  return;
}

int main() {
  
  int n;
  double radius;
  
  //read n(number of points) and r(radius of each circle) from the terminal
  scanf("%d%lf", &n, &radius);
  
  //read n points from the user
  POINT pts[n+n];  
  for(int i = 0; i < n; i++) {
    scanf("%lf%lf", &pts[i].x, &pts[i].y);
  }
 
  //Call the 'sort' function to sort the points in increasing values of their x coordinates
  sort(pts, n);
  
  //Print the sorted list of points  
  printf("+++ Circles after sorting\n");
  for(int i = 0; i < n; i++) {
    printf("    %.15lf %.15lf\n", pts[i].x, pts[i].y);
  }
  printf("\n"); 
  
  POINT H[n+n], UH[n+n], LH[n+n];
  LSEGMENT T[n+n];
  ARC A[n+n];
  
  //Call function CH(S, n, flag, H) with flag == 1 indicating that we need the upper hull
  //u now gets the size of the hull(ie, the number of edges in the hull)
  int u = CH(pts, n, 1, H);  
  //incrementing u by 1 -> now u contains the number of vertices on the upper hull
  u++;
  
  //Storing the upper hull vertices in POINT UH[];
  for(int i = 0; i < u; i++) {
    UH[i] = H[i];
  }
  
  //Printing the vertices on the upper hull (in clockwise sense);
  printf("+++ Upper hull\n");
  for(int i = 0; i < u; i++) {
    printf("    %.15lf %.15lf\n", UH[i].x, UH[i].y);
  }
  
  //Call function CH(S, n, flag, H) with flag == -1 indicating that we need the lower hull
  //l now gets the size of the hull(ie, number of edges in the hull)
  int l = CH(pts, n, -1, H);
  //Incrementing l by 1 -> now l contains the number of vertices on the lower hull
  l++;
  
  //Storing the lower hull vertices in POINT LH[];
  for(int i = 0; i < l; i++) {
    LH[i] = H[i];
  }
  
  //Printing the vertices on the lower hull (in clockwise sense);
  printf("\n+++ Lower hull\n");
  for(int i = l-1; i >= 0; i--) {
    printf("    %.15lf %.15lf\n", LH[i].x, LH[i].y);
  }
  printf("\n");
  
  //Call contzone() to compute the upper and lower sections of the boundary of the containment zone,
  //and we will call the funciton printcontzone() from contzone() to print the arcs and the tangents
  
  //Here, UH is array of points in the upper hull,
  // LH is the array of points in the lower hull,
  // u is the size of the upper hull,
  // l is the size of the lower hull,
  // T is array of LSEGMENT (line segments) (T is to be populated),
  // A is array of ARC (arcs) (A to be populated);
  contzone(UH, u, LH, l, radius, T, A);     
   
  //Finally, call printcontzone() to print the arrays A and T in the specified format
  printcontzone(u, l, T, A);
  
  return 0;
}
  
