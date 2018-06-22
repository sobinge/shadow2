<?php
class  UserModel  extends  Model{

	 public  $uid;
   
	function  login($name,$pass){
		
		$data=$this->fetch_first("*",array('name'=> $name));
		if(is_array($data)){
			
			if($data['pass']==$this->checkmd5($pass, $data['key']))
			{
				$this->update(array('ip'=>get_client_ip()), array('uid'=>$data['uid']));
              
				$_SESSION['uid']=$data['uid'];
           
				setcookie('xing_name',$name,NULL, NULL, NULL, NULL, TRUE);
                                setcookie('xing_pass',$pass,NULL, NULL, NULL, NULL, TRUE);
              
				return $data['uid'];
				
			}
			
		}
		
		
	}
        function  xiugai($name,$pass,$newpass){
		
		$data=$this->fetch_first("*",array('name'=> $name));
		if(is_array($data)){
			
			if($data['pass']==$this->checkmd5($pass, $data['key']))
			{
                                 $time=time();
				$this->update(array('pass'=> $this->tmd5($newpass, $time),'key'=> $time), array('uid'=>$data['uid']));
				
                          //$_SESSION['uid']=$data['uid'];
                          //setcookie('xing_name',$name,time()+7*3600);
                          //setcookie('xing_pass',$pass,time()+7*3600);
				return $data['uid'];
				
			}
			
		}
		
		
	}
	function  reg($name,$pass){
		
	  $time=time();
      $this->uid=$this->insert(array('name'=>$name,'pass'=> $this->tmd5($pass, $time),'ip'=>get_client_ip(),'key'=> $time));

     
      return  $this->uid;
      
	}
	function  url_to_uid($url){
		
	  $uid=$this->fetch_first("uid",array('url'=>$url));
	  return $uid['uid'];
		
	}
	function  uid_to_url($uid){
		
		$url=$this->fetch_first("url",array('uid'=>$uid));
		return  $url['url'];
		
		
	}
	
 
	/**
	 * 多次md5 加密
	 */
	private function tmd5($pw,$time){


		return substr(md5(md5($time).md5($pw)),-22);

	}


	private function checkmd5($password,$regtime)
	{

		return  (substr(md5(md5($regtime).md5($password)),-22));
	}

    



}