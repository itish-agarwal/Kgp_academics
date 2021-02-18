#include<bits/stdc++.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/wait.h>
#include <readline/readline.h> 
#include <readline/history.h> 

#define ANSI_RED "\033[0;31m"
#define ANSI_GREEN "\033[0;32m"
#define ANSI_YELLOW "\033[0;33m"
#define ANSI_CYAN "\033[0;36m"
#define ANSI_RED_BOLD "\033[1;31m"
#define ANSI_GREEN_BOLD "\033[1;32m"
#define ANSI_YELLOW_BOLD "\033[1;33m"
#define ANSI_CYAN_BOLD "\033[1;36m"
#define ANSI_PURPLE "\033[0;35m"
#define ANSI_BLUE "\033[0;34m"
#define ANSI_DEFAULT "\033[0m"
#define ANSI_CLEAR "\033[2J\033[1;1H"
#define MAX_N 1024

using namespace std;

//Print the help manual
void help() {
  printf(ANSI_CYAN"\n\t\t\t  OS ASSIGNMENT 2 SHELL\n\n");  
  printf("Created By : Aditya Singh (18CS30005)\n             Itish Agarwal (18CS30021)\n\n");
  printf("Type parts and press enter to execute them\n\n");
  printf(ANSI_DEFAULT);
  printf("'help'                            Opens the help manual\n");
  printf("'quit' or 'q'                     Exits the shell\n");
  printf("'./executable'                    To run an exectubale file\n");
  printf("'./exectubale < infile.txt'       To run an executable with input taken from input.txt\n");
  printf("'./exectubale < outfile.txt'      To run an executable with output put into input.txt\n");
  printf(" (Similary, there can be combination of input and output redirection)\n");
  printf(" (All other parts run normally here as they do on the builtin linux shell)\n\n");
}  

vector<string> splitString(string s, char d) {
  vector<string> answer;
  stringstream ss(s);
  string t;
  while(getline(ss, t, d)) {
      if(t.size()==0) continue;
      answer.push_back(t);
  }
  return answer;
}

// Removes whitespaces from beginning and end of string

string trim(string s) {
  int n = s.length();
  if(n==0) return s;
  int i = 0, j = n - 1;
  while(i<n && s[i]==' ') ++i;
  while(j>=0 && s[j]==' ') --j;
  return s.substr(i, j-i+1);
}

// Open files and redirect input and output with files as arguments

void OpenAndRedirect(string input, string output) {
  if(input.size()) {      
    int input_file = open(input.c_str(), O_RDONLY);
    if (input_file < 0) {
      cout << "Error : " << input << " file could not be opened" << endl;
      exit(1);
    } 
    if ( dup2(input_file, 0) < 0 ) {
      cout << "Error : Input could not be redirected" << endl;
      exit(1);
    }
  }
  if(output.size()) {
    int output_file = open(output.c_str(), O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU);
    //S_IRWXU -> This is equivalent to ‘(S_IRUSR | S_IWUSR | S_IXUSR)’.
     //dup2(file_descriptor, 1) -> write output to the file

    if( dup2(output_file, 1) < 0 ) {
      cout << "Error : Output could not be redirected" << endl;
      exit(1);
    }
  }
}

// Checks if there is some redirection to input and output files. If there is, it stores the command, the input file and the output file

vector<string> checkRedirection(string s){
  vector<string> ans ( 3 );
  vector<string> empty;
  vector<string> parts1 = splitString(s , '<');
  if(s.back() == '<' || s.back() == '>') return empty;
  // a or a > c   case
  if(parts1.size() == 1){
    vector<string> parts2 = splitString(s , '>');
    // a case
    if(parts2.size() == 1){
      ans[0] = trim(parts2[0]);
      if(ans[0]=="") return empty;
    }
    // a > c case
    else{
      ans[0] = trim(parts2[0]);
      if(ans[0]=="") return empty;
      ans[2] = trim(parts2[1]);
      if(ans[2]=="") return empty;
    }
  }
  // a < b  or  a < b > c   case
  else{
    vector<string> parts3 = splitString(parts1[1] , '>'); //parts1[1] is    b or b > c
    // a < b case
    if(parts3.size()==1){
      ans[1] = trim(parts3[0]);
      if(ans[1]=="") return empty;
    }
    // a < b > c  case
    else{
      ans[1] = trim(parts3[0]);
      if(ans[1]=="") return empty;
      ans[2] = trim(parts3[1]);
      if(ans[2]=="") return empty;
      // cout <<"inp file = [" << ans[1] <<"]\n";
    }
    ans[0] = trim(parts1[0]);
    if(ans[0]=="") return empty;
  }
  return ans;
}

// Execute the parts

