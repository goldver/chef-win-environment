@echo off
echo.
echo ----------------------------------------------------------------
echo ----             Installation of Chef Enviroment            ----
echo ----------------------------------------------------------------
echo.

echo Running Powershell script...
::set HTTPS_PROXY=http://proxy.server.com:8080

:: Calling to PS script
PowerShell.exe -Executionpolicy bypass -File %~dp0install.ps1

IF %ERRORLEVEL% EQU 0 (
    ECHO Script was run successfully
) Else (
	ECHO Setup encountred an error
)
	
cmd /k 

