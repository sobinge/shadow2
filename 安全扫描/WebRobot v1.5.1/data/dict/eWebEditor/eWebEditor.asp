<!--#include file = "Include/Startup.asp"-->
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
' 初始输入参数
Dim sContentID, sStyleID, sFullScreen
Dim sStyleName, sStyleDir, sStyleCSS, sStyleUploadDir, nStateFlag, sDetectFromWord, sInitMode, sBaseUrl, sBaseHref, sAutoRemote, sShowBorder
Dim sVersion, sReleaseDate, sLicense

Dim aButtonCode(), aButtonHTML()
Dim sToolBar, sToolBarNormal, sToolBarFullScreen

' 初始化
Call Init()

%>


<html>
<head>
<title>eWebEditor - eWebSoft在线编辑器</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<link href="css/<%=sStyleCSS%>/Editor.css" type="text/css" rel="stylesheet">

<Script Language=Javascript>
var sPath = document.location.pathname;
sPath = sPath.substr(0, sPath.length-14);

var sLinkFieldName = "<%=sContentID%>" ;
var sLinkOriginalFileName = "<%=Request.QueryString("originalfilename")%>" ;
var sLinkSaveFileName = "<%=Request.QueryString("savefilename")%>" ;
var sLinkSavePathFileName = "<%=Request.QueryString("savepathfilename")%>" ;

// 全局设置对象
var config = new Object() ;
config.Version = "<%=sVersion%>" ;
config.ReleaseDate = "<%=sReleaseDate%>" ;
config.License = "<%=sLicense%>" ;
config.StyleName = "<%=sStyleName%>";
config.StyleMenuHeader = "<head><link href=\""+sPath+"css/<%=sStyleCSS%>/MenuArea.css\" type=\"text/css\" rel=\"stylesheet\"></head><body scroll=\"no\" onConTextMenu=\"event.returnValue=false;\">";
config.StyleDir = "<%=sStyleDir%>";
config.StyleUploadDir = "<%=sStyleUploadDir%>";
config.InitMode = "<%=sInitMode%>";
config.AutoDetectPasteFromWord = <%=sDetectFromWord%>;
config.BaseUrl = "<%=sBaseUrl%>";
config.BaseHref = "<%=sBaseHref%>";
config.AutoRemote = "<%=sAutoRemote%>";
config.ShowBorder = "<%=sShowBorder%>";

var sBaseHref = "";
if(config.BaseHref!=""){
	sBaseHref = "<base href=\"" + document.location.protocol + "//" + document.location.host + config.BaseHref + "\">";
}
config.StyleEditorHeader = "<head><link href=\"" + sPath + "css/<%=sStyleCSS%>/EditorArea.css\" type=\"text/css\" rel=\"stylesheet\">" + sBaseHref + "</head><body MONOSPACE>" ;
</Script>
<Script Language=Javascript src="include/editor.js"></Script>
<Script Language=Javascript src="include/table.js"></Script>
<Script Language=Javascript src="include/menu.js"></Script>

<script language="javascript" event="onerror(msg, url, line)" for="window">
return true ;	 // 隐藏错误
</script>

</head>

<body SCROLLING=no onConTextMenu="event.returnValue=false;">

<table border=0 cellpadding=0 cellspacing=0 width='100%' height='100%'>
<tr><td>

	<%=sToolBar%>

</td></tr>
<tr><td height='100%'>

	<table border=0 cellpadding=0 cellspacing=0 width='100%' height='100%'>
	<tr><td height='100%'>
	<input type="hidden" ID="ContentEdit" value="">
	<input type="hidden" ID="ModeEdit" value="">
	<input type="hidden" ID="ContentLoad" value="">
	<input type="hidden" ID="ContentFlag" value="0">
	<iframe class="Composition" ID="eWebEditor" MARGINHEIGHT="1" MARGINWIDTH="1" width="100%" height="100%" scrolling="yes"> 
	</iframe>
	</td></tr>
	</table>

</td></tr>

