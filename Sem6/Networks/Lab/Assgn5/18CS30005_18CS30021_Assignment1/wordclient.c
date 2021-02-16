// Client side implementation of UDP client-server model 
#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#include <string.h> 
#include <sys/types.h> 
#include <sys/socket.h> 
#include <arpa/inet.h> 
#include <netinet/in.h> 

#define PORT 6192
#define MAX_N 1024 

// Driver code 
int main() { 
    int sockfd; 
    char buffer[MAX_N]; 
    char file_name[300];
    printf("Enter name of file: ");
    scanf("%s", file_name); 
    struct sockaddr_in   servaddr; 

    // Creating socket file descriptor 
    if ( (sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) { 
        perror("Socket creation failed"); 
        exit(EXIT_FAILURE); 
    } 

    memset(&servaddr, 0, sizeof(servaddr)); 
    
    // Filling server information 
    servaddr.sin_family = AF_INET; 
    servaddr.sin_port = htons(PORT); 
    servaddr.sin_addr.s_addr = INADDR_ANY; 
    
    int n, len; 
    
    sendto(sockfd, (const char *)file_name, strlen(file_name), 
        MSG_CONFIRM, (const struct sockaddr *) &servaddr, 
            sizeof(servaddr)); 
    printf("Server is checking if file exists...\n\n"); 
        
    n = recvfrom(sockfd, (char *)buffer, MAX_N, 
                MSG_WAITALL, (struct sockaddr *) &servaddr, 
                &len); 
    buffer[n] = '\0'; 
    // printf("Server : %s\n", buffer); 

    //check if file exists by comparing the message received from server
    if(!strcmp(buffer, "FILE_NOT_FOUND")) {
        //if the file is not found by the server, print error message and exit the client
        printf("File Not Found\n");
        exit(0);
    }

    //check if first word of the file is not HELLO
    if(!strcmp(buffer, "WRONG_FILE_FORMAT")) {
        printf("Wrong File Format\n");
        printf("(First word may not be 'HELLO')\n");
        exit(0);
    }

    // printf("Server : %s\n", buffer);

    printf("HELLO from server:)\n");
    FILE* output_file = fopen("output.txt", "w");

    //now request the words
    int i = 1;
    while(1) {
        char word[] = "WORD";
        char number[100];
        sprintf(number, "%d", i); //converts number i into string and stores string in number
        strcat(word, number); //cancatenates two strings

        printf("Asking for %s...\n", word);


        sendto(sockfd, (const char *)word,strlen(word),MSG_CONFIRM,(const struct sockaddr *) &servaddr,sizeof(servaddr)); 
        n = recvfrom(sockfd, (char *)buffer,MAX_N,MSG_WAITALL,(struct sockaddr *)&servaddr,&len); 
        buffer[n]='\0';
        //buffer now contains the required word

        printf("Server response : %s\n", buffer);
        
        //check if we have reached the end of file but there is no END word
        if(!strcmp(buffer,"NO_END_WORD")) {
            printf("Error: No END word found at the end\n");
            fclose(output_file);
            break;
        }

        //check if word received is END
        if(!strcmp(buffer, "END")) {
            printf("Exiting the client.....\n\n");
            fclose(output_file);
            break;
        }
        fprintf(output_file, "%s\n", buffer);
        ++i;
    }

    close(sockfd); 
    return 0; 
}