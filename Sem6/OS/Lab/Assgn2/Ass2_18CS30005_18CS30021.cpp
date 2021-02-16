#include<bits/stdc++.h>
#include<unistd.h>
#include<fcntl.h>
#include<sys/wait.h>


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

using namespace std;

//Print the help manual
void help() {

	printf(ANSI_CYAN"\n\t\t\t  OS ASSIGNMENT 2 SHELL\n\n");  
	cout << "Created By : Aditya Singh (18CS30005)\n             Itish Agarwal (18CS30021)\n\n";
	cout << "Type commands and press enter to execute them\n\n";
  
  printf(ANSI_DEFAULT);
  
	cout << "'help'                            Opens the help manual\n";
	cout << "'quit' or 'q'                     Exits the shell\n";
  cout << "'./executable'                    To run an exectubale file\n";
  cout << "'./exectubale < infile.txt'       To run an executable with input taken from input.txt\n";
  cout << "'./exectubale < outfile.txt'      To run an executable with output put into input.txt\n";
  cout << " (Similary, there can be combination of input and output redirection)\n";
  cout << " (All other commands run normally here as they do on the builtin linux shell)\n\n";
}

vector<string> splitString(string s, char d) {
    vector<string> answer;
    stringstream ss(s);
    string t;

    while(getline(ss, t, d)) {
        answer.push_back(t);
    }
    
    return answer;
}

// Removes whitespaces from beginning and end of string

string trim(string s) {
    string empty;
    for(int i=0; i<s.size(); i++) {
        if (s[i] != ' ') {
            s = s.substr(i);
        	break;
        }
    }

    int n=s.size();

    for(int i=0; i<n; i++) {
        if (s[n-1-i] != ' ') {
            return s.substr(0, n-i);
        }
    }
    return empty;
}

// Open files and redirect input and output with files as arguments

void OpenAndRedirect(string input, string output) {
    if(input.size()) {
      
      
      //The open() system call opens the file specified by pathname.  
      //If the specified file does not exist, it may optionally (if O_CREAT is specified in flags) be created by open().

       //The return value of open() is a file descriptor, a small, nonnegative integer that 
       //is used in subsequent system calls to refer to the open file.
       //The file descriptor returned by a successful call will be the 
     //  lowest-numbered file descriptor not currently open for the process.

      
      
        int input_file = open(input.c_str(), O_RDONLY);

        if (input_file < 0) {
          //Error in opening 
   

//In simple words, when you open a file, the operating system creates an entry to 
//represent that file and store the information about that opened file. 
//So if there are 100 files opened in your OS then there will be 
//100 entries in OS (somewhere in kernel). 
//These entries are represented by integers like (...100, 101, 102....). 
// This entry number is the file descriptor. 
//So it is just an integer number that uniquely represents an opened file in operating system. 
//If your process opens 10 files then your Process table will have 10 entries for file descriptors.

//Similarly when you open a network socket, it is also represented by an integer and 
//it is called Socket Descriptor. I hope you understand




//DUP

//dup()



            cout << "Error : " << input << " file could not be opened" << endl;
            exit(EXIT_FAILURE);
        }   
        //dup2(file_descriptor, 0) -> take input from input file 
        
        //dup2()
        
//The dup2() system call creates a copy of a file descriptor.

//It uses the lowest-numbered unused descriptor for the new descriptor.
//If the copy is successfully created, then the original and copy file descriptors may be 
//used interchangeably.
//They both refer to the same open file description and thus share file offset and file status flags.

//The dup2() system call is similar to dup() but the basic difference 
//between them is that instead of using the lowest-numbered unused file descriptor,
// it uses the descriptor number specified by the user.

//execvp : Using this command, the created child process does not have to run the same program 
//as the parent process does. The exec type system calls allow a process to run any program files, 
//which include a binary executable or a shell script

        if (dup2(input_file, 0) < 0) {
            cout << "Error : Input could not be redirected" << endl;
            exit(EXIT_FAILURE);
        }
    }

    if(output.size()) {
        int output_file = open(output.c_str(), O_CREAT|O_WRONLY|O_TRUNC, S_IRWXU);
        //S_IRWXU -> This is equivalent to ‘(S_IRUSR | S_IWUSR | S_IXUSR)’.
            
         //dup2(file_descriptor, 1) -> write output to the file

        if(dup2(output_file, 1) < 0) {
            cout << "Error : Output could not be redirected" << endl;
            exit(EXIT_FAILURE);
        }
    }
}

// Checks if there is some redirection to input and output files. If there is, it stores the command, the input file and the output file

vector<string> checkRedirection(string line) {
	vector<string> answer(3, "");
	vector<string> input_split = splitString(line, '<');

	if (input_split.size() == 1) {

		vector<string> output_split = splitString(line, '>');

		if (output_split.size() == 1) {
			answer[0] = trim(line);
		}
		else {
			answer[0] = trim(output_split[0]);
			answer[2] = trim(output_split[1]);
		}

		return answer;
	}

	vector<string> output_split = splitString(line, '>');

	if (output_split.size() == 1) {
		answer[0] = trim(input_split[0]);
		answer[1] = trim(input_split[1]);
		return answer;
	}

	vector<string> left_split = splitString(input_split[0], '>');
	vector<string> right_split = splitString(input_split[1], '>');

	if (left_split.size() == 1) {
		answer[0] = trim(left_split[0]);
		answer[1] = trim(right_split[0]);
		answer[2] = trim(right_split[1]);
		return answer;
	}

	if (right_split.size() == 1) {
		answer[0] = trim(left_split[0]);
		answer[1] = trim(right_split[0]);
		answer[2] = trim(left_split[1]);
	}

	return answer;  
} 

