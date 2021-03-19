// Include relevant header files 
#include <errno.h> 
#include <time.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <signal.h> 
#include <stdio.h> 
#include <sys/socket.h> 
#include <sys/types.h> 
#include <unistd.h> 
#include <netdb.h>   
#include <netinet/in.h> 
#include <stdlib.h> 
#include <string.h> 

#define B       20
#define PORT    6192 
#define MAX_N   1024

void print_status(int file_size, int blocks, int end_block) {
		printf("The file transfer is successful!\n\n");
		printf("File size is:        %d\n", file_size);
		printf("No of blocks is:     %d\n", blocks + ((end_block==0)?0:1) );
		if(end_block == 0 && file_size != 0) {
				printf("Last block size is:  %d\n\n", B);
		}
		else {
				printf("Last block size is:  %d\n\n", end_block);
		}

		printf("Blocksize used is:   %d\n", B);
}

int main() {
    // Declaration of variables
		struct sockaddr_in serv_addr; 
		int n, length, socket_fd1, file_size, file_ptr;  
    char array[MAX_N], file_name[MAX_N];

    //Setting it to zero -> one can also use memset here
		//memset( & server_addr, 0, sizeof(server_addr) );
		bzero(&serv_addr, sizeof(serv_addr)); 

		serv_addr.sin_port = htons(PORT); 
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_family = AF_INET;     

    //Socket creation
    socket_fd1 = socket(AF_INET, SOCK_STREAM, 0);
    if ( socket_fd1 < 0 ) { 
        printf("Socket creation failed!\n"); 
        exit(0); 
		}

		int foo = 1;
		//for(int i = 0; i < MAX_N; ++i)
		setsockopt(socket_fd1, SOL_SOCKET, SO_REUSEADDR, &foo, sizeof(foo));

		//Try connecting to server
		int could = connect(socket_fd1, (struct sockaddr*)&serv_addr, sizeof(serv_addr));
		if ( could < 0 ) { 
	       printf("Connection failed! \n");
	       exit(0);
		}   

		//If connection to server is successful, proceed with asking the file name from the client
		//Input file_name from client
		printf("Enter name of file: ");
		scanf("%s", file_name);

		//Send file to server
		send(socket_fd1, file_name, strlen(file_name) + 1, 0);

		for(int i = 0; i < MAX_N; i++) {
				array[i] = '\0';
		}

		//We wait till one character is received using MSG_WAITALL
		length = recv(socket_fd1, array, 1, MSG_WAITALL);

		//Check if file does not exist
		if(array[0] == 'E'){ //According to assignment, server sends an 'E' in case file is not found
				printf("File was not found by the server!\n");
				return 0;
		}

		//If the file is found
		//Receive file_size and wait till it is received using MSG_WAITALL
		length = recv(socket_fd1, &file_size, 4, MSG_WAITALL);

		// Create or overwrite file -> copy contents into output.txt
		file_ptr = open("output.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);

		//Find number of blocks that are completed and end_block using modulus operation
		int blocks = file_size / B;
		int end_block = file_size % B;

		for(int ki = 0; ki < blocks ; ki++){
				length = recv(socket_fd1, array, B, MSG_WAITALL);

				//Write to output.txt file
				write(file_ptr, array, length);
		}
		// Receive last block
		length = recv(socket_fd1, array, end_block, MSG_WAITALL);

		write(file_ptr, array, length);

		//Print the status of the operation.
		//We print file transfer stats 
		print_status(file_size, blocks, end_block);			
		
		close(socket_fd1);
		return 0; 
}
