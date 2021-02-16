#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <string.h> 
#include <arpa/inet.h> 
#include <netinet/in.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
  
//define a maximum limit of size 
#define MAX_N 1024

//define a port number
#define PORT 6192  

int main() { 

    int sfc; 
    char buffer[MAX_N]; 
    char input_word[MAX_N];
    struct sockaddr_in server_addr, client_addr; 

    memset(&server_addr, 0, sizeof(server_addr)); 
    memset(&client_addr, 0, sizeof(client_addr)); 
      
    // Creating socket file descriptor 
    if ((sfc = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) { 
        perror("Error : Socket Creation Unsuccessful"); 
        exit(EXIT_FAILURE); 
    } 
      
    // Filling server information 
    server_addr.sin_family = AF_INET; // IPv4 
    server_addr.sin_addr.s_addr = INADDR_ANY; 
    server_addr.sin_port = htons(PORT); 
      
    // Binding socket with the server address 
    if (bind(sfc, (const struct sockaddr *) &server_addr,  sizeof(server_addr)) < 0) {
        perror("Error : Bind failed"); 
        exit(EXIT_FAILURE); 
    } 
    
    int val, n; 
  
    val = sizeof(client_addr);

    // Error message strings
    char *error1 = "FILE_NOT_FOUND";
    char *error2 = "WRONG_FILE_FORMAT";
    char *error3 = "NO_END_WORD";
    char *error4 = "END";

    printf("Server is running....\n\n");

    while (2) {
        n = recvfrom(sfc, (char *)buffer, MAX_N, MSG_WAITALL, (struct sockaddr *) &client_addr, &val); 
        buffer[n] = '\0'; 

        //buffer contains the name of the file now, check if file exists or not       
        printf("Searching for file...\n"); 
        FILE *fp = fopen(buffer,"r"); 

        if(fp == NULL) {
            //file does not exist
            printf("Error : File not Found\n\n");
            sendto(sfc, (const char *) error1, strlen(error1), MSG_CONFIRM, (const struct sockaddr *) &client_addr, val);     
            continue;
        }

        fscanf(fp, "%s", input_word);

        // First word is not HELLO

        if (strcmp(input_word, "HELLO") != 0) {
            sendto(sfc, (const char *) error2, strlen(error2), MSG_CONFIRM, (const struct sockaddr *) &client_addr, val); 
            printf("Error : Wrong File Format\nServer exiting\n");
            fclose(fp);
            exit(0);
        }

        // Sending HELLO

        sendto(sfc, (const char *) input_word, strlen(input_word), MSG_CONFIRM, (const struct sockaddr *) &client_addr, val); 

        for (int i = 1; ; ++i) {
            n = recvfrom(sfc, (char *) buffer, MAX_N, MSG_WAITALL, (struct sockaddr *) &client_addr, &val); 
            buffer[n] = '\0'; 

            printf("Client request : %s\n", buffer);

            char word[30];
            char num[30];
            strcpy(word,"WORD");
            sprintf(num,"%d",i);
            strcat(word,num);

            // File ended without END (extra case checking, may not be required)
            if(fscanf(fp,"%s",input_word) == EOF) {
                printf("Error : File does not end with 'END'\n\n");
                sendto(sfc, (const char *) error3, strlen(error3), MSG_CONFIRM, (const struct sockaddr *) &client_addr, val);
                break;
            }

            // next word == 'END'
            if(strcmp(input_word, "END")==0) {
                sendto(sfc, (const char *) error4, strlen(error4), MSG_CONFIRM, (const struct sockaddr *) &client_addr, val);
                break;
            }

            // Sending WORDi
            sendto(sfc, (const char *) input_word, strlen(input_word), MSG_CONFIRM, (const struct sockaddr *) &client_addr, val);
        }
        //close the file
        printf("\n");
        fclose(fp);
    }

    return 0; 
} 
