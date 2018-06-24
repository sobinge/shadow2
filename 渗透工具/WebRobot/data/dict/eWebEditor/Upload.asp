<!--#include file="Include/Startup.asp"-->
<!--#include file="Include/upfile_class.asp"-->
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
Server.ScriptTimeOut = 1800
' 参数变量
Dim sType, sStyleName
' 设置变量
Dim sAllowExt, nAllowSize, sUploadDir, nUploadObject, nAutoDir, sBaseUrl, sContentPath
' 接口变量
Dim sFileExt, sOriginalFileName, sSaveFileName, sPathFileName, nFileNum


Call DBConnBegin()		' 初始化数据库连接
Call InitUpload()		' 初始化上传变量
Call DBConnEnd()		' 断开数据库连接


Dim sAction
sAction = UCase(Trim(Request.QueryString("action")))

Select Case sAction
Case "REMOTE"
	Call DoRemote()			' 远程自动获取
Case "SAVE"
	Call ShowForm()			' 显示上传表单
	Call DoSave()			' 存文件
Case Else
	Call ShowForm()			' 显示上传表单
End Select



Sub ShowForm() 
%>
<HTML>
<HEAD>
<TITLE>文件上传</TITLE>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style type="text/css">
body, a, table, div, span, td, th, input, select{font:9pt;font-family: "宋体", Verdana, Arial, Helvetica, sans-serif;}
body {padding:0px;margin:0px}
</style>

<script language="JavaScript" src="dialog/dialog.js"></script>

</head>
<body bgcolor=menu>

<form action="?action=save&type=<%=sType%>&style=<%=sStyleName%>" method=post name=myform enctype="multipart/form-data">
<input type=file name=uploadfile size=1 style="width:100%" onchange="originalfile.value=this.value">
<input type=hidden name=originalfile value="">
</form>

<script language=javascript>

var sAllowExt = "<%=sAllowExt%>";
// 检测上传表单
function CheckUploadForm() {
	if (!IsExt(document.myform.uploadfile.value,sAllowExt)){
		parent.UploadError("提示：\n\n请选择一个有效的文件，\n支持的格式有（"+sAllowExt+"）！");
		return false;
	}
	return true
}

// 提交事件加入检测表单
var oForm = document.myform ;
oForm.attachEvent("onsubmit", CheckUploadForm) ;
if (! oForm.submitUpload) oForm.submitUpload = new Array() ;
oForm.submitUpload[oForm.submitUpload.length] = CheckUploadForm ;
if (! oForm.originalSubmit) {
	oForm.originalSubmit = oForm.submit ;
	oForm.submit = function() {
		if (this.submitUpload) {
			for (var i = 0 ; i < this.submitUpload.length ; i++) {
				this.submitUpload[i]() ;
			}
		}
		this.originalSubmit() ;
	}
}

// 上传表单已装入完成
try {
	parent.UploadLoaded();
}
catch(e){
}

</script>

</body>
</html>
<% 
End Sub 


' 保存操作
Sub DoSave()

	' 默认无组件上传类
	Call DoUpload_Class
	
	sPathFileName = sContentPath & sSaveFileName
	Call OutScript("parent.UploadSaved('" & sPathFileName & "');var obj=parent.dialogArguments.dialogArguments;if (!obj) obj=parent.dialogArguments;try{obj.addUploadFile('" & sOriginalFileName & "', '" & sSaveFileName & "', '" & sPathFileName & "');} catch(e){}")

End Sub

