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
function AddKey(obj,keyname){
	var liObj=document.createElement("li");
	$(obj).parent().before(liObj);
	var input=document.createElement("input");
	$(liObj).append(input);
	var btn=document.createElement("input");
	$(liObj).append(btn);
	$(liObj).append(document.createTextNode(" "));
	btn.type="button";
	$(btn).val("添加");
	$(liObj).append(document.createTextNode(" "));
	var del=document.createElement("a");
	$(liObj).append(del);
	$(del).attr("href","javascript:void(0)");
	$(del).html("删除");
	$(btn).click(function(){
		var txt=$(input).val();
		if(txt==""){
			alert("请输入参数名");
		}else{
			$(input).remove();
			$(btn).remove();
			var checkObj=document.createElement("input");
			$(del).before(checkObj);
			checkObj.type="checkbox";
			checkObj.checked="checked";
			var keyName=keyname!=null ? keyname : "keys[]";
			$(checkObj).attr("name",keyName);
			$(checkObj).attr("value",txt);
			$(del).before(document.createTextNode(" "+txt+" "));
		}
	});
	$(del).click(function(){
		$(liObj).remove();
	});
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
<p>当前位置： <a href="<?php echo SITE_ROOT ?>">首页</a> > 创建项目</p>
<form id="contentForm" action="?m=project&a=onadd" method="post">

<fieldset> 
	<legend>创建项目</legend>
	<div id="contentShow"></div>
	<p> 
		<label for="title">项目名称</label><br> 
		<input type="text" class="title" name="name" id="name"> 
	</p> 


	<p> 
		<input type="button" value="创建" onclick="SubmitContent()"> &nbsp;&nbsp;
		<input type="button" value="取消" onclick="history.go(-1)"> 
	</p> 
</fieldset> 
</form>
</div>
</div>
</div>
</body>
</html>