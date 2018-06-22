<?php
/**
 * @desc   项目公告函数库
 * @team   高空科技:WwW.UaUc.Net 项目合作:UaUc.TaoBao.Com
 * @author Yaseng WwW.Yaseng.Me [Yaseng@UAUC.NET]
 */
/*
* 友好输出 变量  用于调试
*/
function P($var, $echo=true, $label=null, $strict=true) {
	$label = ($label === null) ? '' : rtrim($label) . ' ';
	if (!$strict) {
		if (ini_get('html_errors')) {
			$output = print_r($var, true);
			$output = "<font color='green'><pre>" . $label . htmlspecialchars($output, ENT_QUOTES) ."</font></pre>";
		} else {
			$output = $label . print_r($var, true);
		}
	} else {
		ob_start();
		var_dump($var);
		$output = ob_get_clean();
		if (!extension_loaded('xdebug')) {
			$output = preg_replace("/\]\=\>\n(\s+)/m", "] =>", $output);
			$output = '<font color="green"><pre>' . $label . htmlspecialchars($output, ENT_QUOTES) . '</font></pre>';
		}
	}
	if ($echo) {
		echo($output);
		return null;
	}else
	return $output;
}
/*
*得到模型
*/
function  M($model,$module=null){

  $path=is_null($module) ? APP_PATH."model/" : ROOT_PATH."model/".$module."/model/";
  if(file_exists($path.$model.".Model.php")){
  require_once($path.$model.".Model.php");
  $class=$model."Model";     
  return  new  $class();	
  }else{
  	return  null;
  }

}
/*
*得到动作
*/
function  A($action,$module=null){
 
  $path=is_null($module) ? APP_PATH."action/" : ROOT_PATH."moudle/".$module."/action/";
  require_once($path.$action.".Action.php");
  $class=$action."Action"; 
  return  new  $class($action);	
	
}

/*
 * 得到当前动作的模板文件
 */
function  view_file($name=null){
	
     $file=is_null($name) ? ACTION_NAME : $name;
     return TEMPLATE_PATH.MODULE_NAME."/".$file.'.tpl.php';
}
/*
 * 客户端ip
 */
 function get_client_ip() {

    if (isset($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $arr = explode(',', $_SERVER['HTTP_X_FORWARDED_FOR']);
        $pos =  array_search('unknown',$arr);
        if(false !== $pos) unset($arr[$pos]);
        $ip   =  trim($arr[0]);
    }elseif (isset($_SERVER['HTTP_CLIENT_IP'])) {
        $ip = $_SERVER['HTTP_CLIENT_IP'];
    }elseif (isset($_SERVER['REMOTE_ADDR'])) {
        $ip = $_SERVER['REMOTE_ADDR'];
    }
   
    $ip = (false !== ip2long($ip)) ? $ip : '0.0.0.0';
    return $ip;

	}
	
	function  J($url=""){
		
		header("Location:".$url);
		
	}
	
	function   show_404(){
		
		 header("HTTP/1.0 404 Not Found");
         header("Status: 404 Not Found");
        exit;
	}
/*
 * 
 */
  function  load_lib($lib,$app=null){
  	
    
  	$file= is_null($app) ? APP_LIB_PATH.$lib : ROOT_PATH."apps/".$app."/lib/".$lib;
  	
  	require_once $file.".class.php";
  }
  /*
   * 加载lib中函数文件
   */
  function  load_func($lib,$app=null){
  	
    
  	$file= is_null($app) ? APP_LIB_PATH.$lib : ROOT_PATH."apps/".$app."/lib/".$lib;
  	
  	require_once $file.".func.php";
  }
  
  function   load_action(){
  	
  	
  }	
  function   load_model(){
  	
  	
  	
  }	
  
	
	
?>