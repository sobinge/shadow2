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
<style type="text/css">

tbody tr:nth-child(even) td, tbody tr.even td { background: #FFFFFF }
tbody tr td { background: #FFFFFF; height:55px }
tbody tr td .error { margin-bottom:0 }

</style>
</head>
<body>
<div class="container">
	<h1>XSS Platform
</h1>
<hr />	<div class="main">
		<form id="formRegister" action="<?php echo SITE_ROOT ?>?m=user&a=submit" method="post">
		<fieldset>
			<legend>注册</legend>
			<table class="formTable">
			<tr>
				<th width="100">邀请码</th>
				<td width="150"><input id="incode" name="incode" type="text" style="width:200px" value="" /></td>
				<td><div id="key_check">11个字符(字母、汉字、数字、下划线)</div></td>
			</tr>
			<tr>
				<th width="100">用户名</th>
				<td width="150"><input id="reg_1" name="reg_1" type="text" style="width:200px" maxlength="20" /></td>
				<td><div id="user_check">4-20个字符(字母、汉字、数字、下划线)</div></td>
			</tr>
			
			<tr>
				<th>密码</th>
				<td><input id="reg_2" name="reg_2" type="password" style="width:200px" maxlength="20" /></td>
				<td><div id="pwd_check">6-20个字符(字母、数字、下划线)</div></td>
			</tr>
			<tr>
				<th>密码确认</th>
				<td><input id="reg_22" name="reg_22" type="password" style="width:200px" maxlength="20" /></td>
				<td><div id="pwd2_check"></div></td>
			</tr>
			<tr><th></th>
				<td colspan="2"><input id="btnRegister" type="button" onclick="Register()" value="提交注册" />
						<span style="margin-left:20px">
							已经拥有账号? <a href="<?php echo SITE_ROOT ?>?m=user&a=login">直接登录</a>获取<a href="<?php echo SITE_ROOT ?>?a=zhuce" target="_blank">注册码</a>
						</span>
				</td>
			</tr>
			</table>
		</fieldset>
		</form>
	</div><!-- main End -->
</div>

<script type="text/javascript">

function Register(){
	var errNum=0;
	var checkItems=['key','user','pwd','pwd2'];
	for(var i=0;i<checkItems.length;i++){
		if($("#"+checkItems[i]).val()==""){
			errNum++;
			$("#"+checkItems[i]+"_check").addClass("error");
			$("#"+checkItems[i]+"_check").html("不能为空");
		}else{
			$("#"+checkItems[i]+"_check").addClass("correct");
			$("#"+checkItems[i]+"_check").html("√");
		}
	}
	/* 特殊判断 */
	//邀请码
        var key=$("#incode").val();
	if(key!="")
	{
		if(!/^[\w\u4E00-\u9FA5]{11}$/.test(key)){
			errNum++;
			$("#key_check").removeClass("correct");
			$("#key_check").addClass("error");
			$("#key_check").html("无效的邀请码(11位)");
		}else{
			$("#key_check").removeClass("error");
			$("#key_check").addClass("correct");
			$("#key_check").html("√");
		}
	}
        //用户格式
	var user=$("#reg_1").val();
	if(user!="")
	{
		if(!/^[\w\u4E00-\u9FA5]{4,20}$/.test(user)){
			errNum++;
			$("#user_check").removeClass("correct");
			$("#user_check").addClass("error");
			$("#user_check").html("4-20个字符(字母、汉字、数字、下划线)");
		}else{
			$("#user_check").removeClass("error");
			$("#user_check").addClass("correct");
			$("#user_check").html("√");
		}
	}
	
	//密码
	var pwd=$("#reg_2").val();
	if(pwd!="")
	{
		if(!/^\w{6,20}$/.test(pwd)){
			errNum++;
			$("#pwd_check").removeClass("correct");
			$("#pwd_check").addClass("error");
			$("#pwd_check").html("6-20个字符");
		}else{
			$("#pwd_check").removeClass("error");
			$("#pwd_check").addClass("correct");
			$("#pwd_check").html("√");
		}
	}
	//确认密码
	var pwd2=$("#reg_22").val();
	if(pwd2!="")
	{
		if(pwd2!=pwd){
			errNum++;
			$("#pwd2_check").removeClass("correct");
			$("#pwd2_check").addClass("error");
			$("#pwd2_check").html("两次输入密码不相同");
		}else{
			$("#pwd2_check").removeClass("error");
			$("#pwd2_check").addClass("correct");
			$("#pwd2_check").html("√");
		}
	}
	//提交注册
	if(errNum<=0){
		var key=$("#incode").val();
		//判断用户/邮箱/key
 		$.ajax({
		        type:'POST',
			url:'?m=user&a=onreg',
			data:'incode='+$('#incode').val()+'&reg_1='+$('#reg_1').val()+'&reg_2='+$('#reg_2').val(),
			success:function(msg){
                                var reArr=msg.split("|");
			       if(reArr[0]==0 && reArr[1]==0){ 
                                 $("#formRegister").submit();
			       }else{
				  if(reArr[0]>0){
					$("#user_check").removeClass("correct");
					$("#user_check").addClass("error");
					$("#user_check").html("用户已存在");
				   }
				if(reArr[1]>0){
					$("#key_check").removeClass("correct");
					$("#key_check").addClass("error");
					$("#key_check").html("邀请码已经失效了");
				}
			        }
                        }
		});
		
	}
}

</script>
</body>
</html>