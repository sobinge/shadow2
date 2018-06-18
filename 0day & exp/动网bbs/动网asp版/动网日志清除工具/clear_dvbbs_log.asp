
<%
set conn= Server.CreateObject("adodb.connection")
connstr="provider=microsoft.jet.oledb.4.0;data source="&server.MapPath("../data/dvbbs7.mdb")
conn.open connstr

conn.execute("delete from [dv_log]")
response.write "<script language=javascript>alert('³É¹¦É¾³ý!')</script>"
%>
