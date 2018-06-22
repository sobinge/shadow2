/*
    rootexec.c, simple program which using seteuid/uid() and let you 
    to exec commands as root, but first suid this ...

                                     (code by izik, izik@hwa-security.net) 
*/

#include <stdio.h>
#include <unistd.h>
#include <string.h>

/* max line length */
#ifndef _MAXLINE
  #define _MAXLINE 1024 
#endif

int main(argc,argv)
   int argc;
   char **argv;
{
   char line[_MAXLINE];
   int i;

   /* euid */
   if (geteuid() != 0) 
     seteuid(0);

   /* uid */
   if (getuid() != 0) 
     setuid(0);

   /* gid */
   if (getgid() != 0) 
     setgid(0);

   /* egid */
   if (getegid() != 0) 
     setegid(0);

    /* check euid */
    if (geteuid() < 0 || geteuid() > 0) {
      printf("%s: can't access root files\n", argv[0]);
    }

    /* check uid */
    if (getuid() < 0 || getuid() > 0) {
      printf("%s: can't exec root commands\n", argv[0]);
    }

    /* faliure ? */
    if ((getuid() < 0 || getuid() > 0) && (geteuid() < 0 || geteuid() > 0)) {
      printf("%s: not suid, as root do: chmod +s %s\n", argv[0], argv[0]);
      exit(-1);
    }
    
    /* usage */
    if (argc < 2) {
      printf("rootexec.c, code by izik [izik@hwa-security.net]\n");
      printf("usage: %s <command>\n", argv[0]);
      return -1;
    }

    /* push argv[] into line */
    strcpy(line, argv[1]);

    /* loop for the rest argv's */
    for (i = 2; i < argc; i++) { 
       strcat(line, " ");
       strcat(line,argv[i]); 
    }

    /* execute it */
    return (execl("/bin/sh", "sh" , "-c" , line, 0x0));
}
