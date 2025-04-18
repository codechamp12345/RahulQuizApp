@echo off
echo Building Complete Quiz Application Installer...
powershell -ExecutionPolicy Bypass -File "%~dp0build_complete_installer.ps1"
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ===================================================
    echo Build completed successfully!
    echo The installer can be found in the dist directory.
    echo ===================================================
    echo.
) else (
    echo.
    echo ===================================================
    echo Build failed! Check the error messages above.
    echo ===================================================
    echo.
)
pause
