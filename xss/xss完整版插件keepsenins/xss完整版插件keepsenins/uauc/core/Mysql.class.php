<?php
/**
 * @desc   Mysql数据驱动核心文件
 * @team   高空科技:WwW.UaUc.Net 项目合作:UaUc.TaoBao.Com
 * @author Yaseng WwW.Yaseng.Me [Yaseng@UAUC.NET]
 */
abstract class  Mysql{


	private   $conn;
	private   $dbname;
	private   $dbpre;
	public $dbtable;

	function  __construct($dbtable){



	}

	/*
	 * 连接数据库
	 */
	public  function    connect($host,$user,$pass,$port,$dbname,$dbpre){


		$this->dbname=$dbname;
		$this->dbpre =$dbpre;

		$conn =mysql_connect($host.":".$port, $user,$pass);

		if (!$conn)
		{
			die('Could not connect: '. mysql_error());
		}

		$this->conn=$conn;

		if (!mysql_select_db($this->dbname, $this->conn)) {

			exit("db  error");

		}
		mysql_query("SET NAMES utf8",$this->conn);   



	}
	/*
	 *Mysql 执行
	 */
	public   function  query($sql){


		$result = mysql_query($sql, $this->conn);
	    if(DEBUG_MODE) Log::record($sql);
	    return  $result ? $result : false;

	}
	/*
	 * 获取全部
	 */
	public   function  fetch_all($filed="*",$case=array(),$order=null){

		$where =self::assign($case);

		if($where){
			 
			$where="WHERE  $where ";
			 
		}
		if($order){
			
			$where.="ORDER BY ".$order;
		}
        $rows=array();
		$query=self::query("SELECT $filed  FROM `".$this->dbpre.$this->dbtable."`   $where ");
		while($row=mysql_fetch_array($query)){

			$rows[]=$row;

		}
		return $rows;


	}

	public   function  fetch__by_limit($filed="*",$case=""){
			

		$query=self::query("SELECT $filed  FROM `".$this->dbpre.$this->dbtable."`    $case  ");
		while($row=mysql_fetch_array($query)){

			$rows[]=$row;

		}
		return $rows;


			
	}

	 
	
	
	/*
	 *去得第一条
	 */
	public   function  fetch_first($filed="*",$case=array(),$append=null){

		$where =self::assign($case);

		if($where){
			 
			$where="WHERE  $where ";
			 
		}


		$result=self::query("SELECT  $filed  FROM `".$this->dbpre.$this->dbtable."`   $where ");

		if($result){

			$row=mysql_fetch_array($result);
  
		}

		return  $row;

	}
	/*
	 *  
	 */
	public   function  update($data=array(),$case=array()){


		$update=self::iassign($data);

		$where =self::assign($case);


		return  $this->query("UPDATE `".$this->dbpre.$this->dbtable."`   SET  $update  WHERE  $where ");





	}
	/*
	 *  
	 */
	public   function  insert($data){

		$insert=self::iassign($data);

		$this->query("INSERT  INTO `".$this->dbpre.$this->dbtable."` SET  $insert");

        return  mysql_insert_id(); 


	}
	/*
	 * 
	 */
	public    function delete($case=array()){
		 

		 
		$where=self::assign($case);
		 
		return  self::query("DELETE FROM `".$this->dbpre.$this->dbtable."`  WHERE  $where ");


	}

     public  function  count($case=null){
     	
     	$where= is_null($case)  ? "" : " WHERE ".$case;
     	$count=$this->query("select  count(*)  FROM  ".$this->dbpre.$this->dbtable.$where);
     	$res=0;
     	if($count){
     		
     		$res=mysql_fetch_array($count);
     	}
     	return   $res['count(*)'];
     }
	private   function assign($array) {

		$str="";

		foreach($array  as  $key=> $item){
				


			$str.=" `$key`='".$item."' and";


		}

		return substr($str,0,strlen($str)-3);


	}
	private   function iassign($array) {

		$str="";

		foreach($array  as  $key=> $item){

			$str.=" `$key`='".$item."' ,";


		}

		return substr($str,0,strlen($str)-1);


	}





}









?>