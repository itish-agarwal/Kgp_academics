#include <stdlib.h> 
#include <string.h> 
#include <stdio.h> 
#include <fcntl.h>  
#include <sys/wait.h>
#include <netdb.h> 
#include <netinet/in.h> 
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

#include <sys/socket.h> 
#include <sys/types.h> 

#define MAX_N 90
#define PORT 6192


int main(){

	char buffer[MAX_N];

	// Socket file descriptor

	int socket_status = socket(AF_INET, SOCK_STREAM, 0);

	if (socket_status < 0) {
		printf("Error : Socket creation failed\n");
		exit(EXIT_FAILURE);
	}

	// Server and client address

	struct sockaddr_in S_addr, C_addr;

	// Setting address to 0

	bzero(&S_addr, sizeof(S_addr));

	// Assigning IP and port to server address

	S_addr.sin_family = AF_INET; 						// IPv4 network
	S_addr.sin_addr.s_addr = htonl(INADDR_ANY);
	S_addr.sin_port = htons(PORT);

	// Binding socket to IP

	int value = bind(socket_status, (const struct sockaddr*) &S_addr, sizeof(S_addr));

	if (value != 0) {
		printf("Error : Socket binding failed\n");
		exit(EXIT_FAILURE);
	}

	// Begin listning on the socket

	int listen_val = listen(socket_status, 7);
	// Now server is ready to listen and verification 
	if (listen_val != 0){
		printf("Error : Failed to listen\n");
		exit(EXIT_FAILURE);
	}	

	for(int j = 0; ; j++) {

		printf("Server is active\n");
		printf("Searching for connections......\n\n");

		// Size of client address

		socklen_t len = sizeof(C_addr);

		int CFD = accept(socket_status , (struct sockaddr*) &C_addr, &len);

		// Accept the data packet from client and verification 
		if (CFD < 0 ){
			printf("Error : Can't accept connection.\n");
			exit(EXIT_FAILURE);
		}

		printf("Connection with client successful!\n");

		int bytes = read(CFD , buffer, sizeof(buffer));
		buffer[bytes] = '\0';

		printf("Client request : %s\n\n", buffer);

		
		int file_pointer_status = open(buffer , O_RDONLY);
		
		// If file does not exist

		if (file_pointer_status < 0) {
			printf("Error : File does not exist\n");
			close(CFD);
			continue;
		}
		// Begin reading from the file
		int status = 0;
		int read_bytes;

		for(int kk = 0; ; kk++) {
			read_bytes = read(file_pointer_status, buffer, sizeof(buffer));
			if(read_bytes <= 0) break;
			buffer[read_bytes] = '\0';
			if(fork() == 0) {
				write(CFD, buffer, sizeof(buffer));
				exit(0);
			}
			wait(&status);
		}
		//close file connection
		close(file_pointer_status);
		close(CFD);
	}
	
	// Closing socket file descriptor
	close(socket_status);

	return 0;
}
