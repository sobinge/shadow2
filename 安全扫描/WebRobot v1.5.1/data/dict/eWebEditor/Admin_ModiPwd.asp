<!--#include file = "Include/Startup.asp"-->
<!--#include file = "Include/md5.asp"-->
<!--#include file = "admin_private.asp"-->
<%
'☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆
'★                                                                  ★
'☆                eWebEditor - eWebSoft在线编辑器                   ☆
'★                                                                  ★
'☆  版权所有: eWebSoft.com                                          ☆
'★                                                                  ★
'☆  程序制作: eWeb开发团队                                          ☆
'★            email:webmaster@webasp.net                            ★
'☆            QQ:589808                                             ☆
'★                                                                  ★
'☆  相关网址: [产品介绍]http://www.eWebSoft.com/Product/eWebEditor/ ☆
'★            [支持论坛]http://bbs.eWebSoft.com/                    ★
'☆                                                                  ☆
'★  主页地址: http://www.eWebSoft.com/   eWebSoft团队及产品         ★
'☆            http://www.webasp.net/     WEB技术及应用资源网站      ☆
'★            http://bbs.webasp.net/     WEB技术交流论坛            ★
'★                                                                  ★
'☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆★☆
%>

<%

sPosition = sPosition & "修改用户名及密码"

Call Header()
Call Content()
Call Footer()


Sub Content()
	Select Case sAction
	Case "MODI"
		' 修改操作
		Call DoModi()
	Case Else
		' 修改表单
		Call ShowForm()
	End Select
End Sub

' 显示修改表单
Sub ShowForm()
%>
<script language=javascript>
// 客户端验证表单的有效性
function checklogin() {
	var obj;
	obj=document.myform.newusr;
	obj.value=BaseTrim(obj.value);
	if (obj.value=="") {
		BaseAlert(obj, "新用户名不能为空！");
		return false;
	}
	obj=document.myform.newpwd1;
	obj.value=BaseTrim(obj.value);
	if (obj.value=="") {
		BaseAlert(obj, "新密码不能为空！");
		return false;
	}
	if (document.myform.newpwd1.value!=document.myform.newpwd2.value){
		BaseAlert(document.myform.newpwd1, "新密码和确认密码不相同！");
		return false;
	}
	return true;
}
</script>

<br>
<table border=0 cellpadding=0 cellspacing=0 align=center class=form1>
<form action='?action=modi' method=post name=myform onsubmit="return checklogin()">
<tr><th>&nbsp;&nbsp;修改您的登录用户及密码（每项必填）</th></tr>
<tr><td>新用户名：<input type=text class=input size=20 name=newusr value="<%=inHTML(Session("eWebEditor_User"))%>">&nbsp;&nbsp;旧用户名：<span class=highlight1><%=outHTML(Session("eWebEditor_User"))%></span></td></tr>
<tr><td>新 密 码：<input type=password class=input size=20 name=newpwd1 maxlength=30>&nbsp;&nbsp;确认密码：<input type=password class=input size=20 name=newpwd2 maxlength=30></td></tr>
<tr><td align=center><input type=image border=0 src='admin/submit.gif' align=absmiddle>&nbsp;<a href='javascript:document.myform.reset()'><img border=0 src='admin/reset.gif' align=absmiddle></a></td></tr>
</form>
</table>
<br><br>

<%
End Sub

' 修改操作
Sub DoModi()
	' 服务器端验证表单的有效性
	If IsSelfRefer() = False Then
		Go_Error "提交表单有问题！！！"
	End If

	Dim sNewUsr, sNewPwd1, sNewPwd2
	sNewUsr = Trim(Request("newusr"))
	sNewPwd1 = Trim(Request("newpwd1"))
	sNewPwd2 = Trim(Request("newpwd2"))

	If sNewUsr = "" Then
		Go_Error "新用户名不能为空！"
	End If
	If sNewPwd1 = "" then
		Go_Error "新密码不能为空！"
	End If
	If sNewPwd1 <> sNewPwd2 Then
		Go_Error "新密码和确认密码不相同！"
	End If

	sSql = "select * from ewebeditor_system"
	oRs.Open sSql, oConn, 1, 3
	If Not oRs.Eof Then
		oRs("sys_username") = md5(sNewUsr)
		oRs("sys_userpass") = md5(sNewPwd1)
		oRs.Update
	End If
	oRs.Close

	Response.Write "<br><p align=center class=title>修改用户名及密码</p>" & _
		"<br><table border=0 cellspacing=20 align=center>" & _
		"<tr valign=top><td><img src='admin/do_ok.gif' border=0></td><td><b><span class=highlight2>登录用户名及密码修改成功！</span></b><br><br><ul>我现在<br><br><li><a href='admin_default.asp'>返回后台管理首页</a><li><a href='admin_modipwd.asp'>重新修改</a></ul></td></tr>" & _
		"</table><br><br>"

End Sub

%>