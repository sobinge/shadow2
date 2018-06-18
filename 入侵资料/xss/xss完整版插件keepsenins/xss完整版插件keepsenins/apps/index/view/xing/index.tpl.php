<title> Xssing </title>

<?php require_once TEMPLATE_PATH."xing/header.tpl.php"; ?>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />


<body>
<div id="xoxo">
<h1>xss </h1>
<div class="left menus">
	<div class="menutitle">

<?php  echo  $_COOKIE['xing_name'].";"  ?> <a href="?m=user&a=logout">退出</a><br />

		<a class="left" href="<?php echo SITE_ROOT ?>?m=xing">我的项目</a>
		<a class="right" href="?m=project&a=add">创建</a>
	</div>
	<style>
ul { margin:0; width:140px; overflow:scroll-x; word-break:break-all}
.ohidden ul { height:18px; overflow:hidden }
a.oall,a.un { text-decoration:none }
td { vertical-align:top }
</style>

<table height="200">
	<ul>	
				 		   
             
              
               <?php
			 
			 if(is_array($projects)){
			  
			   
			   foreach($projects  as  $project){
		  
			 
				
			   $time=date("Y-m-d H:i:s",$project['time']);
    
				print<<<END
		   <li><a href="?m=project&a=show&pid={$project['pid']}"><strong>{$project['name']}</strong> </a></li>
             
 
END;
			   	
				   
			   }
			   
				 
			 }
				
			
			
			?>
        
 		   
             
              
              
        
 			</ul>
			<div class="menutitle">
			<a class="left" href="?m=project&a=edit">密码修改</a>
			</div>
			
			<div class="menutitle">
			<a class="left" href="">特别感谢</a>
			</div>
			<ul>
			<li><a href="#">感谢<b>Yasen</b>的框架！</a></li>
		

			</ul>
			<div class="menutitle">
			<a class="left" href="">本项目源码</a>
			</div>
			<ul>
			<li><a href="xss.zip">下载</a></li>
			</ul>
			</table>
	</div>



	<div class="span-19" flot="left">
	<table border="0" cellspacing="0" cellpadding="0">
		<caption><b>我的项目</b> <a href="?m=project&a=add" class="right">创建项目</a></caption>
		<thead>
			<tr>
				<th width="200">项目名称</th>
				<th width="100">创建时间</th>
				<th width="50">操作</th>
		   <tr>
                 <?php
			 
			 if(is_array($projects)){
			  
			   
			   foreach($projects  as  $project){
		  
			 
				
			   $time=date("Y-m-d H:i:s",$project['time']);

           
				print<<<END
		   <tr>
              <td><a href="?m=project&a=show&pid={$project['pid']}"> <font color="#00CC00"> <strong>{$project['name']} </strong></font> </a><span style="color:red"></td>
              <td>{$time}</td>
              <td>

                  <a href="?m=xing&a=delp&pid={$project['pid']}"><span class="ico_Del"> </span> 删除 </a></td>
            </tr>
            <tr>
 
END;
			   	
				   
			   }
			   
				 
			 }
				
			
			
			?>
            </tr>
            <tr>
 			</tr>
		</thead>
		
	</table>
</div>
</div>
</div>
</body>
</html>