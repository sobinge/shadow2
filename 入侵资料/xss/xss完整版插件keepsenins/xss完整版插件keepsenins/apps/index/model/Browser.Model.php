<?php
class  BrowserModel extends  Model{
	
	var  $bid=null;
    var  $ip,$type,$os,$name,$dateline,$pid;
	
    function  __construct($ip,$type,$os,$pid,$name,$dateline){
    	 
    	parent::__construct();
    	$this->ip=$ip;
    	$this->type=$type;
    	$this->os=$os;
    	$this->pid=$pid;
    	$this->name=$name;
    	$this->dateline=$dateline;
    	$this->bid=$this->is_exists($ip, $type,$os);
    	
    }
	

 
	function  is_exists($ip,$type,$os){
		
	  $browser= $this->fetch_first("bid",array('ip'=>$ip,'type'=>$type,'os'=>$os,'pid'=>$this->pid)); 
	  return $browser['bid'];
	}
	/*
	 * 是否在线
	 */
	function  is_active(){
		
	   $active=$this->fetch_first("active",array('bid'=> $this->bid));
		return  $active['active'];
				
	}
    function  login(){
    	
    	$this->update(array('active'=>1,'dateline'=>time()), array('bid'=> $this->bid));  //更新状态为在线
    }
    function   reg(){
    	
    	//新浏览器注册
    	$this->bid = $this->insert(array('name'=> $this->ip,'type'=> $this->type,'os'=> $this->os,'ip'=>$this->ip,'pid'=>$this->pid,'dateline'=>time()));
         $info=new InfoModel($this->bid);
	    $info->add();
	    
	   
    	
    }
    function  get($pid){
    	
    	return $this->fetch_all("*",array("pid"=>$pid));
    }
    
    
    
}

 