<? 
$mysql_server_name = "localhost"; 
$mysql_username = "root"; 
$mysql_password = "password"; 
$mysql_database = "phpzr";  
$conn=mysql_connect( $mysql_server_name, $mysql_username, $mysql_password ); 
mysql_select_db($mysql_database,$conn); 
$id=$_GET['id']; 
$sql = "select username,password from admin where id=$id"; 
$result=mysql_db_query( $mysql_database, $sql,$conn ); 
$row=mysql_fetch_row($result); 
?> 
<html> 
<head> 
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"> 
<title>MySql Injection Test </title> 
</head> 
<body> 
<p align="center"><b><font color="#FF0000" size="5" face="华文行楷"> </font><font color="#FF0000" size="5" face="华文新魏">mysql 
 injection</font></b></p> 
<table width="100%" height="25%" border="1" align="center" cellpadding="0" cellspacing="0"> 
<tr> 
<td><?=$row[0]?></td> 
</tr> 
<tr> 
<td><?=$row[1]?></td> 
</tr> 
</table> 
</body> 
</html> 