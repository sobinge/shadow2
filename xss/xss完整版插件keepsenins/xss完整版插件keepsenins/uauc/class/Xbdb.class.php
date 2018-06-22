<?php
/*======================================================================================
====Name:ppdb.class.php                     Project:PlayPhp                         ====
========================================================================================
====Description:Mysql 驱动类                                                        ====
========================================================================================
====Team:90sec【WwW.90Sec.OrG】             项目合作 〖UaUc.TaoBao.CoM〗            ====
========================================================================================
====Author:Yaseng      Yaseng@Yahoo.cn   『WwW.Yaseng.Me』                          ====
====Date: 2012-07-2 14:35:00                                                        ====
======================================================================================*/
class  XBDB{
	

	private  static $conn;
	private  static $dbname;
	private  static $dbpre;

	/*
	*  类初始化函数
	*/
	public static function    init($host,$user,$pass,$port,$dbname,$dbpre){


		self::$dbname=$dbname;
		self::$dbpre =$dbpre;

		$conn =mysql_connect($host, $user,$pass);

		if (!$conn)
		{
			die('Could not connect: '. mysql_error());
		}

		self::$conn=$conn;

		if (!mysql_select_db(self::$dbname, self::$conn)) {

			exit("db");

		}
		mysql_query("SET NAMES utf8",self::$conn);   //设置数据库编码



	}
	/*
	*Mysql 普通查询
	*/
	public  static function  query($sql){

 
		$result = mysql_query($sql, self::$conn);
	/*	if(PP_DEBUG){
			
			Debug::showbar($sql);
		}  */
		return  $result ? $result : false;

	}
	/*
	* 查询所有的结果 根据字段
	*/
	public static  function  fetch_all($table,$filed="*",$case=array()){

   	$where =self::assign($case);
   	
    if($where){
    	
    	$where="WHERE  $where ";
    	
    }

		$query=self::query("SELECT $filed  FROM `".self::$dbpre.$table."`   $where ");
		while($row=mysql_fetch_array($query)){

			$rows[]=$row;

		}
		return $rows;


	}
	
	public static  function  fetch_all_bylimit($table,$filed="*",$case=""){
			
	
			$query=self::query("SELECT $filed  FROM `".self::$dbpre.$table."`    $case  ");
		while($row=mysql_fetch_array($query)){

			$rows[]=$row;

		}
		return $rows;
	
	     		
			
	}
	
	/*
	*查询第一条
	*/
	public  static function  fetch_first($table,$filed="*",$case=array()){
		
		$where =self::assign($case);
   	
    if($where){
    	
    	$where="WHERE  $where ";
    	
    }


		$result=self::query("SELECT  $filed  FROM `".self::$dbpre.$table."`   $where ");

		if($result){

			$row=mysql_fetch_array($result);


		}

		return  $row;

	}
	/*
	* 更新数据
	*/
	public  static function  update($table,$data=array(),$case=array()){


		$update=self::iassign($data);

		$where =self::assign($case);


		return  self::query("UPDATE `".self::$dbpre.$table."`   SET  $update  WHERE  $where ");





	}
	/*
	* 插入数据
	*/
	public  static function  insert($table,$data){

		$insert=self::iassign($data);

		return  self::query("INSERT  INTO `".self::$dbpre.$table."` SET  $insert");




	}
  /*
  *删除数据 (根据主键)
  */
  public  static  function delete($table,$case=array()){
  	
    
  	
  	$where=self::assign($case);   
  	
   return  self::query("DELETE FROM `".self::$dbpre.$table."`  WHERE  $where ");
   	
  
  }  
  
	/*
	*Sql 语句字符处理
	*/
	private  static function assign($array) {

		$str="";

		foreach($array  as  $key=> $item){
			
  

			$str.=" `$key`='".$item."' and";  


		}
 
		return substr($str,0,strlen($str)-3);


	}
	private  static function iassign($array) {

		$str="";

		foreach($array  as  $key=> $item){

			$str.=" `$key`='".$item."' ,";


		}

		return substr($str,0,strlen($str)-1);


	}





}









?>