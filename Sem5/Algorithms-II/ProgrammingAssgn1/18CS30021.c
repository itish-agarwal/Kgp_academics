#pragma GCC optimize("Ofast") 
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

const int inf = 2e9 + 334466;
int fromNBF, possible;

//type all struct's here so we do not have to use 'struct' everytime
typedef struct EDGE EDGE;
typedef struct VERTEX VERTEX;
typedef struct GRAPH GRAPH;

//declare struct EDGE, VERTEX and GRAPH
struct EDGE {
  int y, c, f;
  struct EDGE* next;
};

struct VERTEX {
  int x, n;
  struct EDGE* p;
};

struct GRAPH {
  int V, E;
  struct VERTEX* H;
};

int min(int a, int b) {
  if(a < b) {
    return a;
  }
  return b;
}

int max(int a, int b) {
  if(a > b) {
    return a;
  }
  return b;
}

void min_self(int* a, int b) {
  if(b < *a) {
    *a = b;
  }
  return;
}

void max_self(int* a, int b) {
  if(b > *a) {
    *a = b;
  }
  return;
}

//function to read the graph
struct GRAPH* ReadGraph(char* fname) {  
  FILE* fp;
  fp = fopen(fname, "r");
  
  //handle error in opening file  
  if(fp == NULL) {
    printf("Error in opening the input file\n");
    exit(1);
  } 
  int n, m;
  fscanf(fp, "%d%d", &n, &m);
  
  //create a pointer to the graph that will be read
  GRAPH* graph = (GRAPH*)malloc(1*sizeof(GRAPH));
  graph->V = n;
  graph->E = m;
  graph->H = (VERTEX*)malloc((n+4)*sizeof(VERTEX));
  
  //numbering vertices from 1 to n
  for(int i = 1; i <= n; i++) {
    int need;
    //read the need values of the vertices
    fscanf(fp, "%d", &need);
    graph->H[i].n = need;
    graph->H[i].x = i;
    graph->H[i].p = NULL;
  }
    
  EDGE* last[n+4];
  for(int i = 1; i <= n; i++) {
    last[i] = NULL;
  }
  
  //read edges
  for(int i = 0; i < m; i++) {
    int a, b, cap;
    fscanf(fp, "%d%d%d", &a, &b, &cap); 
    
    //create a new edge dynamically    
    EDGE* edge = (EDGE*)malloc(sizeof(EDGE));
    edge->y = b;
    edge->f = 0;
    edge->c = cap;
    edge->next = NULL;    
    if(last[a]==NULL) {      
      graph->H[a].p = edge;
      last[a] = edge;
    } else {
      last[a]->next = edge;
      last[a] = edge;
    }
  }
  return graph;
}
  
  
//function to print a given graph
void PrintGraph(GRAPH G) {    
  //iterate over vertices of the given graph, ie, from 1 to G.V
  for(int i = 1; i <= G.V; i++) {    
    printf("%d  ", i);
    if(G.H[i].p == NULL) {
      printf("->\n");
      continue;
    }   
    EDGE* they = G.H[i].p;
    while(they) {
      int to = they->y;
      if(to>=1 && to<=G.V) {
        printf("-> (%d,%d,%d) ", they->y, they->c, they->f);
      }
      they = they->next;
    }
    printf("\n");    
  }
  return;
}


