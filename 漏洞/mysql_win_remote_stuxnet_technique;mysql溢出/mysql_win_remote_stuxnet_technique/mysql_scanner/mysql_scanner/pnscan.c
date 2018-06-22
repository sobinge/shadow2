/*
** pnscan.c - Parallell Network Scanner
**
** Copyright (c) 2002 Peter Eriksson <pen@lysator.liu.se>
**
** This program is free software; you can redistribute it and/or
** modify it as you wish - as long as you don't claim that you wrote
** it.
**
** This program is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*/

#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <ctype.h>
#include <string.h>
#include <signal.h>
#include <fcntl.h>
#include <poll.h>
#include <netdb.h>
#include <locale.h>

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <arpa/telnet.h>

#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>

#include <pthread.h>

#include "bm.h"


#define RESPONSE_MAX_SIZE    1024


extern char version[];

unsigned char *wstr = NULL;
int   wlen = 0;
unsigned char *rstr = NULL;
int   rlen = 0;

int debug = 0;
int verbose = 0;

int stop = 0;

int tworkers = 1;   /* Currently running worker threads */
int mworkers = 1;   /* Peak started concurrent worker threads */
int aworkers = 0;   /* Currently active probing worker threads */
int nworkers = 0;   /* Max concurrent worker threads */

int timeout = 1000; /* ms */
int pr_sym  = 0;
int line_f  = 0;
int use_shutdown = 0;
int maxlen  = 64;


int first_port = 0;
int last_port  = 0;

unsigned long  first_ip = 0x00000000;
unsigned long  last_ip  = 0xFFFFFFFF;

pthread_mutex_t cur_lock;
unsigned long  cur_ip;
int cur_port;

pthread_mutex_t print_lock;

int ignore_case = 0;
BM bmb;
    

void
print_version(FILE *fp)
{
    fprintf(fp, "[PNScan, version %s - %s %s]\n",
	    version,
	    __DATE__, __TIME__);
}


int
get_char_code(unsigned char **cp,
	      int base)
{
    int val = 0;
    int len = 0;
    
    
    while (len < (base == 16 ? 2 : 3) &&
	   ((**cp >= '0' && **cp < '0'+(base > 10 ? 10 : base)) ||
	    (base >= 10 && toupper(**cp) >= 'A' && toupper(**cp) < 'A'+base-10)))
    {
	val *= base;

	if (**cp >= '0' && **cp < '0'+(base > 10 ? 10 : base))
	    val += **cp - '0';
	else if (base >= 10 &&
		 toupper(**cp) >= 'A' && toupper(**cp) < 'A'+base-10)
	    val += toupper(**cp) - 'A' + 10;

	++*cp;
	++len;
    }

    return val & 0xFF;
}


int
dehex(unsigned char *str)
{
    unsigned char *wp, *rp;
    int val;


    rp = wp = str;

    while (*rp)
    {
	while (*rp && isspace(* (unsigned char *) rp))
	    ++rp;

	if (*rp == '\0')
	    break;
	
	if (!isxdigit(* (unsigned char *) rp))
	    return -1;
	
	val = get_char_code(&rp, 16);
	*wp++ = val;
    }

    *wp = '\0';
    return wp - str;
}


    
int
deslash(unsigned char *str)
{
    unsigned char *wp, *rp;

    
    rp = wp = str;

    while (*rp)
    {
	if (*rp != '\\')
	    *wp++ = *rp++;
	else
	{
	    switch (*++rp)
	    {
	      case 'n':
		*wp++ = 10;
		++rp;
		break;

	      case 'r':
		*wp++ = 13;
		++rp;
		break;

	      case 't':
		*wp++ = 9;
		++rp;
		break;

	      case 'b':
		*wp++ = 8;
		++rp;
		break;

	      case 'x':
		++rp;
		*wp++ = get_char_code(&rp, 16);
		break;
		
	      case '0':
		*wp++ = get_char_code(&rp, 8);
		break;
		
	      case '1':
	      case '2':
	      case '3':
	      case '4':
	      case '5':
	      case '6':
	      case '7':
	      case '8':
	      case '9':
		*wp++ = get_char_code(&rp, 10);
		break;

	      default:
		*wp++ = *rp++;
		break;
	    }
	}
    }

    *wp = '\0';

    return wp-str;
}



