<?php
/**
 * @desc   Uauc 框架核心文件  启动项目入口
 * @team   高空科技:WwW.UaUc.Net 项目合作:UaUc.TaoBao.Com
 * @author Yaseng WwW.Yaseng.Me [Yaseng@UAUC.NET]
 */
class  Uauc {

	public  static 	function  run(){

        

		$action=!empty($_REQUEST['a']) ? strip_tags(strtolower($_REQUEST['a'])) : 'index';
		$module=!empty($_REQUEST['m']) ? strip_tags(strtolower($_REQUEST['m'])) : 'index';
        define('ACTION_NAME',$action);   
		define('MODULE_NAME',$module);      
        $module=A(ucfirst($module));  	//mvc
        set_error_handler(array('Uauc','appError'));   
        set_exception_handler(array('Uauc','appException'));
      
      
        
		spl_autoload_register(array('Uauc', 'autoload'));
       
		Log::run();
		call_user_func(array(&$module,$action));
	}
	public static function autoload($class) {
		
	 
	    if(substr($class,-5)=='Model'){

			require_once APP_PATH."model/".substr($class,0,-5).".Model.php";
		}elseif(substr($class,-6)=='Action'){
			
			require_once APP_PATH."action/".substr($class,0,-6).".Action.php";
		}		 
		
		
	}
    static public function appException($e) {
        
    }
    static public function appError($errno, $errstr, $errfile, $errline) {
         
     
    }

}
