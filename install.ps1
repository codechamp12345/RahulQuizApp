# Enhanced Setup Script for Quiz System
$ErrorActionPreference = "Stop"

function Write-Log {
    param($Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Host "[$timestamp] $Message"
    Add-Content -Path "D:\College Quiz System\install.log" -Value "[$timestamp] $Message"
}

try {
    Write-Log "Starting Quiz System installation..."

    # Create application directory
    $appPath = "D:\College Quiz System"
    if (-not (Test-Path $appPath)) {
        New-Item -ItemType Directory -Path $appPath -Force
    }

    # Download Python installer
    Write-Log "Downloading Python 3.11..."
    $url = "https://www.python.org/ftp/python/3.11.8/python-3.11.8-amd64.exe"
    $installer = "$env:TEMP\python-installer.exe"
    Invoke-WebRequest -Uri $url -OutFile $installer

    # Install Python with PATH option
    Write-Log "Installing Python..."
    Start-Process -FilePath $installer -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait -NoNewWindow
    Remove-Item $installer

    # Refresh environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    # Create virtual environment
    Write-Log "Creating virtual environment..."
    python -m venv "$appPath\venv"

    # Install requirements with correct versions
    Write-Log "Installing requirements..."
    & "$appPath\venv\Scripts\python.exe" -m pip install --upgrade pip
    & "$appPath\venv\Scripts\pip.exe" install Django==4.2.11 channels==4.0.0 channels-redis==4.1.0 redis==5.0.1

    # Copy project files
    Write-Log "Copying project files..."
    Copy-Item -Path "d:\xyz\quiz project\*" -Destination $appPath -Recurse -Force -Exclude "venv", "desktop-app", "installer"

    # Create startup batch file
    $startupScript = @"
@echo off
echo Starting College Quiz System...
cd /d "D:\College Quiz System"
call venv\Scripts\activate.bat

REM Check if Redis is running
sc query Redis > nul
if errorlevel 1 (
    echo Starting Redis service...
    net start Redis
)

REM Run migrations
echo Running database migrations...
python manage.py migrate

REM Start server
echo Starting server...
python manage.py runserver 0.0.0.0:8000
"@

    $startupScript | Out-File -FilePath "$appPath\start.bat" -Encoding ASCII -Force

    # Create a VBS wrapper to hide the command window
    $vbsWrapper = @"
Set objShell = CreateObject("WScript.Shell")
objShell.Run "cmd /c D:\College Quiz System\start.bat", 0
"@

    $vbsWrapper | Out-File -FilePath "$appPath\QuizSystem.vbs" -Encoding ASCII -Force

    # Create desktop and start menu shortcuts
    $WshShell = New-Object -comObject WScript.Shell
    
    # Desktop shortcut
    $Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\College Quiz System.lnk")
    $Shortcut.TargetPath = "$appPath\QuizSystem.vbs"
    $Shortcut.WorkingDirectory = $appPath
    $Shortcut.Save()

    # Start Menu shortcut
    $startMenuPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\College Quiz System"
    New-Item -ItemType Directory -Force -Path $startMenuPath
    $Shortcut = $WshShell.CreateShortcut("$startMenuPath\College Quiz System.lnk")
    $Shortcut.TargetPath = "$appPath\QuizSystem.vbs"
    $Shortcut.WorkingDirectory = $appPath
    $Shortcut.Save()

    # Create troubleshooting script
    $troubleshootScript = @"
@echo off
echo College Quiz System Troubleshooter
echo ================================
echo.

cd /d "D:\College Quiz System"

echo Checking Python installation...
python --version
if errorlevel 1 (
    echo Python is not installed correctly
    exit /b 1
)

echo.
echo Checking virtual environment...
if not exist venv\Scripts\python.exe (
    echo Virtual environment is missing
    exit /b 1
)

echo.
echo Checking Redis service...
sc query Redis
if errorlevel 1 (
    echo Redis service is not running
    echo Starting Redis...
    net start Redis
)

echo.
echo Checking database...
venv\Scripts\python.exe manage.py migrate

echo.
echo Checking dependencies...
venv\Scripts\pip.exe list

echo.
echo All checks complete!
pause
"@

    $troubleshootScript | Out-File -FilePath "$appPath\troubleshoot.bat" -Encoding ASCII -Force

    Write-Log "Installation completed successfully!"
    Write-Log "You can now run the application from:"
    Write-Log "1. Desktop shortcut"
    Write-Log "2. Start Menu"
    Write-Log "If you encounter any issues, run troubleshoot.bat"

} catch {
    Write-Log "Error: $_"
    Write-Log "Installation failed. Please check install.log for details."
    throw
}