<% If nStateFlag = 1 Then %>
<tr><td height=25>

	<TABLE border="0" cellPadding="0" cellSpacing="0" width="100%" class=StatusBar height=25>
	<TR valign=middle>
	<td>
		<table border=0 cellpadding=0 cellspacing=0 height=20>
		<tr>
		<td width=10></td>
		<td class=StatusBarBtnOff id=eWebEditor_CODE onclick="setMode('CODE')"><img border=0 src="buttonimage/<%=sStyleDir%>/modecode.gif" width=50 height=15 align=absmiddle></td>
		<td width=5></td>
		<td class=StatusBarBtnOff id=eWebEditor_EDIT onclick="setMode('EDIT')"><img border=0 src="buttonimage/<%=sStyleDir%>/modeedit.gif" width=50 height=15 align=absmiddle></td>
		<td width=5></td>
		<td class=StatusBarBtnOff id=eWebEditor_TEXT onclick="setMode('TEXT')"><img border=0 src="buttonimage/<%=sStyleDir%>/modetext.gif" width=50 height=15 align=absmiddle></td>
		<td width=5></td>
		<td class=StatusBarBtnOff id=eWebEditor_VIEW onclick="setMode('VIEW')"><img border=0 src="buttonimage/<%=sStyleDir%>/modepreview.gif" width=50 height=15 align=absmiddle></td>
		</tr>
		</table>
	</td>
	<td align=center id=eWebEditor_License style="font-size:9pt"></td>
	<td align=right>
		<table border=0 cellpadding=0 cellspacing=0 height=20>
		<tr>
		<td style="cursor:pointer;" onclick="sizeChange(300)"><img border=0 SRC="buttonimage/<%=sStyleDir%>/sizeplus.gif" width=20 height=20 alt="增高编辑区"></td>
		<td width=5></td>
		<td style="cursor:pointer;" onclick="sizeChange(-300)"><img border=0 SRC="buttonimage/<%=sStyleDir%>/sizeminus.gif" width=20 height=20 alt="减小编辑区"></td>
		<td width=40></td>
		</tr>
		</table>
	</td>
	</TR>
	</Table>

</td></tr>
<% End If %>

</table>

<div id="eWebEditor_Temp_HTML" style="VISIBILITY: hidden; OVERFLOW: hidden; POSITION: absolute; WIDTH: 1px; HEIGHT: 1px"></div>

<form id="eWebEditor_UploadForm" action="upload.asp?action=remote&type=remote&style=<%=sStyleName%>" method="post" target="eWebEditor_UploadTarget">
<input type="hidden" name="eWebEditor_UploadText">
</form>
<iframe name="eWebEditor_UploadTarget" width=500 height=500></iframe>
<div id=divProcessing style="width:200px;height:30px;position:absolute;display:none">
<table border=0 cellpadding=0 cellspacing=1 bgcolor="#000000" width="100%" height="100%"><tr><td bgcolor=#3A6EA5><marquee align="middle" behavior="alternate" scrollamount="5" style="font-size:9pt"><font color=#FFFFFF>...远程文件收集中...请等待...</font></marquee></td></tr></table>
</div>

</body>
</html>


<%


' 显示调用错误提示
Sub ShowErr(str)
	Call DBConnEnd()
	Response.Write "调用错误：" & str
	Response.End
End Sub

