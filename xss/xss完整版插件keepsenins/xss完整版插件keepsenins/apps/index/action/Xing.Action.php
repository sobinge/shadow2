<?php
class  XingAction  extends AppAction{
	
    
	
	function   index(){
		
		
		
                $user=new UserModel();
                $name=$_COOKIE['xing_name'] ;
                $pass=$_COOKIE['xing_pass'] ;
         
            if(!empty($pass)&&!empty($name)&&!empty($_SESSION['uid'])){
              //  if($user->login($name, $pass)){
                         $xing=new XingModel();
                         $projects=$xing->get_projects();
                          include  view_file();
                  // }
                  //}else{
                  // cpmsg("无权限1","error");
                  // header("?m=user&a=login");
          }else{
                cp1msg("?m=user&a=login");
          }
           // }
            
           
           
           // echo $name."<br>";
           // echo $pass."<br>";
           //  echo $_SESSION['uid'];
		
          //cpmsg("无权限","error");	
		
	}

	
	 
	function  test(){
		
	  
		echo  substr(md5(time()),0,6);
		
		
	
	}
	 
	
	function  info(){
     
	 $bid=intval($_GET['bid']);
	 if($bid){

 
	 $info=new InfoModel($bid);

	 $info=$info->get();

	 
	 
	  if($info){
	  	
	  	include  view_file();
	  	
	  }else{
	  	
	   cpmsg("无权限","error");
	  	
	  }
	 
	 
	 
	   
	 	
	 }
		
		
	}
	 
	function  del(){
		
	 $bid=intval($_GET['bid']);
	 if($bid){
	 	
	 	$xing=new  XingModel();
	 	$info=new  InfoModel($bid);
	 	  if($xing->del_browser($bid)){
	
	 	  	$info->del();
		     cpmsg("删除成功");
	  	
	      }else{
	 	
	     	cpmsg("删除失败","error");
	 	
	 }
	 	
	 }	
		
	}
	function  delp(){
		
		$pid=intval($_GET['pid']);
		
		$xing=new  XingModel();
		
		if(!$xing->del_project($pid)){
			
			cpmsg("删除失败");
			
		}else{
			
			cpmsg("删除成功");
		}
		
	 
		
	    
	}
	
	
}