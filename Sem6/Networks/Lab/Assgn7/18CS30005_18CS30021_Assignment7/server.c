// Include relevant header files
#include <stdio.h> 
#include <stdlib.h> 
#include <string.h> 
#include <signal.h> 
#include <arpa/inet.h> 
#include <errno.h> 
#include <netinet/in.h> 
#include <unistd.h> 
#include <netdb.h>    
#include <time.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/wait.h>
#include <sys/socket.h> 
#include <sys/types.h> 

#define PORT 6192 
#define MAXLEN 1024 
#define B 20

int main() {
    int sock_fd;
    char buffer[B];

    // Creating socket

    sock_fd = socket(AF_INET, SOCK_STREAM, 0); 

    if (sock_fd < 0){
        printf("Error : Socket creation failed\n");
        exit(0);
    }

    int enable_option = 1;
		setsockopt(sock_fd, SOL_SOCKET, SO_REUSEADDR, &enable_option, sizeof(enable_option));

		struct sockaddr_in client_addr;
    struct sockaddr_in server_addr;

    memset(&server_addr, 0, sizeof(server_addr)); 

    server_addr.sin_family = AF_INET; 
    server_addr.sin_addr.s_addr = htonl(INADDR_ANY); 
    server_addr.sin_port = htons(PORT); 
  
    // Binding sock_fd
    
    if (bind(sock_fd, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0){
        printf("Error : Bind failed\n");
        exit(0);
    }

    listen(sock_fd, 5); 

    printf("Server is running......\n\n");

		while (1) {

			socklen_t client_len = sizeof(client_addr);
			int new_sock_fd = accept(sock_fd, (struct sockaddr *) &client_addr, &client_len) ;

			// Acceptng new connection

			if (new_sock_fd < 0) {
				perror("Error : Could not accept new connection\n");
				exit(0); 
			}	

			// Receiving filename

			char fname[MAXLEN]; 
			int rec = recv(new_sock_fd, fname, MAXLEN, 0);

			// Opening file

			int fp = open(fname, O_RDONLY);

			// Checking if file exists

			if (fp < 0) {

				// Sending error code

				strcpy(buffer, "E");
				send(new_sock_fd, buffer, sizeof(buffer) , 0);
			}
			else {

				// Sending success code

				strcpy(buffer, "L");
				send(new_sock_fd, buffer, 1 , 0);

				// Finding size of file

				struct stat S;

				stat(fname, &S);
				int fsize = S.st_size;	

				// Sending file size

				send(new_sock_fd, &fsize, sizeof(fsize),0);
				int blocks = 0;

				// Sending file

				while ((rec = read(fp, buffer, B)) > 0) {
					++blocks;
					send(new_sock_fd, buffer, rec, 0);
				}

				// Printing results

				printf("Block size : %d\n", B);
				printf("File size : %d\n", fsize);
				printf("No of blocks is: %d\n", blocks);

				if (fsize%B == 0 && fsize != 0) {
					printf("Last block size : %d\n\n", B);
				}
				else {
					printf("Last block size : %d\n\n", fsize%B);
				}
			}

			// Closing file pointer
			close(fp);

			// Closing connection
			close(new_sock_fd);	
		}
		return 0;	
} 