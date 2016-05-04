rem 此脚本用于监控teamviewer进程是否运行.
rem 将此文件放到teamviewer.exe的同级目录中,
rem 然后做windows的定时任务即可完成监控本机teamviewer进程是否运行,
rem 如果teamviewer进程停止则启动它
::      edit by   jtxiao 2015-09-10
@echo off
title 检查teamviewer是否运行
color a
set "proc=teamviewer.exe"
tasklist|findstr /i %proc% >nul
if "%errorlevel%"=="1" start "%proc%"
if "%errorlevel%"=="0" echo "%proc% is running."
rem pause