//function to find the augmenting path and the residual capacity 
int bfs(int n, int s, int t, int parent[], int* adj[], int* capacity[]) {
  
  int ans[n+4], level[n+4], path[n+4];
  for(int i = 0; i <= (n+3); i++) {
    ans[i] = 0;
    level[i] = -1;
    path[i] = inf;
  }
  level[s] = path[s] = 0;
  ans[s] = inf;
  
  //ans[i] stores the residual capacity upto that vertex, ie, among all shortest paths from source s to i, one having 
  //maximum residual capacity
  
  //level[i] basically tells us if vertex i has been visited or not
  
  //path[i] stores the path len upto vertex i, ie, length of shortest path from soure s to i
  
  //declare an array to use as an queue, maintain two pointes, ie pop and push
  int queue[n+n];
  //push source s into queue
  queue[0] = s;
  int pop = 0, push = 1;  
  while(pop < push) {
    int from = queue[pop];
    pop++;
    //iterate over all neighbours of this vertex(in the undirected graph)
    for(int i = 1; i <= adj[from][0]; i++) {
      int to = adj[from][i];
      if(capacity[from][to] > 0) {
        //enter only if capacity[from][to] > 0, ie, there exists an edge from 'from' -> 'to'
        if(level[to] == -1) { //if this vertex is not yet visited, push it into queue
          queue[push] = to;
          push++;
          level[to] = level[from] + 1;
        }
        //Now, we are at vertex a and we want to update its neighbour b
        //if path[a] + 1 < path[b], we will definitely take this path, because our first priority is to 
        //minimize the path length of the augmenting path, and then only maximise the residual capacity
        if(path[from] + 1 < path[to]) {
          parent[to] = from;
          max_self(&ans[to], max(ans[to], min(capacity[from][to], ans[from])));
          path[to] = path[from] + 1;
        } else if(path[from] + 1 == path[to]) {
          //if we reach here, it means ans[to] was already equal to path[from]+1, so we will update ans[to] only if
          //it benefits us(wrt residual capacity)
          if(min(capacity[from][to], ans[from]) > ans[to]) {
            parent[to] = from;
            ans[to] = min(capacity[from][to], ans[from]);
            path[to] = path[from] + 1;
          }
        }
      }
    }
  }
  //finally return ans[t], ie, among all shortest paths from s to t, the one with maximum residual capacity
  //ans[t] stores this maximum residual capacity
  return ans[t];
}
          
          
//function to compute max flow given a graph, a source and a sink
void ComputeMaxFlow(GRAPH* G, int s, int t) {  
  int n = G->V;
  
  int* adj[n+4];
  int* has[n+4];
  int* capacity[n+4];
  int* alter[n+4];
  
  for(int i = 0; i <= (n+3); i++) {
    adj[i] = (int*)malloc((n+4)*sizeof(int));
    has[i] = (int*)malloc((n+4)*sizeof(int));
    capacity[i] = (int*)malloc((n+4)*sizeof(int));
    alter[i] = (int*)malloc((n+4)*sizeof(int));
    for(int j = 0; j <= (n+3); j++) {
      adj[i][j] = has[i][j] = capacity[i][j] = alter[i][j] = 0;
    }
  }
  
  //adj is the adjacency matrix of the vertices of the undirected graph, for any vertex x, adj[x][0] contains the size of adjacency list of x, and indices from 1 to adj[x][0] contain the neighbouring edges
  //has is basically a boolean array, has[i][j] = 1 if there exists and edge from i to j or from j to i
  //capacity is a 2d matrix that stores the residual capacity of the network
  //alter is a 2d matrix that stores the flow that needs to be added to a particular edge, it is updated after every iteration
  
  //fill the 'has' matrix, has[i][j] = 1 if there is an edge from i to j or from j to i;
  //fill the 'capacity' matrix, for any edge i to j, capacity[i][j] += edge->capacity;  
  for(int from = 1; from <= n; from++) {
    EDGE* they = G->H[from].p;
    while(they) {
      int to = they->y;
      int cap = they->c;
      has[from][to] = has[to][from] = 1;
      capacity[from][to] += cap;
      they = they->next;
    }
  }
  
  //fill the adjacency matrix for all vertices 
  for(int a = 1; a <= n; a++) {
    int s = 0, store = 1;
    for(int b = 1; b <= n; b++) {
      if(has[a][b]) {
        adj[a][store] = b;
        store++;
        s++;
      }
    }
    adj[a][0] = s;
  }  
  
  //Now our ford-fulkerson algorithm actually begins
  //intialise answer(ie, flow) to zero  
  int flow = 0;
  //parent array is used to get the augmenting path
  int parent[n+4];
  //new_flow is the flow that is obtained after each iteration
  int new_flow;  
  
  //while new_flow > 0, ie, while there exists an augmenting path in the residual network
  while((new_flow = bfs(n, s, t, parent, adj, capacity)) > 0) {
    flow += new_flow; //add new_flow to answer(ie, flow)
    //Now, iterate on edges of the augmenting path
    int cur = t;
    while(cur != s) {
      int prev = parent[cur];
      //decrease the capacity of the edge prev->cur by new_flow, as we are using new_flow through this edge
      capacity[prev][cur] -= new_flow;
      //increase alter[prev][cur], basically meaning that increase flow in this edge by new_flow;
      alter[prev][cur] += new_flow;
      //if we can increase new_flow along prev->cur, we can bring it back as well, hence update capacity of cur->prev;
      capacity[cur][prev] += new_flow;
      cur = prev;
    }
  }  
  
  //update the edge nodes of the actual graph, using the alter matrix, which now has the values of flows that flows through each edge
  for(int from = 1; from <= n; from++) {
    EDGE* they = G->H[from].p;
    while(they) {
      int to = they->y;
      they->f += alter[from][to];
      they->f = min(they->f, they->c);
      they = they->next;
    }
  }
  
  //Now check if ComputeMaxFlow was called from function NeedBasedFlow, or from main itself 
  if(fromNBF) {
    //means ComputeMaxFlow has been called from functino NeedBasedFlow
        
    int sumS = 0, sumT = 0;
    //sumS stores the sum of capacities of edges coming out from the dummy source s;
    //sumT stores the sum of capacities of edges going into the dummy sink t;
        
    //finding sumS
    EDGE* they = G->H[s].p;
    while(they) {
      sumS += they->c;
      they = they->next;
    }
    
    //finding sumT
    for(int i = 1; i <= n; i++) {
      EDGE* they = G->H[i].p;
      while(they) {
        int to = they->y;
        if(to==t && i!=t) {
          sumT += they->c;
        }
        they = they->next;
      }
    }
    
    //Now, there are 2 conditions that need to be checked - 
    //1. The flow that we get must be equal to sumS;
    //2. sumS must be equal to sumT
    
    //Reason - 
    //1. The source HAS to produce sumS, otherwise it will violate the condition that outflow-inflow = |n(i)| for producer vertices
    //   And if the source does produce sumS, this must be the flow in the graph
    
    //2. If sumS != sumT, basically that means the amount of flow emerging from source is not equal to amount of flow
    //   consumed by the sink, and that is not possible  
    
    if(flow==sumS && flow==sumT) {
      possible = 1;
      printf("Flow for Need Based Flow is : %d\n", flow);
    } else {
      possible = 0;
    }
  } else {
    //means ComputeMaxFlow was called from main only
    //print the max flow here
    possible = 1;
    printf("Max flow for ComputeMaxFlow is : %d\n", flow);
  }
  return;  
}  


