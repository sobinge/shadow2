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

If Session("eWebEditor_User") = "" Then
	Response.Redirect "admin_login.asp"
	Response.End
End If

' 执行每天只需处理一次的事件
Call BrandNewDay()

' 初始化数据库连接
Call DBConnBegin()

' 公用变量
Dim sAction, sPosition
sAction = UCase(Trim(Request.QueryString("action")))
sPosition = "位置：<a href='admin_default.asp'>后台管理</a> / "


' ********************************************
' 以下为页面公用区函数
' ********************************************
' ============================================
' 输出每页公用的顶部内容
' ============================================
Sub Header()
	Response.Write "<html><head>"
	
	' 输出 meta 标记
	Response.Write "<meta http-equiv='Content-Type' content='text/html; charset=gb2312'>" & _
		"<meta name='Author' content='Andy.m'>" & _
		"<link rev=MADE href='mailto:webmaster@webasp.net'>"
	
	' 输出标题
	Response.Write "<title>eWebEditor - eWebSoft在线文本编辑器 - 后台管理</title>"
	
    ' 输出每页都使用的基本样式表
	Response.Write "<link rel='stylesheet' type='text/css' href='admin/style.css'>"

	' 输出每页都使用的基本客户端脚本
	Response.Write "<script language='javaScript' SRC='admin/private.js'></SCRIPT>"
	
	Response.Write "</head>"

	Response.Write "<body topmargin=0 leftmargin=0 bgcolor=#ffffff>"
	Response.Write "<a name=top></a>"
	
	' 输出页面顶部(Header1)
	Response.Write "<table border=0 cellpadding=0 cellspacing=0 height=41 width=778 align=center class=header1>" & _
		"<tr><td width=170 height=13></td><td width=608 rowspan=2 valign=top>" & _
		"<table border=0 cellpadding=0 cellspacing=0 width='100%'><tr><td height=7></td></tr><tr><td>"
	Response.Write "<table border=0 cellpadding=0 cellspacing=0 width='100%'>" & _
		"<tr>" & _
		"<td width=300></td>" & _
		"<td class=header1><a href='admin_default.asp'>后台管理首页</a></td>" & _
		"<td class=header1><a href='admin_login.asp?action=out'>退出后台管理并返回登录页</a></td>" & _
		"</tr>" & _
		"</table>"
	Response.Write "</td></tr></table>" & _
		"</td></tr><tr><td width=170 height=19 align=center valign=top>" & Application("date_chinese") & "</td></tr>" & _
		"<tr><td height=9 colspan=2></td></tr>" & _
		"</table>"

	' 页面左边内容
	Response.Write "<table border=0 cellpadding=0 cellspacing=0 width=778 align=center>" & _
		"<tr valign=top>" & _
		"<td width=175 class=leftbg>" & _
		"<table border=0 cellpadding=0 cellspacing=0 width='100%' class=lefttext>"
	' 后台管理模块
	Call Block_Member()
	Response.Write "</table>" & _
		"</td>" & _
		"<td width=20></td>" & _
		"<td width=575>" & _
		"<table border=0 cellpadding=0 cellspacing=0 width='100%'><tr><td>" & sPosition & "</td></tr><tr><td height=5></td></tr></table>"

End Sub

' ============================================
' 输出每页公用的底部内容
' ============================================
Sub Footer()
	' 释放数据连接对象
	Call DBConnEnd()

	Response.Write "</td>"
	Response.Write "<td width=7></td><td width=1 class=rightbg></td>"
	Response.Write "</tr></table>"
	
	' 底部导航
	Response.Write "<table border=0 cellpadding=0 cellspacing=0 width=778 align=center height=23 class=footer1>" & _
		"<tr valign=bottom>" & _
			"<td>&nbsp;&nbsp;<a href='http://www.webasp.net'><IMG src='admin/c_webasp.gif' border=0></a></td>" & _
			"<td align=right><a href='admin_default.asp' title='首页'><img src='admin/c_dian1.gif' width=15 height=15 border=0></a>　<a href='#top' title='返回页首'><img src='admin/c_dian3.gif' width=15 height=15 border=0></a>　<a href='javascript:window.close()' title='关闭窗口'><img src='admin/c_dian4.gif' width=15 height=15 border=0></a>&nbsp;&nbsp;</td>" & _
		"</tr>" & _
		"</table>"
	
	Response.Write "<table border=0 cellpadding=0 cellspacing=3 align=center class=footer2>" & _
		"<tr>" & _
			"<td align=center>Copyright  &copy;  2003-2004  <b>webasp<font color=#CC0000>.net</font></b> <b>eWebSoft<font color=#CC0000>.com</font></b>, All Rights Reserved .</td>" & _
		"</tr>" & _
		"<tr>" & _
			"<td align=center><a href='mailto:webmaster@webasp.net'>webmaster@webasp.net</a></td>" & _
		"</tr>" & _
		"</table>"

	Response.Write "</body></html>"
End Sub


' 后台管理模块
Sub Block_Member()
	Response.Write "<tr><td align=center>" & _
		"<table class=leftblock border=0 cellpadding=0 cellspacing=0>" & _
		"<tr><th>后台管理</th></tr>" & _
		"<tr><td>" & _
			"<table border=0 cellpadding=0 cellspacing=3 align=center width='100%'>" & _
			"<tr><td>→ <A class=leftnavi href='admin_style.asp'>样式管理</a></td></tr>" & _
			"<tr><td>→ <A class=leftnavi href='admin_decode.asp'>获取解释函数</a></td></tr>" & _
			"<tr><td>→ <A class=leftnavi href='admin_uploadfile.asp'>上传文件管理</a></td></tr>" & _
			"<tr><td>→ <A class=leftnavi href='admin_modipwd.asp'>用户名及密码修改</a></td></tr>" & _
			"<tr><td>→ <A class=leftnavi href='admin_login.asp?action=out'>退出</a></td></tr>" & _
			"</table>" & _
		"</td></tr>" & _
		"</table>" & _
		"</td></tr>"
End Sub

' ===============================================
' 初始化下拉框
'	s_FieldName	: 返回的下拉框名	
'	a_Name		: 定值名数组
'	a_Value		: 定值值数组
'	v_InitValue	: 初始值
'	s_Sql		: 从数据库中取值时,select name,value from table
'	s_AllName	: 空值的名称,如:"全部","所有","默认"
' ===============================================
Function InitSelect(s_FieldName, a_Name, a_Value, v_InitValue, s_Sql, s_AllName)
	Dim i
	InitSelect = "<select name='" & s_FieldName & "' size=1>"
	If s_AllName <> "" Then
		InitSelect = InitSelect & "<option value=''>" & s_AllName & "</option>"
	End If
	If s_Sql <> "" Then
		oRs.Open s_Sql, oConn, 0, 1
		Do While Not oRs.Eof
			InitSelect = InitSelect & "<option value=""" & inHTML(oRs(1)) & """"
			If oRs(1) = v_InitValue Then
				InitSelect = InitSelect & " selected"
			End If
			InitSelect = InitSelect & ">" & outHTML(oRs(0)) & "</option>"
			oRs.MoveNext
		Loop
		oRs.Close
	Else
		For i = 0 To UBound(a_Name)
			InitSelect = InitSelect & "<option value=""" & inHTML(a_Value(i)) & """"
			If a_Value(i) = v_InitValue Then
				InitSelect = InitSelect & " selected"
			End If
			InitSelect = InitSelect & ">" & outHTML(a_Name(i)) & "</option>"
		Next
	End If
	InitSelect = InitSelect & "</select>"
End Function


%>