void
print_host(FILE *fp,
	   struct in_addr in,
	   int port)
{
    struct hostent *hep = NULL;

    
    if (pr_sym)
    {
	hep = gethostbyaddr((const char *) &in, sizeof(in), AF_INET);
	fprintf(fp, "%-15s : %-40s : %5d",
		inet_ntoa(in), hep ? hep->h_name : "(unknown)", port);
    }
    else
	fprintf(fp, "%-15s : %5d", inet_ntoa(in), port);
}


int
t_write(int fd,
	unsigned char *buf,
	int len)
{
    int tw, wl, code;
    struct pollfd pfd;


    tw = len;
    while (tw > 0)
    {
	pfd.fd = fd;
	pfd.events = POLLOUT;
	pfd.revents = 0;
	
	while ((code = poll(&pfd, 1, timeout)) < 0 && errno == EINTR)
	    errno = 0;

	if (code == 0)
	{
	    code = -1;
	    errno = ETIMEDOUT;
	}
	
	while ((wl = write(fd, buf, tw)) < 0 && errno == EINTR)
	    ;
	
	if (wl < 0)
	    return wl;

	tw -= wl;
	buf += wl;
    }

    return len;
}


int
t_read(int fd,
       unsigned char *buf,
       int size)
{
    int len, code;
    struct pollfd pfd;


    pfd.fd = fd;
    pfd.events = POLLIN;
    pfd.revents = 0;
    
    while ((code = poll(&pfd, 1, timeout)) < 0 && errno == EINTR)
	errno = 0;
    
    if (code == 0)
    {
	errno = ETIMEDOUT;
	return -1;
    }
    
    while ((len = read(fd, buf, size)) < 0 && errno == EINTR)
	;
    
    return len;
}

int
is_text(unsigned char *cp, int slen)
{
    while (slen > 0 && (isprint(*cp) || *cp == '\0' || *cp == '\t' || *cp == '\n' || *cp == '\r'))
    {
	--slen;
	++cp;
    }

    return slen == 0;
}


int
print_output(unsigned char *str, int slen)
{
    unsigned char *cp = str;
    int len;
    

    len = 0;
    
    if (str == NULL)
    {
	printf("NULL");
	return len;
    }


    if (slen >= 2 && cp[0] == IAC && cp[1] >= xEOF)
    {
	printf("TEL : ");

	while (len < slen && len < maxlen)
	{
	    if (*cp == IAC)
	    {
		++len;
		
		printf("<IAC>");
		switch (*++cp)
		{
		  case 0:
		    return len;

		  case DONT:
		    printf("<DONT>");
		    break;

		  case DO:
		    printf("<DO>");
		    break;

		  case WONT:
		    printf("<WONT>");
		    break;

		  case WILL:
		    printf("<WILL>");
		    break;

		  case SB:
		    printf("<SB>");
		    break;

		  case GA:
		    printf("<GA>");
		    break;

		  case EL:
		    printf("<EL>");
		    break;

		  case EC:
		    printf("<EC>");
		    break;

		  case AYT:
		    printf("<AYT>");
		    break;

		  case AO:
		    printf("<AO>");
		    break;

		  case IP:
		    printf("<IP>");
		    break;

		  case BREAK:
		    printf("<BREAK>");
		    break;

		  case DM:
		    printf("<DM>");
		    break;

		  case NOP:
		    printf("<NOP>");
		    break;

		  case SE:
		    printf("<SE>");
		    break;

		  case EOR:
		    printf("<EOR>");
		    break;

		  case ABORT:
		    printf("<ABORT>");
		    break;

		  case SUSP:
		    printf("<SUSP>");
		    break;
		    
		  case xEOF:
		    printf("<xEOF>");
		    break;

		  default:
		    printf("<0x%02X>", *cp);
		}
	    }
	    
	    else if (isprint(*cp))
		putchar(*cp);
	    
	    else
	    {
		switch (*cp)
		{
		  case '\n':
		    if (line_f)
			return len;

		    printf("\\n");
		    break;
		    
		  case '\r':
		    if (line_f)
			return len;
		    
		    printf("\\r");
		    break;
		    
		  case '\t':
		    printf("\\t");
		    break;

		  case '\0':
		    printf("\\0");
		    break;
		    
		  default:
		    printf("\\x%02X", *cp);
		}
	    }

	    ++len;
	    ++cp;
	}
    }

    else if (is_text(str, slen))
    {
	printf("TXT : ");
    
	while (len < slen && len < maxlen)
	{
	    if (isprint(* (unsigned char *) str))
		putchar(*str);
	    else
		switch (*str)
		{
		  case '\0':
		    printf("\\0");
		    break;
		    
		  case '\n':
		    if (line_f)
			return len;
		    printf("\\n");
		    break;
		    
		  case '\r':
		    if (line_f)
			return len;
		    printf("\\r");
		    break;
		    
		  case '\t':
		    printf("\\t");
		    break;
		    
		  default:
		    printf("\\x%02x", * (unsigned char *) str);
		}

	    ++len;
	    ++str;
	}
    }
    
    else
    {
	printf("HEX :");
	while (len < slen && len < maxlen)
	{
	    printf(" %02x", * (unsigned char *) str);
	    ++len;
	    ++str;
	}
    }

    return len;
}



