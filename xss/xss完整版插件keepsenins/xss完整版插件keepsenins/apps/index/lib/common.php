<?php
/*
 * 项目共同文件   配置   函数 
 * 
 */
/**
 *@desc  126单网站转换  需要 去 126.am  申请key (无需审核)
 *@param url 长地址   key  用户的key
 */
 function  url_to_baidu($url){
 	
$ch=curl_init();
curl_setopt($ch,CURLOPT_URL,"http://dwz.cn/create.php");
curl_setopt($ch,CURLOPT_POST,true);
curl_setopt($ch,CURLOPT_RETURNTRANSFER,true);
   //$data1="http://iis678.duapp.com/?u=73f4b0";
$data=array('url'=>$url);
curl_setopt($ch,CURLOPT_POSTFIELDS,$data);
$strRes=curl_exec($ch);
curl_close($ch);
$arrResponse=json_decode($strRes,true);
if($arrResponse['status']==0)
{
/**错误处理*/
return iconv('UTF-8','GBK',$arrResponse['err_msg'])."\n";
}
/** tinyurl */
echo $arrResponse['tinyurl']."\n";
  
 	 
 } 

 
function  url_to_126($url){
 	
 
   $data="longUrl=$url&key=9e64dfad4e8141cfb6a71760dd76cfb9";  //key替换自己的key
  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, "http://126.am/api!shorten.action");
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
  curl_setopt($ch, CURLOPT_HEADER, 0);
  curl_setopt($ch, CURLOPT_POST, 1);
  curl_setopt($ch, CURLOPT_POSTFIELDS, $data);
  $res=json_decode(curl_exec($ch));
  if($res->status_txt == 'OK'){
  	url_to_baidu($res->url);
  	//return  $res->url;
  	
  }

 	 
 } 


 
 /*
* 后台系统提示函数
*/ 
function cpmsg($message,$type="success",$url="-1",$time=666,$title="系统信息"){
 
	
$color= ($type == 'success') ? "green" : "red";
$message="<font color=$color > $message </font>";
if($url == "-1"){
	
	$jsaction= "history.go(-1);";
	$url="javascript:history.go(-1);"; 
	}
	else{
		
		
		$jsaction="window.location.href ='$url';" ;
		
	}

    $style=PUBLIC_STYLE_URL."oa.css";
print<<<END
<script> setTimeout("$jsaction",$time); </script>
END;
}

function cp1msg($url,$time=666){
 
	

	
	$jsaction= "location.href='$url'";
	
	

  // $style=PUBLIC_STYLE_URL."oa.css";
print<<<END
<script> setTimeout("$jsaction",$time); </script>
END;
 
 
	
	
}
function   send_mail($to,$title,$content){

	load_lib("Mailer");
	$mail = new PHPMailer();  
 
	$mail->IsSMTP();  
	$mail->CharSet="utf-8";
	$mail->Host = MAILADDR; // 您的企业邮局域名
	$mail->SMTPAuth = true; // 启用SMTP验证功能
	$mail->Username = MAILUSER; // 邮局用户名(请填写完整的email地址)
	$mail->Password = MAILPASS; // 邮局密码
	$mail->Port=25;
	$mail->From = MAILUSER; //邮件发送者email地址
	$mail->FromName = "Xssing";
	$mail->AddAddress($to, $_COOKIE['xing_name']);//收件人地址，可以替换成任何想要接收邮件的email信箱,格式是AddAddress("收件人email","收件人姓名")
	//$mail->AddReplyTo("", "");

 
    $mail->IsHTML(true);  

	$mail->Subject = $title;
	$mail->Body = $content;
  
	 return  $mail->Send();
	
 

}
 
function send_sae_mail($to,$title,$content){
	
	 $mail = new SaeMail();
	 $ret = $mail->quickSend($to ,$title,$content , MAILUSER ,MAILPASS ,MAILADDR , 25 );

	
}

function over(){
    header("content-type:image/gif\r\n");
    header("Pragma:no-cache\r\n");
    header("Cache-Control:no-cache\r\n");
    header("Expires:0\r\n");
    $fp = fopen("./data/freep.gif","r");
    echo fread($fp,filesize("./data/freep.gif"));
    fclose($fp);
    die;
}
