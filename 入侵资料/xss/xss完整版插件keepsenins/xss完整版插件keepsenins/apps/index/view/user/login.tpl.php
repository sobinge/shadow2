<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>XSS Platform</title>
<link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>screen.css" type="text/css" media="screen, projection"> 
<link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>print.css" type="text/css" media="print"> 
<!--[if lt IE 8]><link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>ie.css" type="text/css" media="screen, projection"><![endif]-->
<link rel="stylesheet" href="<?php echo  STATIC_STYLE_URL?>style.css" type="text/css" media="screen, projection">
<script type="text/javascript" src="<?php echo STATIC_JS_URL ?>jquery.js"></script>

<script type="text/javascript">
function Login(){
	if($("#value_1").val()==""){
		ShowError("用户名不能为空");
		return false;
	}
	if($("#value_2").val()==""){
		ShowError("密码不能为空");
		return false;
	}
	if($('#value_1').val()!="" && $('#value_2').val()!=""){
			
			$.ajax({
				type:'POST',
                          url:'?m=user&a=onlogin',
				data:'value_1='+$('#value_1').val()+'&value_2='+$('#value_2').val(),
				success:function(msg){
					
		                 if(msg == 1){
					
					location.href = '?m=xing';
				
                                 }else{
                                   ShowError("用户和密码错误");
		                   return false;}
                                }
				             
			});
		}
}
function ShowError(content){
	$("#contentShow").attr("class","error");
	$("#contentShow").html(content);
}
</script>

</head>
<body>
<div class="container">
<h1>XSS Platform(支持邮件接收)
</h1>
<hr /><form id="contentForm" action="<?php echo SITE_ROOT ?>?m=user&a=onlogin" method="post"> 
<fieldset> 
	<legend>登录</legend>
	<div id="contentShow"></div>
	<p> 
		<label for="user">用户名</label><br> 
		<input type="text" class="title" name="value_1" id="value_1"> 
	</p> 
	<p> 
		<label for="title">密码</label><br> 
		<input type="password" class="title" name="value_2" id="value_2"> 
	</p>
	<p> 
		<input type="button" value="登录" onclick="Login()"> 
		<span style="margin-left:20px">
			还没有账号? <a href="<?php echo SITE_ROOT ?>?m=user&a=reg">立刻注册</a>获取<a href="<?php echo SITE_ROOT ?>?a=zhuce" target="_blank">注册码</a>
		</span>
	</p> 
</fieldset> 
</form>
</div>
</body>
</html>