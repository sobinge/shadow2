<?php
class  InfoModel extends  Model{
	
	var $bid;
	
	function  __construct($bid){
		
		parent::__construct();
		
		$this->bid=$bid;
		
		
	}
       
	function  add(){
		
		$this->insert(array("bid"=> $this->bid));
		
	}
	
	function  set($url,$cookie,$location,$referrer){
		$sk_status='new';
		$this->update(array("url"=>$url,"cookie"=>$cookie,"location"=>$location,"referer"=>$referrer,"sk_status"=>$sk_status), array("bid"=> $this->bid));
 
		
	}
	function  get(){
		
		
		if($this->privacy()){  
			$this->dbtable='info';
		return  $this->fetch_first("*",array("bid"=> $this->bid));
		}else{
			return  false;
		}
		
	}
	function privacy(){
		
	 	$this->dbtable='browser';
	 	$browser=$this->fetch_first("pid",array('bid'=>$this->bid));
	    $this->dbtable='project';
	 	$project=$this->fetch_first("uid",array('pid'=>$browser['pid']));
 
	  
	     return  ($project['uid']==$_SESSION['uid'])  ? true  :  false ;
		 
		
	} 
	
	
	
	function  del(){
		
		return  $this->delete(array("bid"=> $this->bid));
		
	}
	
	
	
	
	
	
}
 