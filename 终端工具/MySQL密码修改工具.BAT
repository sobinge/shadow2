@title  MySQL密码修改工具
@echo off
@color 0a
@ECHO ┏━━━━━━━━━━┥          www.cnaaa.com         ┝━━━━━━━━━┓
@ECHO ┃                                    提示:                                 ┃
@ECHO ┃                        MySQL默认安装的服务名为MySQL                      ┃
@ECHO ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
:confg_servnm
set /p servnm=-^> 请输入MySQL的服务名(回车为默认的"MySQL"): 
if "%servnm%"=="" set "%servnm%"=="MySQL"
:reset_mydpwd
set /p newpwd=-^> 请输入新的 root 密码: 
if "%newpwd%"=="" goto reset_mydpwd
echo use MySQL >C:\mysqlpass.txt
echo update user set password=password('%newpwd%') where user="root";>>C:\mysqlpass.txt
echo flush privileges; >>C:\mysqlpass.txt
net stop %servnm% 2>nul
reg query "HKLM\SYSTEM\ControlSet001\Services\%servnm%" /t REG_EXPAND_SZ |find /i "image" >C:\mysql.txt
if %errorlevel% neq 0 goto exit
FOR /F "tokens=2,3* delims= " %%i in (C:\mysql.txt) do echo %%j %%k >C:\mysqltemp.txt
FOR /F "tokens=1 delims=-" %%i in (C:\mysqltemp.txt) do set mysqlpath=%%i
del C:\mysql.txt /f
del C:\mysqltemp.txt /f
set mysqlpath=%mysqlpath:/=\%
set mysqlpath=%mysqlpath:"=%
SET mysqlpath=%mysqlpath:~0,-6%
if %mysqlpath:~-1% neq \ set mysqlpath=%mysqlpath:~0,-1%
cd /d "%mysqlpath%"
start mysqld-nt.exe --skip-grant-tables
mysql <C:\mysqlpass.txt
if %errorlevel% neq 0 goto out
goto ok
:exit
echo 没有发现MYSQL
pause
del C:\mysqlpass.txt /f
exit
:out
echo 密码设置失败
pause
del C:\mysqlpass.txt /f
exit
:ok
del C:\mysqlpass.txt /f
taskkill /f /im mysqld-nt.exe >nul
@ECHO ┏━━━━━━━━━━┥         www.cnaaa.com          ┝━━━━━━━━━┓
@ECHO ┃                                                                          ┃
@ECHO ┃                            root密码修改成功!                             ┃
@ECHO ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
echo www.cnaaa.com|clip
net start %servnm%
@pause
