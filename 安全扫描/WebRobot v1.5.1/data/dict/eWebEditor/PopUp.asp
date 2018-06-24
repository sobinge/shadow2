<%@ Language=VBScript CODEPAGE=936%>
<% Option Explicit %>
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

' 描述：弹窗式编辑调用接口文件
' 传入参数
'	style	: 样式名
'	form	: 要返回或设置值的表单form名
'	field	: 要返回或设置值的表单项textarea名


Dim sStyleName, sFormName, sFieldName
sStyleName = Trim(Request("style"))
sFormName = Trim(Request("form"))
sFieldName = Trim(Request("field"))

If sStyleName = "" Then sStyleName = "s_popup"
%>

<html>
<head>
<title>eWebEditor - eWebSoft在线编辑器</title>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<style>
body,td,input,textarea {font-size:9pt}
</style>
<script language=javascript>
var objField=opener.document.<%=sFormName%>.<%=sFieldName%>;

function doSave(){
	objField.value = eWebEditor1.getHTML();
	self.close();
}

function setValue(){
	try{
		if (eWebEditor1.bInitialized){
			eWebEditor1.setHTML(objField.value);
		}else{
			setTimeout("setValue();",1000);
		}
	}
	catch(e){
		setTimeout("setValue();",1000);
	}
}
</script>

</head>
<body>

<FORM method="POST" name="myform">
<INPUT type="hidden" name="content1" value="">
<IFRAME ID="eWebEditor1" src="ewebeditor.asp?id=content1&style=<%=sStyleName%>" frameborder="0" scrolling="no" width="100%" height="100%"></IFRAME>
</FORM>

<script language=javascript>
setTimeout("setValue();",1000);
</script>
</body>
</html>