//function to find the need based flow in the given graph
void NeedBasedFlow(GRAPH* G) {  
  GRAPH graph = *G;
    
  //create a copy of the graph
  GRAPH this = graph;
  
  int n = G->V, s = 0;
  int need[n+4];
  for(int i = 1; i <= n; i++) {
    need[i] = G->H[i].n;
    s += need[i];
  }  
  
  //if the sum of the needs of all the vertices is not zero, then need based flow cannot exist;
  if(s != 0) {
    possible = 0;
    printf("Need based flow does not exist :(\n");
    printf("Hence graph not printed\n");
    return;
  }
  
  //Now the idea of need based flow is-
  /* The constraint outflow-inflow = |n(i)| for producers and inflow-output = |n(i)| basically means that producers
   * MUST produce |n(i)| and consumers MUST consume |n(i)|
   * 
   * Now we introduce two dummy vertices, ie, a dummy source(vertex number n+1) and a dummy sink(vertex number n+2)
   * We connect dummy vertex(named dummyS) to all producer vertices and we connect all consumer vertices to the dummy
   * sink(named dummyT)
   * 
   * Now we call ComputeMaxFlow on this new graph with dummyS as source and dummyT as sink and find the max flow for
   * this graph, and we check two conditions: 
   * 
   * 1. The flow that we obtain must be equal to sumS, where sumS is the sum of the absolute values of need values
   *    of the producer vertices
   * 2. sumS must be equal to sumT, where sumT is the sum of the absolute values of the need values of the consumer 
   *    vertices
   * 
   * Reason - 
   * 1. The source HAS to produce sumS, otherwise it will violate the condition that outflow-inflow = |n(i)| for producer vertices 
   *    and if the source does produce sumS, this must be the flow in the graph
   * 2. If sumS != sumT, basically that means the amount of flow emerging from source is not equal to amount of flow 
   *    consumed by the sink, and that is not possible  
   */
   
  //create dummy source and dummy sink
  
  int dummyS = n+1;
  int dummyT = n+2;
  this.V += 2;
    
  EDGE* x = (EDGE*)malloc(sizeof(EDGE));
  x = NULL;
  EDGE* last[n+4];
  for(int i = 0; i <= (n+3); i++) {
    last[i] = NULL;
  }  
  for(int i = 1; i <= n; i++) {
    last[i] = G->H[i].p;
    if(last[i] == NULL) {
    } else {
      while(1) {
        if(last[i]->next == NULL) {
          break;
        }
        last[i] = last[i]->next;
      }
    }
  }    
  
  //connect dummyS to all producers(dummy source) and connect all consumers to dummyT(dummy sink)
  for(int i = 1; i <= n; i++) {
    if(need[i] < 0) {
      this.E++;
      EDGE* edge = (EDGE*)malloc(sizeof(EDGE));
      edge->y = i;
      edge->f = 0;
      edge->c = -need[i];
      edge->next = NULL;      
      if(x == NULL) {
        this.H[dummyS].p = edge;
        x = edge;
      } else {
        x->next = edge;
        x = edge;
      }
    } else  if(need[i] > 0) {
      this.E++;
      EDGE* edge = (EDGE*)malloc(sizeof(EDGE));
      edge->y = dummyT;
      edge->f = 0;
      edge->c = need[i];
      edge->next = NULL;
      
      if(last[i] == NULL) {
        this.H[i].p = edge;
        last[i] = edge;
      } else {
        last[i]->next = edge;
        last[i] = edge;
      }
    }
  }  
  
  //make fromNBF 1 so that CompputeMaxFlow knows that we are calling it from NeedBasedFlow
  fromNBF = 1;
  
  ComputeMaxFlow(&this, dummyS, dummyT);
  
  //if possible, then update the flow of the edges of the original graph
  if(possible) {
    //copy contents of graph this into graph *G;    
    int* ans[n+4];
    for(int i = 0; i <= (n+3); i++) {
      ans[i] = (int*)malloc((n+4)*sizeof(int));
      for(int j = 0; j <= (n+3); j++) {
        ans[i][j] = 0;
      }
    }    
    for(int i = 1; i <= (n+2); i++) {
      EDGE* they = this.H[i].p;
      while(they) {
        int to = they->y;
        ans[i][to] += they->f;
        they = they->next;
      }
    }    
    for(int i = 1; i <= n; i++) {
            
      EDGE* they = G->H[i].p;
      while(they) {
        int to = they->y;
        they->f = ans[i][to];
        they = they->next;
      }      
    }        
  } else {
    printf("Need based flow does not exist :(\n");
    printf("Hence graph not printed\n");
  }   
  return;
}

