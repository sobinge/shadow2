<?php
class  AppAction  extends   Action{
	
	function  init(){
		
   
		
		include  APP_PATH."model/User.Model.php";
		$user=new UserModel();
		
		
		if(!$user->login($_COOKIE['xing_name'], $_COOKIE['xing_pass'])){
			
			
	    header("Location:?m=user&a=login");
	   
			 
			
		}
		
		
		
		 
	}
	
	
	
}