On Error Resume Next
If (LCase(Right(WScript.Fullname,11))="wscript.exe") Then
	Msgbox Space(12) & "IIS Virtual Web Viewer" & Space(12) & Chr(13) & Space(9) & " Usage:Cscript vWeb.vbs",4096,"Lilo"
	WScript.Quit
End If
Set ObjService=GetObject("IIS://LocalHost/W3SVC")
For Each obj3w In objservice
	If IsNumeric(obj3w.Name) Then
		Set OService=GetObject("IIS://LocalHost/W3SVC/" & obj3w.Name)
		Set VDirObj = OService.GetObject("IIsWebVirtualDir", "ROOT")
		If Err <> 0 Then WScript.Quit (1)
		WScript.Echo Chr(10) & "[" & OService.ServerComment & "]"
		For Each Binds In OService.ServerBindings
			Web = "{ " & Replace(Binds,":"," } { ") & " }"
			WScript.Echo Replace(Split(Replace(Web," ",""),"}{")(2),"}","")
		Next
		WScript.Echo "Path            : " & VDirObj.Path
	End If
Next