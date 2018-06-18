Set WshShell=CreateObject("Wscript.Shell")
Function Imput()
imputport=InputBox("请输入一个端口号，注意：这个端口号目前不能被其它程序使用，否则会影响终端服务"," 更改终端端口号", "3389", 100, 100)
If imputport<>"" Then
If IsNumeric(imputport) Then
WshShell.RegWrite "HKLMSYSTEMCurrentControlSetControlTerminal ServerWdsrdpwdTdstcpPortNumber",imputport,"REG_DWORD"
WshShell.RegWrite "HKLMSYSTEMCurrentControlSetControlTerminal ServerWinStationsRDP-TcpPortNumber",imputport,"REG_DWORD"
wscript.echo "操作成功"
Else wscript.echo "输入出错，请重新输入"
Imput()
End If
Else wscript.echo "操作已经取消"
End If
End Function
Imput()
set WshShell=nothing

