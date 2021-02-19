#include <netdb.h> 
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <sys/socket.h> 
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>  

#define struct_socket (struct sockaddr*) 

#define MAX_N 90
#define PORT 6192


int main(){
	int state = 0;
	int p, q;
	p = q = 0;
	
	struct sockaddr_in server_addr;

	int socket_status = socket(AF_INET, SOCK_STREAM, 0);
	char buffer[MAX_N];
	if(socket_status == -1){
		printf("Socket creation failed\nTerminating...");
		exit(EXIT_FAILURE);
	} else {
		printf("Socket created successfully...\n");
	}

	// setting it to zero -> one can also use bzero here
	// memset( & server_addr, 0, sizeof(server_addr) );
	bzero(&server_addr, sizeof(server_addr));

	// assigning IP and port to server_addr struct
	server_addr.sin_family = AF_INET; 						// to choose ipv4 protocol
	server_addr.sin_addr.s_addr = htonl(INADDR_ANY); 		
	server_addr.sin_port = htons(PORT);  					// host byte order to network byte order


	// connect client socket to server socket
	if( connect(socket_status , struct_socket &server_addr , sizeof(server_addr)) < 0 ) {
		printf("Connection with server failed\nTerminating...\n");
		exit(EXIT_FAILURE);
	} else {
		printf("Connected to server :)\n");
	}
	char file[1024];
	printf("\nEnter file: ");
	
	scanf("%s", file);

	// send the file to server
	write(socket_status, file, sizeof(file)); 

	// to detect if connection is closed or not
	int bytes = read(socket_status, buffer, sizeof(buffer));

	buffer[bytes] = '\0';
	
	if(bytes < 0){
		//print the file not found message as given in the assignent (on the client side);
		printf("ERR 01: File Not Found\n");
		exit(EXIT_FAILURE);
	}
	
	// make a file and write to the file
	int file_pointer_status = open("output_file", O_CREAT | O_RDWR | O_TRUNC, S_IRWXU);
	while(1) {
		buffer[bytes] = '\0';
		int l = strlen(buffer);
		p += l;
		for(int i = 0; i < l; ++i) {
			if(buffer[i]==',' || buffer[i]==';' || buffer[i]==':' || buffer[i]=='.' || buffer[i]==' ' || buffer[i]=='\t' || buffer[i]=='\n') state = 0;
			else if(state == 0) {
				state = 1;
				q++;
			}
		}
		write(file_pointer_status, buffer, l);
		bytes = read(socket_status, buffer, sizeof(buffer));
		if(bytes <= 0) break;
	}

	printf("\nThe file transfer done:)\nSize of the file = %d bytes\nNumber of words = %d\n", p, q);

	// close the file
	close(file_pointer_status);

	// close the connection
	close(connect(socket_status , struct_socket &server_addr , sizeof(server_addr)));

	close(socket_status);
	return 0;
}