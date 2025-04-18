# Setup script for Quiz System
Write-Host "Setting up Quiz System..." -ForegroundColor Green

# Check if Python is installed
$pythonPath = "C:\Python39\python.exe"
if (-not (Test-Path $pythonPath)) {
    Write-Host "Python 3.9 is not installed. Installing..." -ForegroundColor Yellow
    # Download Python installer
    $url = "https://www.python.org/ftp/python/3.9.0/python-3.9.0-amd64.exe"
    $installer = "$env:TEMP\python-installer.exe"
    Invoke-WebRequest -Uri $url -OutFile $installer
    
    # Install Python
    Start-Process -FilePath $installer -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1" -Wait
    Remove-Item $installer
}

# Create virtual environment
$venvPath = "D:\College Quiz System\venv"
Write-Host "Creating virtual environment at $venvPath..." -ForegroundColor Yellow
& $pythonPath -m venv $venvPath

# Activate virtual environment and install requirements
Write-Host "Installing requirements..." -ForegroundColor Yellow
& "$venvPath\Scripts\activate.ps1"
& "$venvPath\Scripts\pip.exe" install django==3.2.25 channels channels-redis redis

# Create the application directory if it doesn't exist
$appPath = "D:\College Quiz System"
if (-not (Test-Path $appPath)) {
    New-Item -ItemType Directory -Path $appPath -Force
}

# Copy project files
Write-Host "Copying project files..." -ForegroundColor Yellow
Copy-Item -Path "d:\xyz\quiz project\*" -Destination $appPath -Recurse -Force -Exclude "venv", "desktop-app", "installer"

# Create startup script
$startupScript = @"
@echo off
cd /d "D:\College Quiz System"
call venv\Scripts\activate.bat
python manage.py runserver
"@

$startupScript | Out-File -FilePath "$appPath\QuizSystem.bat" -Encoding ASCII -Force

# Create executable wrapper
$wrapperScript = @"
Set objShell = CreateObject("WScript.Shell")
objShell.Run "cmd /c D:\College Quiz System\QuizSystem.bat", 0
"@

$wrapperScript | Out-File -FilePath "$appPath\QuizSystem.vbs" -Encoding ASCII -Force

Write-Host "Setup complete!" -ForegroundColor Green
Write-Host "You can now run the application from D:\College Quiz System\QuizSystem.vbs" -ForegroundColor Green