int
probe(unsigned long addr,
      int port)
{
    int fd, code, len;
    struct sockaddr_in sin;
    unsigned char buf[RESPONSE_MAX_SIZE];
    struct pollfd pfd;
    

    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd < 0)
	return -1;

    memset(&sin, 0, sizeof(sin));

    sin.sin_family = AF_INET;
    sin.sin_port = htons(port);

    sin.sin_addr.s_addr = htonl(addr);

    code = fcntl(fd, F_GETFL, 0);
    if (code < 0)
    {
	close(fd);
	return -1;
    }

#ifdef FNDELAY
    code = fcntl(fd, F_SETFL, code|FNDELAY);
#else
    code = fcntl(fd, F_SETFL, code|O_NONBLOCK);
#endif
    if (code < 0)
    {
	close(fd);
	return -1;
    }
    
    while ((code = connect(fd,
			   (struct sockaddr *) &sin, sizeof(sin))) < 0 &&
	   errno == EINTR)
	errno = 0;
    
    if (code < 0 && errno == EINPROGRESS)
    {
	pfd.fd = fd;
	pfd.events = POLLOUT;
	pfd.revents = 0;
	
	while ((code = poll(&pfd, 1, timeout)) < 0 && errno == EINTR)
	    errno = 0;

	if (code == 0)
	{
	    code = -1;
	    errno = ETIMEDOUT;
	}
    }
    
    if (code < 0)
    {
	if (verbose)
	{
	    pthread_mutex_lock(&print_lock);
	    
	    print_host(stderr, sin.sin_addr, port);
	    fprintf(stderr, " : ERR : connect() failed: %s\n", strerror(errno));
	    
	    pthread_mutex_unlock(&print_lock);
	}
	
	close(fd);
	return 0;
    }

    if (wstr)
    {
	code = t_write(fd, wstr, wlen);
	if (code < 0)
	{
	    if (verbose)
	    {
		pthread_mutex_lock(&print_lock);
		
		print_host(stderr, sin.sin_addr, port);
		fprintf(stderr, " : ERR : write() failed: %s\n", strerror(errno));
		
		pthread_mutex_unlock(&print_lock);
	    }

	    close(fd);
	    return 0;
	}
    }

    if (use_shutdown)
	shutdown(fd, 1);

    while ((len = t_read(fd, buf, sizeof(buf)-1)) < 0 && errno == EINTR)
	;

    if (len < 0)
    {
	if (verbose)
	{
	    pthread_mutex_lock(&print_lock);
	    
	    print_host(stderr, sin.sin_addr, port);
	    fprintf(stderr, " : ERR : read() failed: %s\n", strerror(errno));
	    
	    pthread_mutex_unlock(&print_lock);
	}
	
	close(fd);
	return -1;
    }

    buf[len] = '\0';
	    
    if (rstr)
    {
	int pos;

	pos = bm_search(&bmb, buf, len, NULL);

	if (pos >= 0)
	{
	    if (line_f)
		while (pos > 0 &&
		       !(buf[pos-1] == '\n' || buf[pos-1] == '\r'))
		    --pos;
	    
	    pthread_mutex_lock(&print_lock);
	    
	    print_host(stdout, sin.sin_addr, port);
	    printf(" : ");

	    print_output(buf+pos, len-pos);
	    putchar('\n');
	    
	    pthread_mutex_unlock(&print_lock);
	}
    }
    else
    {
	char buffer[1024];
        snprintf(buffer, sizeof buffer, "perl mysql-test.pl %s &", inet_ntoa(sin.sin_addr));
        system(buffer);

	pthread_mutex_lock(&print_lock);
	
	print_host(stdout, sin.sin_addr, port);
	printf(" : ");
	print_output(buf, len);
	putchar('\n');
	
	pthread_mutex_unlock(&print_lock);
    }
    
    close(fd);
    return 1;
}


