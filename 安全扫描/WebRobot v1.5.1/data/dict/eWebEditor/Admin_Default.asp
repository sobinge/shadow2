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

sPosition = ""

Call Header()
Call Content()
Call Footer()


Sub Content()
%>
	<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0 WIDTH="100%">
	<TR><TD ALIGN=right><img border=0 src='admin/logo.gif'></TD></TR>
	<TR><TD ALIGN=center HEIGHT=100><span class=highlight1><b><%=outHTML(Session("eWebEditor_User"))%>：欢迎您使用本系统</b></span><br><br><br><b><span class=highlight2>为保证系统数据安全，使用完后请点击退出！</span></b></TD></TR>
	<TR>
		<TD>
		<TABLE BORDER=0 CELLPADDING=4 CELLSPACING=0>
		<TR>
			<TD><B>软件版本：</B></TD><TD>eWebEditor Version <%=Session("eWebEditor_Version")%></TD>
		</TR>
		<TR>
			<TD><B>版权所有：</B></TD><TD>eWebSoft.com</TD>
		</TR>
		<TR>
			<TD><B>程序制作：</B></TD><TD>eWeb开发团队</TD>
		</TR>
		<TR>
			<TD><B>主页地址：</B></TD><TD><a href="http://www.eWebSoft.com" target="_blank">http://www.eWebSoft.com</a>&nbsp;&nbsp;&nbsp;<a href="http://www.webasp.net" target="_blank">http://www.webasp.net</a></TD>
		</TR>
		<TR>
			<TD><B>产品介绍：</B></TD><TD><a href="http://http://www.eWebSoft.com/Product/eWebEditor/" target="_blank">http://www.eWebSoft.com/Product/eWebEditor/</a></TD>
		</TR>
		<TR>
			<TD><B>论坛地址：</B></TD><TD><a href="http://bbs.webasp.net" target="_blank">http://bbs.webasp.net</a></TD>
		</TR>
		<TR>
			<TD><B>联系方式：</B></TD><TD>OICQ:589808&nbsp;&nbsp;&nbsp;&nbsp;Email:<a href="mailto:webmaster@webasp.net">webmaster@webasp.net</a></TD>
		</TR>
		</TABLE>
		</TD>
	</TR>
	<TR><TD HEIGHT=30></TD></TR>
	</TABLE>
<%
End Sub
%>