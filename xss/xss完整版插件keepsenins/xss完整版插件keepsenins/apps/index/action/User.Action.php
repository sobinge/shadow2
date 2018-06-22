<?php
class  UserAction  extends  Action{
	
	function   index(){
		
		
		
		
	}
	
	
	function   login(){
		
  
		
		include  view_file();
		
	   
	}
	
	function  onlogin(){
		
	   
	   $name=$_POST['value_1'];
       $pass=$_POST['value_2'];
       $user=new UserModel();  
       
       
       
       if($user->login($name, $pass)){
       	
       	
         echo  1;
       	
       } 
	   
		
	}
        function  onxiugai(){
		
	   
       $name=$_COOKIE['xing_name'] ;
       $pass=$_POST['pass'];
       $newpass=$_POST['newpass'];
       $user=new UserModel();  
       
       
       
       if($user->xiugai($name, $pass,$newpass)){
       	
       	
         J("?m=user&a=login");
       	
       } else{
	   
	J("?m=xing");	
	}
        }
	function  logout(){
		
		
	  $_SESSION['id']=null;
	  setcookie('xing_name','',time()-7*3600);
      setcookie('xing_pass','',time()-7*3600);
      session_destroy();      // 第一步: 删除服务器端 session文件,这使用 
      setcookie(session_name(),'',time()-7*3600);      //  第 二 步 : 删 除 实 际 的 
     
     $_SESSION = array();  
      J("?m=user&a=login");
		
		
	}
        function  submit(){
		
		
	 header("Location:?m=xing");
		
	}
	function  reg(){
		
		$i=$_GET['i'];
		$is_incode=0;
		if($i){
		
		$incode=new IncodeModel();
        
	   
		if($incode->is_ok($i)) $is_incode=1;
		 
		
		
	}
	 include  view_file();
	}
	function  onreg(){
		
		 
		$incode=new IncodeModel();
	   	 $code=$_POST['incode'];
	   	 $name=$_POST['reg_1'];
	   	 $pass=$_POST['reg_2'];
       
	   
	    if($incode->is_ok($code)){
	    	
  			
	                $user=new UserModel(); 
	            if($user->reg($name, $pass)){
        
                              
	  	 
		             $incode->del($code);
		 
		            if($user->login($name, $pass)){
		 	
		 	echo  "0|0";
                              //header("Location:?m=xing");
		 	
		                                            }
		 
	        
		                               }
                                               else{
                                                
                                                echo "1|0";
                                               }
	    	
	    	
	                                }
		else{
			echo  "0|1";
                  //cpmsg("注册码失效");
			
		}
		
		
		
	}
	/**
	 * @desc 邀请码生成接口    强烈要求自定义函数名称和 $token   这里提供一个demo
	 *       使用方法 : www.yaseng.me/?m=user&a=get_incode&token=admin&n=100  
	 */
	function  zhuce(){
		

		
		
			
			$incode=new IncodeModel();
			
	
				
		  		echo  $incode->add()."<br>";	
	
	  
  
	
 
	}
	
	
}