// Execute the commands

int execute(string cmd) {
  
 //execvp : Using this command, the created child process does not have to run the same 
 //program as the parent process does.
 // The exec type system calls allow a process to run any program files, 
 //which include a binary executable or a shell script . Syntax:
 
//int execvp (const char *file, char *const argv[]);
//file: points to the file name associated with the file being executed.
//argv:  is a null terminated array of character pointers.

    vector<string> args;
    vector<string> v = splitString(cmd,' ');

    for(int i = 0; i < v.size(); ++i) {
        if(v[i].size() != 0) {
            args.push_back(v[i]);
        }
    }

    vector<char *> argv;
    for (int i = 0; i < args.size(); ++i) {
    	char *temp;
    	temp = (char *)malloc(args[i].length()*sizeof(char));
    	strcpy(temp, args[i].c_str());
    	argv.push_back(temp);
    }
    
    //the execvp command accepts a pointer to array of array of characters, ie, address of the first element of the 
    //array argv, and that is handled by the double pointer here
    char **arg = &argv[0];
    //
    return execvp(arg[0], arg);
}

void printDir() {
    char cwd[1024]; 
    getcwd(cwd, sizeof(cwd)); 
    printf("%s", cwd); 
} 
  

// Main shell loop

void shell_loop() { 

	  string cmd;
    int status = 0;
    
      
    while(true) {
        
        bool bg_status = false;
        
        char* username = getenv("USER");
        
        printf(ANSI_CYAN_BOLD "%s", username);
        
        printf(ANSI_DEFAULT);
        cout << "@ ";
        
        printf(ANSI_YELLOW_BOLD);
        
        printDir();
        printf(ANSI_DEFAULT);
        cout << " $ ";       
        
        getline(cin, cmd);

        cmd = trim(cmd);

        if (cmd == "quit" || cmd == "q") {
          cout << "Goobdbye till we meet next :)\n";
        	break;
        }

        if (cmd == "help") {
        	help();
        	continue;
        }

        if(cmd.back() == '&') {
            bg_status = true;
            cmd.back() = ' ';
        }
        
        // Split into several commands wrt to |
        vector<string> all_commands = splitString(cmd, '|');

        // If no pipes are required
        if(all_commands.size()==1) {
            // Split the commands and redirection
            vector<string> separated_commands = checkRedirection(all_commands[0]);
            vector<string> keywords = splitString(all_commands[0], ' ');
            
            if((int)keywords.size()==2 && keywords[0] == "cd") {
                
                string dir = splitString(all_commands[0], ' ')[1];

                const char* c = dir.c_str();

                // Changing directory using chdir
                int s = chdir(c);  
                if(s <= -1) {
                  cout << "Error in changing directory (Check if directory exists)\n\n";
                } else {
                  cout << "Changing directory...\n";
                }             
                
                continue;                             
            }

            if(fork() == 0) {
                OpenAndRedirect(separated_commands[1], separated_commands[2]); // Redirect input and output
                int exec = execute(separated_commands[0]);
                cout << '\n';
                if (exec < 0) {
                	cout << "Sorry, command not found" << endl;
                  if(separated_commands[0] == "exit") {
                    cout << "Did you mean 'quit' (or 'q')?\n\n";
                  }
                }
                exit(EXIT_SUCCESS); 
            }
            
            //Normally, when the parent forks a child that executes a command using execlp() or
//execvp(), the parent calls the function wait(), thereby waiting for the child to terminate.
//Only after that, it will ask the user for the next command. However, if we want to run a
//program in the background, we do not give the wait(), and so the parent asks for the next
//command even while the child is in execution.

            if(!bg_status) {
                wait(&status);
            }
        }
        else {
            int n = all_commands.size(); 
            int new_file_desc[2], old_file_desc[2];

            for(int i=0; i<n; i++) {
                vector<string> separated_commands = checkRedirection(all_commands[i]);
                if(i!=n-1){                 // Create new pipes (except for the last command)
                    int s = pipe(new_file_desc);
                }

                // In the child process
                if(fork() == 0) {
                    if( !i || i==n-1 )
                        OpenAndRedirect(separated_commands[1], separated_commands[2]); 

                    // Read from previous command for everything except the first command
                    if(i)
                        dup2(old_file_desc[0],0), close(old_file_desc[0]), close(old_file_desc[1]);

                    // Write into pipe for everything except last command
                    if(i != n-1)
                        close(new_file_desc[0]), dup2(new_file_desc[1],1), close(new_file_desc[1]);

                    // Execute command
                    execute(separated_commands[0]);
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
                while( wait(&status) > 0);
            }
        }
    }
}

int main() {
	
  printf(ANSI_YELLOW_BOLD "\n\t\t[[ Welcome to OS ASSIGNMENT 2 SHELL ]]\t\n" ANSI_DEFAULT);
  
  printf(ANSI_YELLOW"\nOS Assignment 2 - Implementation of command-line interpreter running on top of Linux kernel\n");
  
  printf("        This is a shell created as part of the Operating Systems Lab Assignment 2\n");
  
  printf("               Type 'help' for a guided manual on how to get started\n\n" ANSI_DEFAULT);
    
	
  shell_loop();  
  
	exit(EXIT_SUCCESS);
}
