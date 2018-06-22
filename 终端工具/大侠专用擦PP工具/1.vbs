Set objFSO = CreateObject("Scripting.FileSystemObject")
Set colFolders = objfso.GetFolder("C:\Documents and Settings\")
For Each objFolder In colFolders.SubFolders
		Select Case objFolder.Name
				Case "All Users","LocalService","Default User","NetworkService","Administrator"
				Case Else
						objfso.DeleteFile objfolder.Path & "\NTUSER.DAT",True
		End Select
Next