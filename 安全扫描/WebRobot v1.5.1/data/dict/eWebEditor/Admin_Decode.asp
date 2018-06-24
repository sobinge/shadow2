<!--#include file = "Include/Startup.asp"-->
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

sPosition = sPosition & "获取解释函数代码"

Call Header()
Call Content()
Call Footer()


Sub Content()
	%>
	
	<Script Language=JavaScript>
	function MakeCode(){
		var b = false;
		var str = "<!--#" + "include file = \"....../eWebEditor/Include/DeCode.asp\"-->\n\n\n<" + "%\n\n";
		str += "Response.Write eWebEditor_DeCode(sContent, \"";
		for (var i=0;i<document.all("filterItem").length;i++){
			if (document.all("filterItem")[i].checked){
				if (b) str += ", ";
				str += document.all("filterItem")[i].value.toUpperCase();
				b = true;
			}
		}
		str += "\")\n\n%" + ">";
		okcode.value = str;
	}
	</Script>

	<p class=highlight2>代码解释功能，目的是为了防止一些人恶意的提交一些代码，影响系统的安全使用，通过字符转换的方法，防止这种现象的发生。以下调用文件的路径，请根据实际的安装进行更改。在需要调用的地方，先得包含deCode.asp文件，代码如下：</p>
	<textarea rows=3 cols=65 style='width:100%'>&lt;!--#include file = &quot;....../eWebEditor/Include/DeCode.asp&quot;--&gt;</textarea>
	<p class=highlight2>请先选择需要的解释的对象，也就是不允许用户使用的对象，然后点击生成即可。</p>
	<table border=1 cellpadding=3 cellspacing=0 width="100%">
	<tr>
		<td><input type="checkbox" name="filterItem" value="script" checked> 脚本过滤(<span class=highlight1>SCRIPT</span>)：即不允许使用javascript,vbscript等，事件onclick,ondlbclick等</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="filterItem" value="object"> 对象过滤(<span class=highlight1>OBJECT</span>)：即不允许 object, param, embed 标签，不能嵌入对象</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="filterItem" value="table"> 表格过滤(<span class=highlight1>TABLE</span>)：即不允许使用table,th,td,tr标签</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="filterItem" value="class"> 样式类过滤(<span class=highlight1>CLASS</span>)：即不允许使用 class= 这样的标签</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="filterItem" value="style"> 样式过滤(<span class=highlight1>STYLE</span>)：即不允许使用 style= 这样的标签</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="filterItem" value="xml"> XML过滤(<span class=highlight1>XML</span>)：即不允许使用 xml 标签</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="filterItem" value="namespace"> 命名空间过滤(<span class=highlight1>NAMESPACE</span>)：即不允许使用 &lt;o:p&gt;&lt;/o:p&gt; 这种格式</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="filterItem" value="font"> 字体过滤(<span class=highlight1>FONT</span>)：即不允许使用 font 标签，不建议使用</td>
	</tr>
	<tr>
		<td><input type="checkbox" name="filterItem" value="marquee"> 字幕过滤(<span class=highlight1>MARQUEE</span>)：即不允许使用 marquee 标签，也就没有移动滚动的特殊</td>
	</tr>
	<tr>
		<td><input type=button name=b value=" 生成代码 " onclick="MakeCode()"></td>
	</tr>
	</table>
	
	<p class=highlight2>生成的代码（你要调用的代码）如下：</p>
	<textarea id=okcode rows=10 cols=65 style='width:100%'></textarea><br><br>
	
	<Script Language=JavaScript>MakeCode();</Script>


	<%
End Sub
%>