<?php
class  Browser{



	/*
	 * 获取客户端浏览器类型
	 */
	public static function get_client_browser(){

		$agent=strtolower($_SERVER['HTTP_USER_AGENT']);    

	 if (preg_match('/MSIE\s([^\s|;]+)/i', $agent, $regs)) {
	 	return 'Internet Explorer '.$regs[1];
	 	 
	 }else if(preg_match('/Opera[\s|\/]([^\s]+)/i', $agent, $regs)){

	 	return  'Opera '.$regs[1];

	 }else if(preg_match('/FireFox\/([^\s]+)/i', $agent, $regs)){

	 	return  'FireFox '.$regs[1];

	 }else if (preg_match('/Chrome/i',$agent,$regs)) {
	 	 
	 	$aresult = explode('/',stristr($agent,'Chrome'));
	 	$aversion = explode(' ',$aresult[1]);
	 	return  'Chrome '.$aversion[0];
	 	 
	 }else  if(strpos($agent, "uc")){  // uc  浏览器
	 	
	 	return  'uc';
	 }
	 else if(preg_match('/safari\/([^\s]+)/i', $agent, $regs)){
	 	 
	 	return  'Safari '.$regs[1];
	 
	 }
	  
	  

	 return  'Other Browser';

	}
	/*
	 * 获取客户端操作系统
	 */

	public  static   function   get_clinet_os(){

		$agent=$_SERVER['HTTP_USER_AGENT'];
		if(strpos($agent,"Windows NT 5.0"))$os="Windows 2000";
		elseif(strpos($agent,"Windows NT 5.1"))$os="Windows XP";
		elseif(strpos($agent,"Windows NT 5.2"))$os="Windows 2003";
		elseif(strpos($agent,"Windows NT 6.0"))$os="Windows Vista";
		elseif(strpos($agent,"Windows NT 6.1"))$os="Windows 7";
		elseif(strpos($agent,"Windows NT"))$os="Windows NT";
		elseif(strpos($agent,"Windows CE"))$os="Windows CE";
		elseif(strpos($agent,"ME"))$os="Windows ME";
		elseif(strpos($agent,"Windows 9"))$os="Windows 98";
		elseif(strpos($agent,"unix"))$os="Unix";
		elseif(strpos($agent,"linux"))$os="Linux";
		elseif(strpos($agent,"SunOS"))$os="SunOS";
		elseif(strpos($agent,"OpenBSD"))$os="OpenBSD";
		elseif(strpos($agent,"FreeBSD"))$os="FreeBSD";
		elseif(strpos($agent,"AIX"))$os="AIX";
		elseif(strpos($agent,"Mac"))$os="Mac";
	    elseif(strpos($agent,"android"))$os="Android";
		else $os="Other";
		return $os;
		 
		 
	}


}
?>