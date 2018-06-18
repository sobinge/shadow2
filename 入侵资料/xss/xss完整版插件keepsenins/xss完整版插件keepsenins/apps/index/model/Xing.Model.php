<?php
class  XingModel  extends  Model{
	
	
	function  get_projects(){
		
		$this->dbtable='project';
		$data=$this->fetch_all("*",array('uid'=>$_SESSION['uid']),"`time` DESC");
		return $data;
		
	}
	
	function  get_browsers($pid){
		
		$this->dbtable='browser';
		return $this->fetch_all("*",array('active' => 1,'pid'=>$pid),"`dateline` DESC");
 
	  	
	}
	function  get_infos($pid){
		
		$this->dbtable='browser';
		$data=$this->fetch_all("*",array('active' => 1,'pid'=>$pid),"`dateline` DESC");
 return $data['bid'];
	  	
	}
	function  del_browser($bid){
		


 
	if($this->privacy($bid)){
		
			$this->dbtable='browser';
	
	return  $this->delete(array("bid"=>$bid));
	
	}else{
		
		return  false;
	}
		
		
	}
	
		function privacy($bid){
		
	 	$this->dbtable='browser';
	 	$browser=$this->fetch_first("pid",array('bid'=>$bid));
	    $this->dbtable='project';
	 	$project=$this->fetch_first("uid",array('pid'=>$browser['pid']));
 
	  
	     return  ($project['uid']==$_SESSION['uid'])  ? true  :  false ;
		 
		
	} 
	
	
	function  del_project($pid){
		
		$this->dbtable='project';
		
		$project=$this->fetch_first("uid",array("pid"=>$pid));
		
		if($project['uid']==$_SESSION['uid']){
			
		 $this->delete(array("pid"=>$pid));
	    $this->del_bro_pid($pid);
		 return  true;	
	    
		}else{
			
			return  false;
		}
		
    
		
	}
	function  del_bro_pid($pid){
		
		$this->dbtable='browser';
		$browsers=$this->get_browsers($pid);
		
		foreach ($browsers as $browser){
			
			$this->delete(array("bid"=>$browser['bid']));
			$this->del_info($browser['bid']);
		}
		
		
		// 
		
	}
	function  del_info($bid){
		
		$this->dbtable="info";
		
		$this->delete(array('bid'=>$bid));
	}
	
	
}
 