@echo off&setlocal enabledelayedexpansion
rem **************************************************************************************************
rem ����˵����ѭ���ȴ���ÿ��1����tcping64��Ӧ�ĵ�ַ�Ͷ˿��Ƿ�ͨ                                    *
rem 1��tcping64��Ӧ�ĵ�ַ�Ͷ˿��Ƿ�ͨ;                                                             *
rem 2�������ͬ��ֹͣ���з�������������                                                            *
rem 3�������ͨ���ȵ�60�룬Ȼ����ת��loop����tcping64��Ӧ�ĵ�ַ�Ͷ˿ڣ�                              *
rem **************************************************************************************************
echo.
ping 127.0.0.1 -n 2 > nul
echo **************************************************************************
echo * 1-Get increment PatientID file list begin time is :%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% *
echo **************************************************************************

rem ���ö�Ӧ��Ŀ¼����
rem ���bat·��
set moni_dir=D:\SockSrvMonitor
rem ��Ҫ������Ӧ�ó����·��
set app_dir=D:\app_dir

rem Sock��������Ϣ
rem ��أ�tcp://0.0.0.0:1235
rem web֪ͨ��websocket://0.0.0.0:1236
rem ��ʪ�ȣ�tcp://0.0.0.0:1234
set sockSrv_websocket=192.168.0.188 1236
set sockSrv_tcp_JK=192.168.0.188 1235
set sockSrv_tcp_WSD=192.168.0.188 1234

cd /d %moni_dir%

rem 1��ѭ���ȴ���ÿ��1����tcping64��Ӧ�ĵ�ַ�Ͷ˿��Ƿ�ͨ
:loop
echo begin next cycle......111111111
rem a���ж���·�Ͷ˿��Ƿ�ͨ
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

rem 2����·����
rem ѭ���ȴ�1����
ping 127.0.0.1 -n 60 > nul
goto :loop

rem 3����·�쳣������ܲ�ѯ��php.exe������Ҫ���˳�php.exe��Ȼ��������������ֱ������php.exe��
:socksrv_abnormal
echo network is error...
rem ��Ҫ���˳�php.exe
taskkill /F /IM php.exe /T > nul
rem Ȼ��������
%app_dir%\php video.php start
ping 127.0.0.1 -n 15 > nul
goto :loop

echo.
echo ************************************************
echo * Over time of the BAT is :%date:~0,4%-%date:~5,2%-%date:~8,2% %time:~0,2%:%time:~3,2%:%time:~6,2% *
echo ************************************************
echo.
