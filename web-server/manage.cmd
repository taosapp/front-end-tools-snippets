@echo off
rem windows下管理nginx启动、关闭

ECHO.====================代码开始====================
cls
SET NGINX_PATH=D:
SET NGINX_DIR=D:\web-server\nginx\
SET PHP_DIR=D:\web-server\php\
SET MYSQL_DIR=C:\Program Files\MySQL\MySQL Server 8.0\
SET MYSQL_BIN=%MYSQL_DIR%bin\
color 0a

TITLE Nginx + PHP + MySQL 管理程序

CLS

:MENU

ECHO.   ________________________________________________________________
ECHO.  ^|                                                                ^|
ECHO.  ^|               Nginx + PHP + MySQL  -  控制面板                 ^|
ECHO.  ^|                                                                ^|
ECHO.  ^|    1 - 启动Nginx           2 - 关闭Nginx     3 - 重启Nginx     ^|
ECHO.  ^|    4 - 启动PHP-CGI         5 - 关闭PHP-CGI   6 - 重启PHP-CGI   ^|
ECHO.  ^|    7 - 启动MySQL           8 - 关闭MySQL     9 - 重启MySQL     ^|
ECHO.  ^|                                                                ^|
ECHO.  ^|                         0 - 退 出                              ^|
ECHO.  ^|________________________________________________________________^|
ECHO.
ECHO.请输入选择项目的序号:
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
    set /p all= 该进程已经存在，现在是否需要重启?[y/n]
    if /i "%all%"=="y" GOTO restart_nginx
    if /i "%all%"=="n" GOTO MENU
:stop_nginx
    CLS
    tasklist|findstr /i "nginx.exe"&&call :shutdownNginx|| ECHO [  Nginx似乎没有运行!  ]
    GOTO MENU

:restart_nginx
    CLS
    call :shutdownNginx
    call :startNginx
    GOTO MENU

:shutdownNginx
    ECHO.
    ECHO.[  关闭Nginx......  ]
    taskkill /F /IM nginx.exe > nul
    ECHO.[  OK,关闭所有nginx 进程 ]
    goto :eof

:startNginx
    ECHO.
    ECHO.[  启动Nginx......  ]
    IF NOT EXIST "%NGINX_DIR%nginx.exe" ECHO [ "%NGINX_DIR%nginx.exe"不存在 ]

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
    set /p all= 该进程已经存在，现在是否需要重启?[y/n]
    if /i "%all%"=="y" GOTO restart_php
    if /i "%all%"=="n" GOTO MENU

:stop_php
    CLS
    tasklist|findstr /i "php-cgi.exe"&&call :shutdownPHP|| ECHO [  php-cgi似乎没有运行!  ]
    GOTO MENU

:restart_php
    CLS
    call :shutdownPHP
    call :startPHP
    GOTO MENU

:shutdownPHP
    ECHO.
    ECHO.[  关闭php-cgi......  ]
    taskkill /F /IM php-cgi.exe > nul
    ECHO.[  OK  ]
    goto :eof

:startPHP
    ECHO.
    ECHO.[  启动php-cgi......  ]

    IF NOT EXIST %PHP_DIR%php-cgi.exe ECHO [  %PHP_DIR%php-cgi.exe不存在  ]
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
    set /p all= 该进程已经存在，现在是否需要重启?[y/n]
    if /i "%all%"=="y" GOTO restart_mysql
    if /i "%all%"=="n" GOTO MENU

:stop_mysql
    CLS
    tasklist|findstr /i "mysqld.exe"&&call :shutdownMYSQL|| ECHO [  MYSQL似乎没有运行!  ]
    GOTO MENU

:restart_mysql
    CLS
    call :shutdownMYSQL
    call :startMYSQL
    GOTO MENU

:shutdownMYSQL
    ECHO.
    ECHO.[  关闭mysql......  ]
    cd %MYSQL_BIN%
    mysqladmin -uroot -p shutdown
    ECHO.[  OK  ]
    goto :eof

:startMYSQL
    ECHO.
    IF NOT EXIST %MYSQL_BIN%mysqld.exe ECHO [  %MYSQL_BIN%mysqld.exe不存在  ]
    cd %MYSQL_BIN%
    start mysqld
    ECHO.[  启动mysql......  ]
    ECHO.[  OK  ]
    goto :eof