int execute(string command){
  vector<string> arr , parts = splitString(command , ' ');
  for(auto & here: parts){
    if(parts.size()>0){
      arr.push_back(here);
    }
  }
  int n = arr.size();
  char * arg[n+1]; // 1 more to accomodate NULL at the end
  arg[n]=NULL;  
  for(int i=0;i<n;i++){
    const char *c = arr[i].c_str();     // .c_str converts a c++ string object to const char* pointer
    arg[i] = const_cast<char*>(c);      // const_cast is a casting operator
  }
  int val = execvp( arg[0] , arg );
  return val;
}

void printDir() {
  char cwd[1024]; 
  getcwd(cwd, sizeof(cwd)); 
  printf("%s", cwd); 
} 
  

// Main shell loop

int shell_loop() {       
  while(true) {
    string cmd;
    char *buffer;
    bool bg_status = false;
    // get current working directory
    char cwd[1000];
    getcwd(cwd, sizeof(cwd)); 
    char *username;
    username = getenv("USER");
    char hostname[1000];
    gethostname(hostname, 1+1000);
    
    string dislpay_prompt = ANSI_GREEN_BOLD + (string)username + ANSI_DEFAULT + " @ " + ANSI_YELLOW_BOLD + (string)cwd + ANSI_DEFAULT + " $ ";
    dislpay_prompt += "";

    buffer = readline( dislpay_prompt.c_str() );
    cmd = buffer;

    cmd = trim(cmd);
    add_history(buffer);
    if(cmd == "help") {
      help();
      continue;
    }
    if(cmd[(int)cmd.size()-1] == '&'){
      bg_status = true;
      cmd.pop_back();
    }
    // Split into several parts wrt to |
    vector<string> commands = splitString(cmd, '|');
    // If no pipes are required
    if((int)commands.size()==1) {
      // Split the parts and redirection
      vector<string> parts = checkRedirection(commands[0]);
      vector<string> v = splitString(parts[0], ' ');
      if((int)v.size()==1 && v[0]=="cd") { //if the command is only 'cd'
        string k = "/home/";
        k += username;
        v.push_back(k);
      } 
      if( v[0] == "cd" && (int)v.size()==2 ){
        string dir = v[1];
        string usr_name = username;
        if(dir[0]=='~') dir = "/home/" + usr_name + dir.substr(1);          // ~ means "/home/USERNAME"
        const char* c = dir.c_str();
        int val = chdir(c);
        if(val < 0 ) cout <<"No such file or directory\n";
      } else if(splitString(commands[0],' ').size()==1 && splitString(commands[0],' ')[0] == "exit") {
        printf(ANSI_CYAN"Goobdbye until we meet next :)\n\n");
        return 0;
      } else {
        if(fork() == 0) {
          OpenAndRedirect(parts[1], parts[2]); // Redirect input and output
          int exec = execute(parts[0]);
          if (exec < 0) {
             cout << "Sorry, command not found\n\n";
          }
          exit(EXIT_SUCCESS); 
        }
        if(!bg_status) {
            wait(NULL);
        }
      }
    }
    else {
      int n = commands.size(); 
      int new_file_desc[2], old_file_desc[2];
      for(int i=0; i<n; i++) {
        vector<string> parts = checkRedirection(commands[i]);
        if(i!=n-1){                 // Create new pipes (except for the last command)
          int s = pipe(new_file_desc);
        }
        // In the child process
        if(fork() == 0) {
          if( !i || i==n-1 ) {
            OpenAndRedirect(parts[1], parts[2]); 
          }
          // Read from previous command for everything except the first command
          if(i) {
            dup2(old_file_desc[0],0), close(old_file_desc[0]), close(old_file_desc[1]);
          }
          // Write into pipe for everything except last command
          if(i != n-1) {
            close(new_file_desc[0]), dup2(new_file_desc[1],1), close(new_file_desc[1]);
          }
          // Execute command
          execute(parts[0]);
        }
        if(i) {
          close(old_file_desc[0]), close(old_file_desc[1]);
        }
        // copy new_file_desc into old_file_desc for everything except the last process
        if(i!=n-1) {
          old_file_desc[0] = new_file_desc[0], old_file_desc[1] = new_file_desc[1];
        }
      }
      // If no background, then wait for all child processes to return before the parent can start to execute another process
      if(!bg_status) {
        while( wait(NULL) > 0);
      }
    }
  }
}

int main() {

  using_history();
  printf(ANSI_RED_BOLD "\n\t\t[[ Welcome to OS ASSIGNMENT 2 LINUX SHELL ]]\t\n" ANSI_DEFAULT);
  printf(ANSI_YELLOW"\nOS Assignment 2 - Implementation of command-line interpreter running on top of Linux kernel\n");
  printf("        This is a shell created as part of the Operating Systems Lab Assignment 2\n");
  printf("               Type 'help' for a guided manual on how to get started\n\n");
  printf("                        Type 'exit' to exit the shell\n\n" ANSI_DEFAULT);
    
  int status = 1;
  while(status) {
    status = shell_loop();
  }
  return 0;
}