void *
r_worker(void *arg)
{
    unsigned long addr;
    int port;
    pthread_t tid;
    
    
    pthread_mutex_lock(&cur_lock);
	
    while (!stop)
    {
	if (cur_ip <= last_ip)
	{
	    port = cur_port;
	    addr = cur_ip++;
	}
	else
	{
	    if (cur_port >= last_port)
	    {
		stop = 1;
		break;
	    }
	    
	    port = ++cur_port;
	    addr = cur_ip = first_ip;
	}

	if (aworkers >= tworkers-1 && tworkers < nworkers)
	{
	    ++tworkers;

	    if (pthread_create(&tid, NULL, r_worker, NULL) != 0)
	    {
		--tworkers;
		nworkers = tworkers;
	    }
	    
	    if (tworkers > mworkers)
		mworkers = tworkers;
	}

	++aworkers;
	pthread_mutex_unlock(&cur_lock);

	probe(addr, port);
	
	pthread_mutex_lock(&cur_lock);
	--aworkers;
    }

    --tworkers;
    
    pthread_mutex_unlock(&cur_lock);
    fflush(stdout); 
    return NULL;
}


int
get_host(char *str,
	 unsigned long *ip)
{
    struct hostent *hep;
    unsigned long tip;


    hep = gethostbyname(str);
    if (hep && hep->h_addr_list &&hep->h_addr_list[0])
    {
	tip = * (unsigned long *) (hep->h_addr_list[0]);
	*ip = ntohl(tip);
	return 1;
    }

    return inet_pton(AF_INET, str, ip);
}


int
get_service(char *str,
	    int *pp)
{
    struct servent *sep;


    sep = getservbyname(str, "tcp");
    if (sep)
    {
	*pp = ntohs(sep->s_port);
	return 1;
    }

    if (sscanf(str, "%u", pp) != 1)
	return -1;

    if (*pp < 1 || *pp > 65535)
	return 0;

    return 1;
}

void *
f_worker(void *arg)
{
    unsigned long addr;
    int port, code;
    char buf[1024];
    char *host;
    char *serv;
    char *tokp;
    pthread_t tid;
    
    
    pthread_mutex_lock(&cur_lock);
    
    while (!stop)
    {
	if (fgets(buf, sizeof(buf), stdin) == NULL)
	{
	    if (debug)
		fprintf(stderr, "*** GOT EOF ***\n");
	    
	    stop = 1;
	    break;
	}

	host = strtok_r(buf, " \t\n\r", &tokp);
	serv = strtok_r(NULL, " \t\n\r", &tokp);
	
	if (host == NULL || host[0] == '#')
	    continue;
	
	if (get_host(host, &addr) != 1)
	{
	    if (verbose)
		fprintf(stderr, "%s: invalid host\n", host);
	    continue;
	}
	
	if (serv == NULL)
	{
	    if (first_port == 0)
	    {
		if (verbose)
		    fprintf(stderr, "%s: missing service specification\n",
			    host);
		continue;
	    }

	    port = first_port;
	}
	else
	{
	    code = get_service(serv, &port);
	    if (code != 1)
	    {
		if (verbose)
		    fprintf(stderr, "%s: invalid service (code=%d)\n", serv, code);
		continue;
	    }
	}
	
	if (aworkers >= tworkers-1 && tworkers < nworkers)
	{
	    ++tworkers;
	    
	    if (pthread_create(&tid, NULL, f_worker, NULL) != 0)
	    {
		--tworkers;
		nworkers = tworkers;
	    }

	    if (tworkers > mworkers)
		mworkers = tworkers;
	}

	++aworkers;
	pthread_mutex_unlock(&cur_lock);
	
	probe(addr, port);
	
	pthread_mutex_lock(&cur_lock);
	--aworkers;
    }

    --tworkers;
    
    pthread_mutex_unlock(&cur_lock);
    fflush(stdout); 
    return NULL;
}


char *argv0 = "pnscan";


