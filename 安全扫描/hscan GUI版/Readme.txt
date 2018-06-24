HScan v1.20 使用说明

1.系统要求: Windows NT/2000/XP

2.软件简介:

     多线程方式对指定IP段(指定主机),或主机列表进行检测.GUI和命令行两种方式.
     扫描项目: 
        -name      ---     获取主机名;
	-port      ---     默认端口扫描;
        -ftp       ---     FTP Banner,匿名用户,弱口令账号扫描; 
        -ssh       ---     SSH Banner扫描;
        -telnet    ---     TELNET Banner,弱口令账号扫描;
        -smtp      ---     SMTP Banner,匿名用户,弱口令账号扫描; 
        -finger    ---     FINGER漏洞(SunOS/Solaris 用户列表扫描);
        -iis       ---     IIS漏洞扫描;
        -cgi       ---     Unix/NT cgi漏洞扫描;
        -pop       ---     POP3 Banner,弱口令账号扫描;
        -rpc       ---     RPC漏洞扫描;
        -ipc       ---     Windows NT/2000用户列表获取,弱口令账号扫描;
        -imap      ---     IMAP Banner,弱口令账号扫描;
        -mssql     ---     MSSQL弱口令账号扫描;
        -mysql     ---     MYSQL Version,弱口令账号扫描;
        -cisco     ---     CISCO弱口令扫描;
        -plugin    ---     PLUGIN扫描;
        -all       ---     检测以上所有项目;

     其它选项:
        -max  <maxthread,maxhost>  指定最大线程数目,并发主机数目,默认为120,40;
        -time <Timed Out>          指定TCP连接超时毫秒数,默认为10000;
        -sleep <sleeptime>         指定ftp/pop/imap/telnet探测的线程开启间隔,默认为200毫秒;
        -ping                      扫描主机前ping主机

     生成报告:
        -report  用于生成扫描报告;
     
     按F8键中断扫描.

3.更新历史:

     HScan v1.20      <Mar 05,2003>  修正IPC扫描误报的错误.

     HScan v1.20Beta  <Feb 18,2003>  IPC扫描增加利用sid列举用户名,优化ftp/pop/imap/telnet探测,
                                     加入了扫描前ping检查,修改了GUI界面.

     HScan v1.01      <Jan 02,2003>  修正了一个大量占用系统资源的bug.

     HScan v1.00      <Dec 31,2002>  增加RPC扫描选项,增加telnet弱口令探测,MYSQL Version扫描.

     HScan v0.70      <Dec 06,2002>  增加PLUGIN扫描选项,修正-all选项时探测IMAP/FTP/POP弱口令误报的错误.					         

     HScan v0.50      <Nov 21,2002>  增加获取主机名,Telnet扫描选项,调整了线程设置,加入了利用					         
                                     ipc用户名列表探测Microsoft FTP弱口令的功能.

     HScan v0.30      <Nov 14,2002>  增加了SSH扫描功能,加入了利用SunOS/Solaris finger获取用户名列表，
			             并探测ftp/pop3/imap的功能.

     HScan v0.20      <Nov 01,2002>  内部测试版.

____________________________________________________
by uhhuhy <Mar 05,2003>
http://www.cnhonker.com, http://www.cnhonker.net
uhhuhy@21cn.com, uhhuhy@cnhonker.net
personal-page: http://uhhuh.myetang.com
____________________________________________________