' 初始化
Sub Init()
	' 取全屏标志
	sFullScreen = Trim(Request.QueryString("fullscreen"))
	' 取对应的内容ID
	sContentID = Trim(Request.QueryString("id"))
	If sContentID = "" Then ShowErr "请传入调用参数ID，即隐藏的内容表单项ID！"

	' 取样式初始值
	sStyleName = Get_SafeStr(Trim(Request.QueryString("style")))
	If sStyleName = "" Then sStyleName = "standard"

	Dim s_SelfUrl, s_ApplicationName, n_Application, i
	s_SelfUrl = UCase(Request.ServerVariables("SERVER_NAME") & ":" & Request.ServerVariables("SERVER_PORT") & Request.ServerVariables("SCRIPT_NAME") & "?style=" & sStyleName)
	n_Application = 0

	Dim aApplicationName, aApplicationUrl, aApplicationValue
	aApplicationName = Application("eWebEditor_ApplicationName")
	aApplicationUrl = Application("eWebEditor_ApplicationUrl")

	If IsArray(aApplicationName) = True Then
		n_Application = UBound(aApplicationName)
		
		' 是否在内存中
		For i = 1 To n_Application
			If aApplicationUrl(i) = s_SelfUrl Then
				s_ApplicationName = aApplicationName(i)
				aApplicationValue = Application(s_ApplicationName)
				sStyleID			 = aApplicationValue(0)
				sStyleName			 = aApplicationValue(1)
				sStyleDir			 = aApplicationValue(2)
				sStyleCSS			 = aApplicationValue(3)
				sStyleUploadDir		 = aApplicationValue(4)
				nStateFlag			 = aApplicationValue(5)
				sDetectFromWord		 = aApplicationValue(6)
				sInitMode			 = aApplicationValue(7)
				sBaseUrl			 = aApplicationValue(8)
				sVersion			 = aApplicationValue(9)
				sReleaseDate		 = aApplicationValue(10)
				sLicense			 = aApplicationValue(11)
				sToolBarNormal		 = aApplicationValue(12)
				sToolBarFullScreen	 = aApplicationValue(13)
				sBaseHref			 = aApplicationValue(14)
				sAutoRemote			 = aApplicationValue(15)
				sShowBorder			 = aApplicationValue(16)
				If sFullScreen = "1" Then
					sToolBar = sToolBarFullScreen
				Else
					sToolBar = sToolBarNormal
				End If
				Exit Sub
			End If
		Next
	End If


	' 初始化数据库连接
	Call DBConnBegin()

	sSql = "select * from ewebeditor_style where s_name='" & sStyleName & "'"
	oRs.Open sSql, oConn, 0, 1
	If Not oRs.Eof Then
		sStyleID = oRs("S_ID")
		sStyleName = oRs("S_Name")
		sStyleDir = oRs("S_Dir")
		sStyleCSS = oRs("S_CSS")
		sStyleUploadDir = oRs("S_UploadDir")
		nStateFlag = oRs("S_StateFlag")
		sAutoRemote = CStr(oRs("S_AutoRemote"))
		sShowBorder = CStr(oRs("S_ShowBorder"))
		sDetectFromWord = oRs("S_DetectFromWord")
		sInitMode = oRs("S_InitMode")
		sBaseUrl = oRs("S_BaseUrl")
		sBaseHref = oRs("S_BaseHref")
	Else
		ShowErr "无效的样式Style参数传入，如果要使用默认值，请留空！"
	End If
	oRs.Close

	' 取版本号及发布日期
	sSql = "select sys_version,sys_releasedate,sys_license from ewebeditor_system"
	oRs.Open sSql, oConn, 0, 1
	sVersion = oRs(0)
	sReleaseDate = oRs(1)
	sLicense = oRs(2)
	oRs.Close

	' 取所有按钮
	Call InitButtonArray()
	' 取样式下的工具栏及按钮
	Call InitToolBar()
	' 断开数据库连接
	Call DBConnEnd()

	If sFullScreen = "1" Then
		sToolBar = sToolBarFullScreen
	Else
		sToolBar = sToolBarNormal
	End If

	n_Application = n_Application + 1
	If n_Application = 1 Then
		Redim aApplicationName(1)
		Redim aApplicationUrl(1)
	Else
		Redim Preserve aApplicationName(n_Application)
		Redim Preserve aApplicationUrl(n_Application)
	End If
	Redim aApplicationValue(16)
	s_ApplicationName = "eWebEditor" & n_Application
	aApplicationName(n_Application) = s_ApplicationName
	aApplicationUrl(n_Application) = s_SelfUrl
	aApplicationValue(0)	 = sStyleID
	aApplicationValue(1)	 = sStyleName
	aApplicationValue(2)	 = sStyleDir
	aApplicationValue(3)	 = sStyleCSS
	aApplicationValue(4)	 = sStyleUploadDir
	aApplicationValue(5)	 = nStateFlag
	aApplicationValue(6)	 = sDetectFromWord
	aApplicationValue(7)	 = sInitMode
	aApplicationValue(8)	 = sBaseUrl
	aApplicationValue(9)	 = sVersion
	aApplicationValue(10)	 = sReleaseDate
	aApplicationValue(11)	 = sLicense
	aApplicationValue(12)	 = sToolBarNormal
	aApplicationValue(13)	 = sToolBarFullScreen
	aApplicationValue(14)	 = sBaseHref
	aApplicationValue(15)	 = sAutoRemote
	aApplicationValue(16)	 = sShowBorder

	Application.Lock
	Application("eWebEditor_ApplicationName") = aApplicationName
	Application("eWebEditor_ApplicationUrl") = aApplicationUrl
	Application(s_ApplicationName) = aApplicationValue
	Application.Unlock