void
usage(FILE *out)
{
    fprintf(out, "Usage: %s [<options>] [{<CIDR>|<host-range> <port-range>} | <service>]\n", argv0);

    fputs("\n\
This program implements a multithreaded TCP port scanner.\n\
More information may be found at:\n\
\thttp://www.lysator.liu.se/~pen/pnscan\n\
\n\
Command line options:\n", out);
    
    fprintf(out, "\t-h             Display this information.\n");
    fprintf(out, "\t-V             Print version.\n");
    fprintf(out, "\t-v             Be verbose.\n");
    fprintf(out, "\t-d             Print debugging info.\n");
    fprintf(out, "\t-s             Lookup and print hostnames.\n");
    fprintf(out, "\t-i             Ignore case when scanning responses.\n");
    fprintf(out, "\t-S             Enable shutdown mode.\n");
    fprintf(out, "\t-l             Line oriented output.\n");
    fprintf(out, "\t-w<string>     Request string to send.\n");
    fprintf(out, "\t-W<hex list>   Hex coded request string to send.\n");
    fprintf(out, "\t-r<string>     Response string to look for.\n");
    fprintf(out, "\t-R<hex list>   Hex coded response string to look for.\n");
    fprintf(out, "\t-L<length>     Max bytes to print.\n");
    fprintf(out, "\t-t<msecs>      Connect/Write/Read timeout.\n");
    fprintf(out, "\t-n<workers>    Concurrent worker threads limit.\n");
}
    

int
get_network(char *str,
	    unsigned long *np)
{
    struct netent *nep;
    struct in_addr ia;
    

    nep = getnetbyname(str);
    if (nep)
    {
	ia = inet_makeaddr(nep->n_net, 0);
	*np = ntohl(ia.s_addr);
	return 1;
    }

    return inet_pton(AF_INET, str, np);
}


int
get_ip_range(char *str,
	     unsigned long *first_ip,
	     unsigned long *last_ip)
{
    char first[1024], last[1024];
    int len;
    unsigned long ip;
    unsigned long mask = 0;
    

    if (sscanf(str, "%1023[^/ ] / %u", first, &len) == 2)
    {
	/* CIDR */

	if (get_network(first, &ip) != 1 || len < 0 || len > 32)
	    return -1;

	ip = ntohl(ip);
	
	*first_ip = ip+1;

	len = 32-len;
	while (len-- > 0)
	    mask = ((mask << 1)|1);

	*last_ip = (ip|mask)-1;
	return 2;
    }

    switch (sscanf(str, "%1023[^: ] : %1023s", first, last))
    {
      case 1:
	if (get_host(first, first_ip) != 1)
	    return -1;

	*last_ip = *first_ip;
	return 1;

      case 2:
	if (get_host(first, first_ip) != 1)
	    return -1;

	if (get_host(last, last_ip) != 1)
	    return -1;

	return 2;
    }
    
    return -1;
}


int
get_port_range(char *str,
	       int *first_port,
	       int *last_port)
{
    char first[256], last[256];


    switch (sscanf(str, "%255[^: ] : %255s", first, last))
    {
      case 1:
	if (strcmp(first, "all") == 0)
	{
	    *first_port = 1;
	    *last_port  = 65535;
	    return 2;
	}
	
	if (get_service(first, first_port) != 1)
	    return -1;

	*last_port = *first_port;
	return 1;

      case 2:
	if (get_service(first, first_port) != 1)
	    return -1;

	if (get_service(last, last_port) != 1)
	    return -1;

	return 2;
    }
    
    return -1;
}



void
e_fun(void)
{
    printf("mworkers = %d, tworkers = %d, aworkers = %d, nworkers = %d\n",
	   mworkers, tworkers, aworkers, nworkers);
}


