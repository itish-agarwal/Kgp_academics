#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <netdb.h>
#include <time.h>
#include <unistd.h>
#include <netinet/in.h>
#include <arpa/inet.h>

const int MAX_N = 1e4 + 7;
int MAX_CON = 5;

int last_time[6];
int last_time_status[6];
const int LIMIT = 600;

const char null = '\0';

void print_error(char *error_message ){
	perror(error_message );
	exit(0);
}

int max (int a, int b) {
	if (a > b) {
		return a;
	}
	return b;
}

void max_self(int* a, int b) {
	*a = max(*a, b);
}

int main(int argc,char *argv[]) {

	int tcp_server_sfd, port, k;
	if(argc < 2) {
		printf("Usage : ./a.out <port> <ip address>\n");
		exit(1);
	}
	
	struct sockaddr_in server_addr, client_addr;

	bzero((char *) &server_addr, sizeof(server_addr));
	bzero((char *) &client_addr, sizeof(client_addr));
	socklen_t client_len = sizeof(client_addr);

	int max_peers = 5;

	FILE *input_file = fopen(argv[1], "r");
	if (input_file == NULL) {
		printf("Input file doesn't exist!\n");
		exit(1);
	}
	fscanf(input_file, "%d\n", &max_peers);
	MAX_CON = max_peers;

	for(int i = 0; i < max_peers; ++i) {
		last_time[i] = time(NULL);
		last_time_status[i] = 0;
	}
	char peer_names[max_peers][MAX_N];
	struct sockaddr_in ip_addresses[max_peers];

	char ips[max_peers][100];

	int client_fd[max_peers];

	int client_rfd[max_peers];
	for(int i = 0; i < max_peers; ++i) {
		bzero((char *) &ip_addresses[i], sizeof(ip_addresses[i]));
	}

	int ports[max_peers];
	for (int i = 0; i < max_peers; ++i) {
		int user_port;
		char s[MAX_N], ip[MAX_N];
		fscanf(input_file, "%s", s);
		strcpy(peer_names[i], s);
		fscanf(input_file, "%s", ip);
		strcpy(ips[i], ip);
		fscanf(input_file, "%d", &user_port);
		ports[i] = user_port;
		ip_addresses[i].sin_port = htons(user_port);
	}

	tcp_server_sfd = socket(AF_INET, SOCK_STREAM, 0);
	if (tcp_server_sfd < 0){
		print_error (" ERROR : TCP socket creation failed\n");
	}

	char user_ip[100];
	int flag = 0;
	for (int i = 0; i < max_peers; ++i) {
		if (strcmp(argv[2], peer_names[i]) == 0) {
			flag = 1;
			port = ports[i];
			strcpy(user_ip, ips[i]);
		}
	}

	if (flag == 0) {
		printf("ERROR : Username not found!\n");
		exit(0);
	}

	printf("Port : %d\n", port);
	printf("IP : %s\n", user_ip);

	// Setting server address
	server_addr.sin_family = AF_INET;
	server_addr.sin_port = htons(port);
	server_addr.sin_addr.s_addr = INADDR_ANY;

	int status = bind(tcp_server_sfd, (struct sockaddr *)&server_addr, sizeof(server_addr));
	if(status < 0){
		close(tcp_server_sfd);
		perror("ERROR : TCP Binding failed");
	}

	// Listening to at maximum_file_descriptor MAX_N connections
	listen (tcp_server_sfd, MAX_CON); 			
	
	printf("\nChat application running ....\nUsage: friend_name/<message>\n\n\n");
	fd_set fdset;
	FD_ZERO(&fdset);
	struct hostent *host_name;
	host_name = gethostbyname(user_ip);

	for(int i = 0; i < MAX_CON ; i++) {
		client_fd[i]= -1;
		client_rfd[i]= -1;
		ip_addresses[i].sin_family = AF_INET;
		bcopy((char *)host_name->h_addr, (char *)&ip_addresses[i].sin_addr.s_addr, host_name->h_length);
	}

	
	int maximum_file_descriptor = 0;
	char input[MAX_N];
	int connections = 0;

	while(1) {


		FD_SET(0, &fdset);
		FD_SET(tcp_server_sfd, &fdset);
		maximum_file_descriptor = tcp_server_sfd;

		for(int i = 0; i < MAX_CON ; i++) {
			FD_SET(client_fd[i], &fdset);
			FD_SET(client_rfd[i], &fdset);

			max_self(&maximum_file_descriptor, client_fd[i]);
			max_self(&maximum_file_descriptor, client_rfd[i]);
		}

		maximum_file_descriptor++;				// Max file descriptor


		if(select(maximum_file_descriptor, &fdset, NULL, NULL, NULL)<=0) {
			perror("ERROR : Select failed!");
		}

		status = FD_ISSET(0, &fdset);
		if(status) {

			for(int l = 0; l < MAX_N; l++) {
				input[l] = null;			
			}

			int no_chars = read(0, input, sizeof(input));

			char client_name[MAX_N];

			k = 0;

			for(int i = 0; i < MAX_N; ++i) {
				if(input[i] == '/') {
					k = i;
					break;
				}
				client_name[i] = input[i];
			}
			client_name[k] = null;

			k++;

			char input_message[MAX_N];
			for(int i = k; i <MAX_N; i++) {
				input_message[i-k]=input[i];
			}

			int l = 0;
			while(input_message[l] != null) l++;
			l--;

			char sender[MAX_N];
			strcpy(sender, argv[2]);
			strcat(sender, " : ");
			strcat(sender, input_message);
			strcpy(input_message, sender);
			// printf("dfsd %s\n", sender);
			
			k = 0;

			while(k < max_peers && strcmp(client_name,peer_names[k])) {
				k++;
			}

			if(k == max_peers) {
				printf("Please enter a valid peer user :(\n\n");
				continue;
			}

			int offline = 0;

			if(client_fd[k] < 0) {

				client_fd[k] = socket(AF_INET, SOCK_STREAM, 0);
			    
			    if (client_fd[k] < 0) {
			        print_error("ERROR : Opening socket failed");
			    }
			    if (connect(client_fd[k],(struct sockaddr *) &ip_addresses[k],sizeof(ip_addresses[k])) < 0) {
			        printf("ERROR : Receiver seems to be offline\nPlease run the program again\n");
			        offline = 1;
			        exit(0);
			    }
			}
			if(offline) continue;

			int write_status = write(client_fd[k], input_message, strlen(input_message));
    		if (write_status < 0) {
    			print_error("ERROR : Writing to socket failed");  
			}
			last_time[k] = time(NULL);
			last_time_status[k] = 1;
		}
		
		for(int i = 0; i < max_peers; ++i) {
			if(time(NULL) - last_time[i] > LIMIT) {
				if(last_time_status[i]) {
					last_time_status[i] = 0;
					printf("%s timed out.\n", peer_names[i]);
					FD_CLR(client_fd[i], &fdset);
					close(client_fd[i]);
				}
			}
		}

		status = FD_ISSET(tcp_server_sfd, &fdset);

		if(status) {
			int use_fd = accept(tcp_server_sfd, (struct sockaddr *) &client_addr, &client_len );
			if(use_fd == -1 ) {
				perror("ERROR: Accept failed\n");
			}
			char s_ip[80]; 
      inet_ntop(AF_INET, &(client_addr.sin_addr), s_ip, 80);
			printf("Connection accepted from %s\n", s_ip);
			last_time[k] = time(NULL);
			last_time_status[k] = 1;
			client_rfd[connections++] = use_fd;
		}

		for (int i = 0; i < max_peers; i++) {
			status = FD_ISSET(client_rfd[i], &fdset);
			if (status) {
				char buffer[MAX_N];
				for (int i = 0; i < MAX_N; i++) buffer[i] = null;		
				int message = read(client_rfd[i], buffer, sizeof(buffer));
				if (message == 0) {
					last_time_status[i] = 0;
					FD_CLR(client_fd[i], &fdset);
					close(client_fd[i]);
					continue;
				}
				if (message < 0) perror("ERROR : Reading failed\n");
				printf("New message received from %s\n", buffer);
			}
		}
		// for(int i = 0; i < max_peers; ++i) {
		// 	if(time(NULL) - last_time[i] > LIMIT) {
		// 		printf("%s timed out.\n", peer_names[i]);
		// 		close(client_fd[i]);
		// 	}
		// }
	}
}
