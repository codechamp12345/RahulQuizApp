@echo off
setlocal enabledelayedexpansion

:: Set error messages to be in English
chcp 437 > nul

:: Set title
title College Quiz System

:: Run with elevated privileges if needed
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrative privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c cd /d \"%~dp0\" && \"%~f0\"' -Verb RunAs"
    exit /b
)

echo Starting College Quiz System...
echo Working directory: %CD%

:: Change to the application directory
cd /d "D:\College Quiz System"
if %ERRORLEVEL% NEQ 0 (
    echo Error: Could not change to application directory.
    echo Please make sure "D:\College Quiz System" exists.
    pause
    exit /b 1
)

:: Check Python installation
python --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Error: Python is not installed or not in PATH
    echo Please run the setup script again: setup-quiz.ps1
    pause
    exit /b 1
)

:: Activate virtual environment
if exist "venv\Scripts\activate.bat" (
    call "venv\Scripts\activate.bat"
) else (
    echo Error: Virtual environment not found
    echo Please run the setup script again: setup-quiz.ps1
    pause
    exit /b 1
)

:: Check Django installation
python -c "import django" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Installing Django and requirements...
    python -m pip install -r requirements-minimal.txt
    if %ERRORLEVEL% NEQ 0 (
        echo Error: Failed to install requirements
        pause
        exit /b 1
    )
)

:: Check if port 8000 is available
netstat -an | find "8000" >nul
if %ERRORLEVEL% EQU 0 (
    echo Error: Port 8000 is already in use
    echo Please close any other Django servers and try again
    pause
    exit /b 1
)

:: Start the server
echo Starting Django server...
start "" http://localhost:8000
python manage.py runserver

pause
