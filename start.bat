@echo off

Powershell.exe -executionpolicy remotesigned -File bin/gencert.ps1
start bin/nginx.exe

