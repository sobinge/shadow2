<?php require_once TEMPLATE_PATH."xing/header.tpl.php"; ?>
<script type="text/javascript">
function SubmitContent(){
	if($("#title").val()==""){
		ShowError("项目名称不能为空");
		return false;
	}
	$("#contentForm").submit();
}
function ShowError(content){
	$("#contentShow").attr("class","error");
	$("#contentShow").html(content);
}

</script>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<body>
<div id="xoxo">
<h1>XSS Platform</h1>
<div class="left menus">
	<div class="menutitle">

<?php  echo  $_COOKIE['xing_name'].";"  ?> <a href="?m=user&a=logout">退出</a><br />

		<a class="left" href="<?php echo SITE_ROOT ?>">我的项目</a>
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
	</div></head>

<div style="span-19 left">
<form id="contentForm" action="?m=project&a=onpei&pid=<?php  echo $_GET[pid];?>" method="post">

<fieldset> 
  <legend>配置项目: <?php  echo  $pro['name']?></legend>
	<div id="contentShow"></div>
  <p> 
		<label for="title">是否keepsession</label><br> 
      <li style="margin-bottom:10px"> <input <?php if ($pro['sessionkeeper']==1)echo "checked='\checked\'"?> onclick="if(this.checked){ $('#mset_'+this.value).show() }else{ $('#mset_'+this.value).hide() }" name="sk" value="1" type="checkbox" /> sessionkeeper
	</p> 
  <p> 
		<label for="title">接收邮件</label><br> 
      <li>邮箱:<input type="text" class="title" name="eamil" id="eamil" value="<?php  echo  htmlentities($pro['eamil']);?>"></li>
	</p> 
	<p> 
		<label for="title">是否开启crsf</label><br> 
      <li style="margin-bottom:10px"> <input <?php if ($pro['iscrsf']==1)echo "checked='\checked\'"?> onclick="if(this.checked){ $('#mset_'+this.value).show() }else{ $('#mset_'+this.value).hide() }" name="iscrsf" value="1" type="checkbox" /> crsf
	</p> 
  <p> 
		<label for="description">crsf (需要添加地址和post数据)</label><br> 
        <ul id="keyList">
          <li>地址(写路径不要加HTTP://):<input type="text" class="title" name="csrfurl" id="csrfurl" value="<?php  echo  htmlentities($pro['csrfurl']);?>">例：/admin/UserAdmin/Add_AdminUser.aspx</li>
          <li>数据:<input type="text" class="title" name="crsfs" id="crsfs" value="<?php  echo  htmlentities($pro['crsfs']);?>">例：&AdminName=adminai3&AdminPwd=123456&Button1=%E7%A1%AE%E5%AE%9A%E6%B7%BB%E5%8A%A0</li>
        </ul>
	</p>


	<p> 
		<input type="button" value="配置" onclick="SubmitContent()"> &nbsp;&nbsp;
		<input type="button" value="取消" onclick="history.go(-1)"> 
	</p> 
</fieldset> 
</form>
</div>
</div>
</div>
</body>
</html>