int main() {
  
  fromNBF = 0;
  char fname[50];
  
  //a. Read the file name as input
  printf("Enter input file name : ");  
  scanf("%s", fname);
  
  //b. Read the graph
  GRAPH* graph = ReadGraph(fname);
  
  //c. Call PrintGraph to print the graph  
  printf("The input graph is : ");
  printf("\n");
  PrintGraph(*graph);
  printf("\n");
  
  //d. Read id's of source and sink
  printf("Enter id of source : ");
  int s, t;
  scanf("%d", &s);
  printf("Enter id of sink : ");
  scanf("%d", &t);
  printf("\n");
  
  //e. Call ComputeMaxFlow to compute and print the maxflow in the graph  
  ComputeMaxFlow(graph, s, t);
  
  //f. Call PrintGraph;
  printf("After calling ComputeMaxFlow, the graph is : ");
  printf("\n");
  PrintGraph(*graph);
  printf("\n");
  
  //g. Read the graph  
  GRAPH* newGraph = ReadGraph(fname);
  
  //h. Call NeedBasedFlow to compute the need-based flow in the graph
  NeedBasedFlow(newGraph);
  
  //i. Finally, print the graph again if needbasedflow does exist;
  //possible is a boolean, it is true if need based flow exists else false
  if(possible) {
    printf("After calling NeedBasedFlow, the graph is : ");
    printf("\n");
    PrintGraph(*newGraph); 
    printf("\n");
  }
   
  return 0;
}
  
  
