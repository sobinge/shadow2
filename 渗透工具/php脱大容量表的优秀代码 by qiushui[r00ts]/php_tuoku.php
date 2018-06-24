<?php
/*
绝对NB，脱单一的库，数据量很大的那个表。
*/
//容错、超时设置
ini_set('display_errors', 1);
set_time_limit(0);
error_reporting(E_ALL);
//修改下面的配置
$host="127.0.0.1"; //服务器地址
$user="root";      //服务器用户
$password="root";  //服务器密码
$db="tuolu";        //数据库
$table="tuo";        //数据库中的表
//连接数据
$conn = mysql_connect($host, $user, $password) or die("not connect:");
mysql_select_db($db,$conn) or die("Could not connect");
$result = mysql_query("SELECT * FROM $table",$conn) or die("not connect");
$num = 0;
$content = '';
echo "[+]正在脱库中..."."<br>";
while ($row = mysql_fetch_row($result)) {
    $num = $num+1;
    $content .=  implode("|", $row)."\n";
	 if(!($num%5)){//5为写入文件的条数
        $filename = 'c:/'.intval($num/5).'.xls';
        file_put_contents($filename,$content);
        $content = '';
    }
}
echo "[+]脱裤结束...";
mysql_free_result($result);
?>