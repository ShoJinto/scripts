rem �˽ű����ڼ��teamviewer�����Ƿ�����.
rem �����ļ��ŵ�teamviewer.exe��ͬ��Ŀ¼��,
rem Ȼ����windows�Ķ�ʱ���񼴿���ɼ�ر���teamviewer�����Ƿ�����,
rem ���teamviewer����ֹͣ��������
::      edit by   jtxiao 2015-09-10
@echo off
title ���teamviewer�Ƿ�����
color a
set "proc=teamviewer.exe"
tasklist|findstr /i %proc% >nul
if "%errorlevel%"=="1" start "%proc%"
if "%errorlevel%"=="0" echo "%proc% is running."
rem pause