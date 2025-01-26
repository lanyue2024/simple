@echo off
chcp 65001 >NUL

Powershell.exe -executionpolicy remotesigned -File bin/gencert.ps1
echo 启动nginx...
start bin/nginx.exe
