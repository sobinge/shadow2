<?php
class  IncodeModel  extends Model{
	
	
	
	
	function  is_ok($code){
		
	  $now=time();
	  return $this->fetch__by_limit('iid',"WHERE code='{$code}' and  $now- time < 1000*3600");  //邀请码过期时间设置
	  
		
	}
	

	function  add(){
		
		$code=substr(md5(mt_rand(0, 99999999).time().rand()),0,11);
		
		$this->insert(array('code'=>$code,'time'=>time()));		
		
		return  $code;
		
	}
	
	function  del($code){
		
		$this->delete(array("code"=>$code));
		
	}
	
	
	
}
 