End Sub


' 初始化按钮数组
Sub InitButtonArray()
	Dim i
	sSql = "select * from ewebeditor_button order by b_order asc"
	oRs.Open sSql, oConn, 0, 1
	i = 0
	Do While Not oRs.Eof
		i = i + 1
		Redim Preserve aButtonCode(i)
		Redim Preserve aButtonHTML(i)
		aButtonCode(i) = oRs("B_Code")
		Select Case oRs("B_Type")
		Case 0
			aButtonHTML(i) = "<DIV CLASS=""" & oRs("B_Class") & """ TITLE=""" & oRs("B_Title") & """ onclick=""" & oRs("B_Event") & """><IMG CLASS=""Ico"" SRC=""buttonimage/" & sStyleDir & "/" & oRs("B_Image") & """></DIV>"
		Case 1
			aButtonHTML(i) = "<SELECT CLASS=""" & oRs("B_Class") & """ onchange=""" & oRs("B_Event") & """>" & oRs("B_HTML") & "</SELECT>"
		Case 2
			aButtonHTML(i) = "<DIV CLASS=""" & oRs("B_Class") & """>" & oRs("B_HTML") & "</DIV>"
		End Select
		oRs.MoveNext
	Loop
	oRs.Close
End Sub

' 由按钮代码得到按钮的最终输出
Function Code2HTML(s_Code)
	Dim i
	Code2HTML = ""
	For i = 1 To UBound(aButtonCode)
		If UCase(aButtonCode(i)) = UCase(s_Code) Then
			Code2HTML = aButtonHTML(i)
			Exit Function
		End If
	Next
End Function

' 初始化工具栏
Sub InitToolBar()
	Dim aButton, n
	sSql = "select t_button from ewebeditor_toolbar where s_id=" & sStyleID & " order by t_order asc"
	oRs.Open sSql, oConn, 0, 1
	If Not oRs.Eof Then
		sToolBarNormal = "<table border=0 cellpadding=0 cellspacing=0 width='100%' class='Toolbar' id='eWebEditor_Toolbar'>"
		sToolBarFullScreen = "<table border=0 cellpadding=0 cellspacing=0 width='100%' class='Toolbar' id='eWebEditor_Toolbar'>"
		Do While Not oRs.Eof
			sToolBarNormal = sToolBarNormal & "<tr><td><div class=yToolbar>"
			sToolBarFullScreen = sToolBarFullScreen & "<tr><td><div class=yToolbar>"
			aButton = Split(oRs("T_Button"), "|")
			For n = 0 To UBound(aButton)
				sToolBarNormal = sToolBarNormal & Code2HTML(aButton(n))
				If UCase(aButton(n)) = "MAXIMIZE" Then
					aButton(n) = "Minimize"
				End If
				sToolBarFullScreen = sToolBarFullScreen & Code2HTML(aButton(n))
			Next
			sToolBarNormal = sToolBarNormal & "</div></td></tr>"
			sToolBarFullScreen = sToolBarFullScreen & "</div></td></tr>"
			oRs.MoveNext
		Loop
		sToolBarNormal = sToolBarNormal & "</table>"
		sToolBarFullScreen = sToolBarFullScreen & "</table>"
	Else
		ShowErr "对应样式没有设置工具栏！"
	End If
	oRs.Close
End Sub
%>