' 自动获取远程文件
Sub DoRemote()
	Dim sContent, i
	For i = 1 To Request.Form("eWebEditor_UploadText").Count 
		sContent = sContent & Request.Form("eWebEditor_UploadText")(i) 
	Next
	If sAllowExt <> "" Then
		sContent = ReplaceRemoteUrl(sContent, sAllowExt)
	End If

	Response.Write "<HTML><HEAD><TITLE>远程上传</TITLE><meta http-equiv='Content-Type' content='text/html; charset=gb2312'></head><body>" & _
		"<input type=hidden id=UploadText value=""" & inHTML(sContent) & """>" & _
		"</body></html>"

	Call OutScriptNoBack("parent.setHTML(UploadText.value);try{parent.addUploadFile('" & sOriginalFileName & "', '" & sSaveFileName & "', '" & sPathFileName & "');} catch(e){} parent.remoteUploadOK();")

End Sub

' 无组上传类
Sub DoUpload_Class()
	On Error Resume Next
	Dim oUpload, oFile
	' 建立上传对象
	Set oUpload = New upfile_class
	' 取得上传数据,限制最大上传
	oUpload.GetData(nAllowSize*1024)

	If oUpload.Err > 0 Then
		Select Case oUpload.Err
		Case 1
			Call OutScript("parent.UploadError('请选择有效的上传文件！')")
		Case 2
			Call OutScript("parent.UploadError('你上传的文件总大小超出了最大限制（" & nAllowSize & "KB）！')")
		End Select
		Response.End
	End If

	Set oFile = oUpload.File("uploadfile")
	sFileExt = LCase(oFile.FileExt)
	Call CheckValidExt(sFileExt)
	sOriginalFileName = oFile.FileName
	sSaveFileName = GetRndFileName(sFileExt)

	Dim str_Mappath
	str_Mappath = Server.Mappath(sUploadDir & sSaveFileName)
	sFileExt = LCase(Mid(str_Mappath, InstrRev(str_Mappath, ".") + 1))
	Call CheckValidExt(sFileExt)

	oFile.SaveToFile str_Mappath
	
	Set oFile = Nothing
	Set oUpload = Nothing
End Sub

' 取随机文件名
Function GetRndFileName(sExt)
	Dim sRnd
	Randomize
	sRnd = Int(900 * Rnd) + 100
	GetRndFileName = year(now) & month(now) & day(now) & hour(now) & minute(now) & second(now) & sRnd & "." & sExt
End Function

' 输出客户端脚本
Sub OutScript(str)
	Response.Write "<script language=javascript>" & str & ";history.back()</script>"
End Sub
Sub OutScriptNoBack(str)
	Response.Write "<script language=javascript>" & str & "</script>"
End Sub


' 检测扩展名的有效性
Sub CheckValidExt(sExt)
	Dim b, i, aExt
	b = False
	aExt = Split(sAllowExt, "|")
	For i = 0 To UBound(aExt)
		If LCase(aExt(i)) = sExt Then
			b = True
			Exit For
		End If
	Next
	If b = False Then
		OutScript("parent.UploadError('提示：\n\n请选择一个有效的文件，\n支持的格式有（"+sAllowExt+"）！')")
		Response.End
	End If
End Sub


' 初始化上传限制数据
Sub InitUpload()
	sType = UCase(Trim(Request.QueryString("type")))
	sStyleName = Get_SafeStr(Trim(Request.QueryString("style")))
	sSql = "select * from ewebeditor_style where s_name='" & sStyleName & "'"
	oRs.Open sSql, oConn, 0, 1
	If Not oRs.Eof Then
		sBaseUrl = oRs("S_BaseUrl")
		nUploadObject = oRs("S_UploadObject")
		nAutoDir = oRs("S_AutoDir")
		sUploadDir = oRs("S_UploadDir")
		Select Case sBaseUrl
		Case "0"
			sContentPath = oRs("S_ContentPath")
		Case "1"
			sContentPath = RelativePath2RootPath(sUploadDir)
		Case "2"
			sContentPath = RootPath2DomainPath(RelativePath2RootPath(sUploadDir))
		End Select

		Select Case sType
		Case "REMOTE"
			sAllowExt = oRs("S_RemoteExt")
			nAllowSize = oRs("S_RemoteSize")
		Case "FILE"
			sAllowExt = oRs("S_FileExt")
			nAllowSize = oRs("S_FileSize")
		Case "MEDIA"
			sAllowExt = oRs("S_MediaExt")
			nAllowSize = oRs("S_MediaSize")
		Case "FLASH"
			sAllowExt = oRs("S_FlashExt")
			nAllowSize = oRs("S_FlashSize")
		Case Else
			sAllowExt = oRs("S_ImageExt")
			nAllowSize = oRs("S_ImageSize")
		End Select
	Else
		OutScript("parent.UploadError('无效的样式ID号，请通过页面上的链接进行操作！')")
	End If
	oRs.Close
	sAllowExt = UCase(sAllowExt)
End Sub

' 转为根路径格式
Function RelativePath2RootPath(url)
	Dim sTempUrl
	sTempUrl = url
	If Left(sTempUrl, 1) = "/" Then
		RelativePath2RootPath = sTempUrl
		Exit Function
	End If

	Dim sWebEditorPath
	sWebEditorPath = Request.ServerVariables("SCRIPT_NAME")
	sWebEditorPath = Left(sWebEditorPath, InstrRev(sWebEditorPath, "/") - 1)
	Do While Left(sTempUrl, 3) = "../"
		sTempUrl = Mid(sTempUrl, 4)
		sWebEditorPath = Left(sWebEditorPath, InstrRev(sWebEditorPath, "/") - 1)
	Loop
	RelativePath2RootPath = sWebEditorPath & "/" & sTempUrl
End Function

' 根路径转为带域名全路径格式
Function RootPath2DomainPath(url)
	Dim sHost, sPort
	sHost = Split(Request.ServerVariables("SERVER_PROTOCOL"), "/")(0) & "://" & Request.ServerVariables("HTTP_HOST")
	sPort = Request.ServerVariables("SERVER_PORT")
	If sPort <> "80" Then
		sHost = sHost & ":" & sPort
	End If
	RootPath2DomainPath = sHost & url
End Function

'================================================
'作  用：替换字符串中的远程文件为本地文件并保存远程文件
'参  数：
'	sHTML		: 要替换的字符串
'	sExt		: 执行替换的扩展名
'================================================
Function ReplaceRemoteUrl(sHTML, sExt)
	Dim s_Content
	s_Content = sHTML
	If IsObjInstalled("Microsoft.XMLHTTP") = False then
		ReplaceRemoteUrl = s_Content
		Exit Function
	End If
	
	Dim re, RemoteFile, RemoteFileurl, SaveFileName, SaveFileType
	Set re = new RegExp
	re.IgnoreCase  = True
	re.Global = True
	re.Pattern = "((http|https|ftp|rtsp|mms):(\/\/|\\\\){1}(([A-Za-z0-9_-])+[.]){1,}(net|com|cn|org|cc|tv|[0-9]{1,3})(\S*\/)((\S)+[.]{1}(" & sExt & ")))"

	Set RemoteFile = re.Execute(s_Content)
	Dim a_RemoteUrl(), n, i, bRepeat
	n = 0
	' 转入无重复数据
	For Each RemoteFileurl in RemoteFile
		If n = 0 Then
			n = n + 1
			Redim a_RemoteUrl(n)
			a_RemoteUrl(n) = RemoteFileurl
		Else
			bRepeat = False
			For i = 1 To UBound(a_RemoteUrl)
				If UCase(RemoteFileurl) = UCase(a_RemoteUrl(i)) Then
					bRepeat = True
					Exit For
				End If
			Next
			If bRepeat = False Then
				n = n + 1
				Redim Preserve a_RemoteUrl(n)
				a_RemoteUrl(n) = RemoteFileurl
			End If
		End If		
	Next
	' 开始替换操作
	nFileNum = 0
	For i = 1 To n
		SaveFileType = Mid(a_RemoteUrl(i), InstrRev(a_RemoteUrl(i), ".") + 1)
		SaveFileName = GetRndFileName(SaveFileType)
		If SaveRemoteFile(SaveFileName, a_RemoteUrl(i)) = True Then
			nFileNum = nFileNum + 1
			If nFileNum > 0 Then
				sOriginalFileName = sOriginalFileName & "|"
				sSaveFileName = sSaveFileName & "|"
				sPathFileName = sPathFileName & "|"
			End If
			sOriginalFileName = sOriginalFileName & Mid(a_RemoteUrl(i), InstrRev(a_RemoteUrl(i), "/") + 1)
			sSaveFileName = sSaveFileName & SaveFileName
			sPathFileName = sPathFileName & sContentPath & SaveFileName
			s_Content = Replace(s_Content, a_RemoteUrl(i), sContentPath & SaveFileName, 1, -1, 1)
		End If
	Next

	ReplaceRemoteUrl = s_Content
End Function

'================================================
'作  用：保存远程的文件到本地
'参  数：s_LocalFileName ------ 本地文件名
'		 s_RemoteFileUrl ------ 远程文件URL
'返回值：True  ----成功
'        False ----失败
'================================================
Function SaveRemoteFile(s_LocalFileName, s_RemoteFileUrl)
	Dim Ads, Retrieval, GetRemoteData
	Dim bError
	bError = False
	SaveRemoteFile = False
	'On Error Resume Next
	Set Retrieval = Server.CreateObject("Microsoft.XMLHTTP")
	With Retrieval
		.Open "Get", s_RemoteFileUrl, False, "", ""
		.Send
		GetRemoteData = .ResponseBody
	End With
	Set Retrieval = Nothing

	If LenB(GetRemoteData) > nAllowSize*1024 Then
		bError = True
	Else
		Set Ads = Server.CreateObject("Adodb.Stream")
		With Ads
			.Type = 1
			.Open
			.Write GetRemoteData
			.SaveToFile Server.MapPath(sUploadDir & s_LocalFileName), 2
			.Cancel()
			.Close()
		End With
		Set Ads=nothing
	End If

	If Err.Number = 0 And bError = False Then
		SaveRemoteFile = True
	Else
		Err.Clear
	End If
End Function

'================================================
'作  用：检查组件是否已经安装
'参  数：strClassString ----组件名
'返回值：True  ----已经安装
'        False ----没有安装
'================================================
Function IsObjInstalled(strClassString)
	On Error Resume Next
	IsObjInstalled = False
	Err = 0
	Dim xTestObj
	Set xTestObj = Server.CreateObject(strClassString)
	If 0 = Err Then IsObjInstalled = True
	Set xTestObj = Nothing
	Err = 0
End Function



%>