@echo off
echo.
echo -----------------------------------------------------------------
echo ----       Uninstalling Automation Environment Script        ----
echo -----------------------------------------------------------------
echo.

echo Running Powershell script...
::set HTTPS_PROXY=http://proxy.wdf.sap.corp:8080

:: Calling to PS script
PowerShell.exe -Executionpolicy bypass -File %~dp0uninstall.ps1

IF %ERRORLEVEL% EQU 0 (
    ECHO Script was run successfully
) Else (
	ECHO Setup encountred an error
)
	
cmd /k 

