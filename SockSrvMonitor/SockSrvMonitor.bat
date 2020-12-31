@echo off&setlocal enabledelayedexpansion
rem **************************************************************************************************
rem 功能说明：循环等待，每隔1分钟tcping64对应的地址和端口是否畅通                                    *
rem 1、tcping64对应的地址和端口是否畅通;                                                             *
rem 2、如果不同，停止所有服务并重新启动；                                                            *
rem 3、如果畅通，等等60秒，然后跳转到loop重新tcping64对应的地址和端口；                              *
rem **************************************************************************************************
echo.
ping 127.0.0.1 -n 2 > nul
echo **************************************************************************
echo * 1-Get increment PatientID file list begin time is :%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% *
echo **************************************************************************

rem 设置对应的目录变量
rem 监控bat路径
set moni_dir=D:\SockSrvMonitor
rem 需要启动的应用程序的路径
set app_dir=D:\app_dir

rem Sock服务器信息
rem 监控：tcp://0.0.0.0:1235
rem web通知：websocket://0.0.0.0:1236
rem 温湿度：tcp://0.0.0.0:1234
set sockSrv_websocket=192.168.0.188 1236
set sockSrv_tcp_JK=192.168.0.188 1235
set sockSrv_tcp_WSD=192.168.0.188 1234

cd /d %moni_dir%

rem 1、循环等待，每隔1分钟tcping64对应的地址和端口是否畅通
:loop
echo begin next cycle......111111111
rem a、判断网路和端口是否畅通
echo check if network is normal...
tcping64.exe %sockSrv_websocket% -n 10 | findstr /i "open" >nul
if %errorlevel% neq 0 (
    echo tcping64.exe %sockSrv_websocket% is error...2222
    goto :socksrv_abnormal
)

tcping64.exe %sockSrv_tcp_JK% -n 10 | findstr /i "open" >nul
if %errorlevel% neq 0 (
    echo tcping64.exe %sockSrv_tcp_JK% is error...3333
    goto :socksrv_abnormal
)

tcping64.exe %sockSrv_tcp_WSD% -n 10 | findstr /i "open" >nul
if %errorlevel% neq 0 (
    echo tcping64.exe %sockSrv_tcp_WSD% is error...4444
    goto :socksrv_abnormal
)

rem 2、网路正常
rem 循环等待1分钟
ping 127.0.0.1 -n 60 > nul
goto :loop

rem 3、网路异常，如果能查询到php.exe，则需要先退出php.exe，然后再重启；否则直接重启php.exe；
:socksrv_abnormal
echo network is error...
rem 需要先退出php.exe
taskkill /F /IM php.exe /T > nul
rem 然后再重启
%app_dir%\php video.php start
ping 127.0.0.1 -n 15 > nul
goto :loop

echo.
echo ************************************************
echo * Over time of the BAT is :%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% *
echo ************************************************
echo.
