On Error Resume Next
WScript.Echo "*******************GetIISInfo   msn:slls124@gmail.com*******************"
Set ObjService=GetObject("IIS://LocalHost/W3SVC")
For Each obj3w In objservice   
	If IsNumeric(obj3w.Name) Then       
		Set OService=GetObject("IIS://LocalHost/W3SVC/" & obj3w.Name) 
 
		Set VDirObj = OService.GetObject("IIsWebVirtualDir", "ROOT")   
 
		'If Err = 0 Then 
			'WScript.Quit (1)
		'end if
		WScript.Echo Chr(10) & "[" & OService.ServerComment & "]"   
 
        dim state 	
		state = CInt(OService.ServerState)				
		if  state = 2 then
			WScript.Echo "[State] running"
		elseif state = 4 then
		    WScript.Echo "[State] stoped" 
		elseif state = 6 then
		    WScript.Echo "[State] paused" 
		end if
 
 
 
		For Each Binds In OService.ServerBindings
			WScript.Echo  "[Host ] " & Binds	
            WScript.Echo  "[User ] " & VDirObj.AnonymousUserName
			WScript.Echo  "[Pass ] " & VDirObj.AnonymousUserPass				
		Next   
			WScript.Echo    VDirObj.AdsPath & "	  "  & VDirObj.Path  		 
 
		For Each ChildObject In VDirObj
			'If (Err.Number = 0) Then 
				WScript.Echo ChildObject.AdsPath &  "	  "  & ChildObject.Path
			'End If
        Next
 
	end if
Next