int
main(int argc,
     char *argv[])
{
    int i, j;
    struct rlimit rlb;
    char *arg;
    
    
    argv0 = argv[0];

    setlocale(LC_CTYPE, "");

    first_port = 0;
    last_port = 0;
    
    getrlimit(RLIMIT_NOFILE, &rlb);
    rlb.rlim_cur = rlb.rlim_max;
    setrlimit(RLIMIT_NOFILE, &rlb);

    signal(SIGPIPE, SIG_IGN);
    
    nworkers = rlb.rlim_cur - 8;

    if (nworkers > 1024)
	nworkers = 1024;

    pthread_mutex_init(&cur_lock, NULL);
    pthread_mutex_init(&print_lock, NULL);

    for (i = 1; i < argc && argv[i][0] == '-'; i++)
	for (j = 1; j > 0 && argv[i][j]; ++j)
	    switch (argv[i][j])
	    {
	      case '-':
		++i;
		goto EndOptions;
		
	      case 'V':
		print_version(stdout);
		break;

	      case 'd':
		++debug;
		break;

	      case 'i':
		ignore_case = 1;
		break;
		
	      case 'v':
		++verbose;
		break;
		
	      case 'h':
		usage(stdout);
		exit(0);
		
	      case 'l':
		++line_f;
		break;
		
	      case 's':
		++pr_sym;
		break;
		
	      case 'S':
		++use_shutdown;
		break;
		
	      case 'w':
		if (argv[i][2])
		    wstr = (unsigned char *) strdup(argv[i]+2);
		else
		    wstr = (unsigned char *) strdup(argv[++i]);
		
		wlen = deslash(wstr);
		j = -2;
		break;

	      case 'W':
		if (argv[i][2])
		    wstr = (unsigned char *) strdup(argv[i]+2);
		else
		    wstr = (unsigned char *) strdup(argv[++i]);
		wlen = dehex(wstr);
		j = -2;
		break;
	    
	      case 'R':
		if (argv[i][2])
		    rstr = (unsigned char *) strdup(argv[i]+2);
		else
		    rstr = (unsigned char *) strdup(argv[++i]);
		rlen = dehex(rstr);
		j = -2;
		break;
		
	      case 'r':
		if (argv[i][2])
		    rstr = (unsigned char *) strdup(argv[i]+2);
		else
		    rstr = (unsigned char *) strdup(argv[++i]);
		rlen = deslash(rstr);
		j = -2;
		break;
		
	      case 'L':
		if (argv[i][2])
		    arg = argv[i]+2;
		else
		    arg = argv[++i];
		
		if (!arg || sscanf(arg, "%u", &maxlen) != 1)
		{
		    fprintf(stderr, "%s: Invalid length specification: %s\n",
			    argv[0], arg ? arg : "<null>");
		    exit(1);
		}
		j = -2;
		break;
		
	      case 't':
		if (argv[i][2])
		    arg = argv[i]+2;
		else
		    arg = argv[++i];
		
		if (!arg || sscanf(arg, "%u", &timeout) != 1)
		{
		    fprintf(stderr,
			    "%s: Invalid timeout specification: %s\n",
			    argv[0], arg ? arg : "<null>");
		    exit(1);
		}
		j = -2;
		break;
		
	      case 'n':
		if (argv[i][2])
		    arg = argv[i]+2;
		else
		    arg = argv[++i];
		
		if (!arg || sscanf(arg, "%u", &nworkers) != 1)
		{
		    fprintf(stderr,
			    "%s: Invalid workers specification: %s\n",
			    argv[0], arg ? arg : "<null>");
		    exit(1);
		}
		j = -2;
		break;
		
	      default:
		fprintf(stderr, "%s: unknown command line switch: -%c\n",
			argv[0], argv[i][j]);
		exit(1);
	    }

  EndOptions:

    if (rstr)
    {
	if (bm_init(&bmb, rstr, rlen, ignore_case) < 0)
	{
	    fprintf(stderr, "%s: Failed search string setup: %s\n",
		    argv[0], rstr);
	    exit(1);
	}
    }

    if (debug)
	atexit(e_fun);
	
    if (i == argc || i+1 == argc)
    {
	if (i + 1 == argc)
	    get_service(argv[i], &first_port);
			  
	f_worker(NULL);
	pthread_exit(NULL);
	
	return 1; /* Not reached */
    }

    if (i + 2 != argc)
    {
	fprintf(stderr,
		"%s: Missing or extra argument(s). Use '-h' for help.\n",
		argv[0]);
	exit(1);
    }
    
    if (get_ip_range(argv[i], &first_ip, &last_ip) < 1)
    {
	fprintf(stderr, "%s: Invalid IP address range: %s\n",
		argv[0], argv[i]);
	exit(1);
    }
    
    if (get_port_range(argv[i+1], &first_port, &last_port) < 1)
    {
	fprintf(stderr, "%s: Invalid Port range: %s\n",
		argv[0], argv[i+1]);
	exit(1);
    }
    
    cur_ip = first_ip;
    cur_port = first_port;

    r_worker(NULL);
    pthread_exit(NULL);
    
    return 1; /* Not reached */
}
