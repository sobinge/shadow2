<?php
/**
 * @desc   Model核心类
 * @team   高空科技:WwW.UaUc.Net 项目合作:UaUc.TaoBao.Com
 * @author Yaseng WwW.Yaseng.Me [Yaseng@UAUC.NET]
 */
abstract  class  Model extends  Mysql{



	/*
	 * 
	 */
	function  __construct(){
		 
		$this->dbtable=strtolower($this->get_name());
		$this->connect(DB_HOST,DB_USER,DB_PASS,DB_PORT,DB_NAME,DB_PRE);
	 	$this->init(); 

		 
	}
	protected function get_name() {

		return   substr(get_class($this),0,-5);
		 
	}
	
	/*
	 *  
	 */
	public function   init(){}
	/*
	 *
	 */
	function __call($method,$args) {

		if(1>2){


			 
		}elseif(strtolower(substr($method,0,6))=='getby_') {
			 
			$field   =  substr($method,6);
			return  $this->fetch_first("*",array($field=>$args[0]));


		}


	}
	 
	
	
	

}
?>