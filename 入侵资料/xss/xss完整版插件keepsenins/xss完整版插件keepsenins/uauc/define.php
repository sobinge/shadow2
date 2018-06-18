<?php
/**
 * @desc   系统常量
 * @team   高空科技:WwW.UaUc.Net 项目合作:UaUc.TaoBao.Com
 * @author Yaseng WwW.Yaseng.Me [Yaseng@UAUC.NET]
 */
 define('STATIC_PATH',ROOT_PATH."static/");    
 define('STATIC_JS_PATH',STATIC_PATH."js/");  //系统共用js库
 define('CONFIG_PATH',ROOT_PATH."config/");   //配置目录
 define('RUNNING_PATH',ROOT_PATH."running/");
 define('CACHE_PATH',RUNNING_PATH."cache/");  //缓存目录
 define('LOG_PATH',RUNNING_PATH."log/");      //日志目录

 /*
  * 全局url路径
  */
 


define('SITE_HOST',$_SERVER['HTTP_HOST']);
define('SITE_ROOT',"http://127.0.0.1".SITE_HOST.((dirname($_SERVER['SCRIPT_NAME'])=='\\')   ? dirname($_SERVER['SCRIPT_NAME'])."/"   :  '/'  ));

  
 
//define('SITE_ROOT',"http://qqaini.sinaapp.com/");  //使用sae 部署 
 define('STATIC_URL',SITE_ROOT."static/");
 define('STATIC_JS_URL',STATIC_URL."js/");
 define('STATIC_STYLE_URL',STATIC_URL."style/");

  
 /*
 *当前模块path
 */

 define('APP_PATH',ROOT_PATH."/apps/".APP_NAME."/");  
 define('TEMPLATE_PATH',APP_PATH."view/");
 define('PUBLIC_PATH',TEMPLATE_PATH."public/");
 define('APP_LIB_PATH',APP_PATH."lib/");

 
 /*
  * 当前模块url
  */
 define('APP_URL',SITE_ROOT."apps/".APP_NAME."/");
 define('TEMPLATE_URL',APP_URL."view/");
 define('PUBLIC_URL',TEMPLATE_URL."public/");
 define('PUBLIC_JS_URL',PUBLIC_URL."js/");
 define('PUBLIC_STYLE_URL',PUBLIC_URL."style/");
 


 



?>