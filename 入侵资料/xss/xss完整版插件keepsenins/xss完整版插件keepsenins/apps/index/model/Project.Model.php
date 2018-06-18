<?php
class  ProjectModel  extends  Model{
	
	function  add($name){
		
		return  $this->insert(array('name'=>$name,'time'=>time(),'uid'=>$_SESSION['uid'],'url'=>$this->geturl()));		
	}
  function  pei($pid,$iscrsf,$csrfurl,$crsfs,$eamil,$sk){
     if ($iscrsf==2)
        return  $this->update(array("iscrsf"=>$iscrsf,"eamil"=>$eamil,"sessionkeeper"=>$sk), array("pid"=>$pid));
    if ($iscrsf==0)
        return  $this->update(array("iscrsf"=>$iscrsf), array("pid"=>$pid));
    if ($iscrsf==1)
		return  $this->update(array("iscrsf"=>$iscrsf,"csrfurl"=>$csrfurl,"crsfs"=>$crsfs,"eamil"=>$eamil,"sessionkeeper"=>$sk), array("pid"=>$pid));
    //return  $this->insert(array('name'=>$name,'time'=>time(),'uid'=>$_SESSION['uid'],'url'=>$this->geturl()));		
	}
	
    private  function  geturl(){
    	
    	return  substr(md5(time()),0,6);
    	
    }
    
    function  url_to_pid($url){
    	
      $pid=$this->fetch_first("pid",array('url'=>$url));
	  return $pid['pid'];
    }
	
      function  uid_to_email($uid){
    	
      $email=$this->fetch_first("email",array('uid'=>$uid));
	  return $email['email'];
    }
	function  del($pid){
		
		
		
		
	}
	
}