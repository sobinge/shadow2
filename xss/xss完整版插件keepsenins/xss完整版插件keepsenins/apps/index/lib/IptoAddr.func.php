<?php
/*
 * ip到真实地址
 */
function  ip_to_addr($ip){
	
   $str = file_get_contents("http://int.dpool.sina.com.cn/iplookup/iplookup.php?ip=".$ip); 
   $str = iconv("gbk", "utf-8//IGNORE", $str); 
   preg_match_all("/[\x{4e00}-\x{9fa5}]+/u",$str,$get); 
   $add = implode('',$get[0]); 
   return $add; 	
	
}



 