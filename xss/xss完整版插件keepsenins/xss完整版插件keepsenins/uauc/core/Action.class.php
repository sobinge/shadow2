<?php
/**
 * @desc   动作基类
 * @team   高空科技:WwW.UaUc.Net 项目合作:UaUc.TaoBao.Com
 * @author Yaseng WwW.Yaseng.Me [Yaseng@UAUC.NET]
 */
abstract class  Action{
    
	public     $name =null; //本action名称

	
	
	function  __construct(){
	    
		$this->name=$this->get_name();
	//	$this->model=M($this->name);  //初始化本模块模型
		$this->init();
	}
	
	/*
	 *  
	 */
    public function   init(){}
	
	/*
	 * 
	 */
	protected function get_name() {

		return   substr(get_class($this),0,-6);
		 
	}
	/*
	 *输出试图  *.tpl.php 模板
	 */
	protected function view($name=null){

		$file=is_null($name) ? ACTION_NAME : $name;
		include(TEMPLATE_PATH.MODULE_NAME."/".$file.'.tpl.php');

	}
}



?>