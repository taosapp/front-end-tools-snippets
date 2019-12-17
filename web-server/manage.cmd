@echo off
rem windows�¹���nginx�������ر�

ECHO.====================���뿪ʼ====================
cls
SET NGINX_PATH=D:
SET NGINX_DIR=D:\web-server\nginx\
SET PHP_DIR=D:\web-server\php\
SET MYSQL_DIR=C:\Program Files\MySQL\MySQL Server 8.0\
SET MYSQL_BIN=%MYSQL_DIR%bin\
color 0a

TITLE Nginx + PHP + MySQL �������

CLS

:MENU

ECHO.   ________________________________________________________________
ECHO.  ^|                                                                ^|
ECHO.  ^|               Nginx + PHP + MySQL  -  �������                 ^|
ECHO.  ^|                                                                ^|
ECHO.  ^|    1 - ����Nginx           2 - �ر�Nginx     3 - ����Nginx     ^|
ECHO.  ^|    4 - ����PHP-CGI         5 - �ر�PHP-CGI   6 - ����PHP-CGI   ^|
ECHO.  ^|    7 - ����MySQL           8 - �ر�MySQL     9 - ����MySQL     ^|
ECHO.  ^|                                                                ^|
ECHO.  ^|                         0 - �� ��                              ^|
ECHO.  ^|________________________________________________________________^|
ECHO.
ECHO.������ѡ����Ŀ�����:
set /p ID=
    IF "%id%"=="1" GOTO start_nginx
    IF "%id%"=="2" GOTO stop_nginx
    IF "%id%"=="3" GOTO restart_nginx
    IF "%id%"=="4" GOTO start_php
    IF "%id%"=="5" GOTO stop_php
    IF "%id%"=="6" GOTO restart_php
    IF "%id%"=="7" GOTO start_mysql
    IF "%id%"=="8" GOTO stop_mysql
    IF "%id%"=="9" GOTO restart_mysql
    IF "%id%"=="0" EXIT
PAUSE

:start_nginx
    CLS
    tasklist|findstr /i "nginx.exe"&&call :nginx_exist||call :startNginx
    GOTO MENU

:nginx_exist
    set all=
    set /p all= �ý����Ѿ����ڣ������Ƿ���Ҫ����?[y/n]
    if /i "%all%"=="y" GOTO restart_nginx
    if /i "%all%"=="n" GOTO MENU
:stop_nginx
    CLS
    tasklist|findstr /i "nginx.exe"&&call :shutdownNginx|| ECHO [  Nginx�ƺ�û������!  ]
    GOTO MENU

:restart_nginx
    CLS
    call :shutdownNginx
    call :startNginx
    GOTO MENU

:shutdownNginx
    ECHO.
    ECHO.[  �ر�Nginx......  ]
    taskkill /F /IM nginx.exe > nul
    ECHO.[  OK,�ر�����nginx ���� ]
    goto :eof

:startNginx
    ECHO.
    ECHO.[  ����Nginx......  ]
    IF NOT EXIST "%NGINX_DIR%nginx.exe" ECHO [ "%NGINX_DIR%nginx.exe"������ ]

    %NGINX_PATH%

    cd "%NGINX_DIR%"

    IF EXIST "%NGINX_DIR%nginx.exe" (
        start nginx.exe
    )
    ECHO.[  OK  ]
    goto :eof

:start_php
    CLS
    tasklist|findstr /i "php-cgi.exe"&&call :php_exist||call :startPHP
    GOTO MENU

:php_exist
    set all=
    set /p all= �ý����Ѿ����ڣ������Ƿ���Ҫ����?[y/n]
    if /i "%all%"=="y" GOTO restart_php
    if /i "%all%"=="n" GOTO MENU

:stop_php
    CLS
    tasklist|findstr /i "php-cgi.exe"&&call :shutdownPHP|| ECHO [  php-cgi�ƺ�û������!  ]
    GOTO MENU

:restart_php
    CLS
    call :shutdownPHP
    call :startPHP
    GOTO MENU

:shutdownPHP
    ECHO.
    ECHO.[  �ر�php-cgi......  ]
    taskkill /F /IM php-cgi.exe > nul
    ECHO.[  OK  ]
    goto :eof

:startPHP
    ECHO.
    ECHO.[  ����php-cgi......  ]

    IF NOT EXIST %PHP_DIR%php-cgi.exe ECHO [  %PHP_DIR%php-cgi.exe������  ]
    echo set wscriptObj = CreateObject("Wscript.Shell") >start_cgi.vbs
    echo wscriptObj.run "%PHP_DIR%php-cgi.exe -b 127.0.0.1:9000",0 >>start_cgi.vbs
    start_cgi.vbs
    del start_cgi.vbs
    ECHO.[  OK  ]
    goto :eof

:start_mysql
    CLS
    tasklist|findstr /i "mysqld.exe"&&call :mysql_exist||call :startMYSQL
    GOTO MENU

:mysql_exist
    set all=
    set /p all= �ý����Ѿ����ڣ������Ƿ���Ҫ����?[y/n]
    if /i "%all%"=="y" GOTO restart_mysql
    if /i "%all%"=="n" GOTO MENU

:stop_mysql
    CLS
    tasklist|findstr /i "mysqld.exe"&&call :shutdownMYSQL|| ECHO [  MYSQL�ƺ�û������!  ]
    GOTO MENU

:restart_mysql
    CLS
    call :shutdownMYSQL
    call :startMYSQL
    GOTO MENU

:shutdownMYSQL
    ECHO.
    ECHO.[  �ر�mysql......  ]
    cd %MYSQL_BIN%
    mysqladmin -uroot -p shutdown
    ECHO.[  OK  ]
    goto :eof

:startMYSQL
    ECHO.
    IF NOT EXIST %MYSQL_BIN%mysqld.exe ECHO [  %MYSQL_BIN%mysqld.exe������  ]
    cd %MYSQL_BIN%
    start mysqld
    ECHO.[  ����mysql......  ]
    ECHO.[  OK  ]
    goto :eof