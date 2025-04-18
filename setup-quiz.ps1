# Setup script for Quiz System
Write-Host "Setting up Quiz System..." -ForegroundColor Green

# Install Visual C++ Redistributable
Write-Host "Installing Visual C++ Redistributable..." -ForegroundColor Yellow
$vcRedistUrl = "https://aka.ms/vs/17/release/vc_redist.x64.exe"
$vcRedistInstaller = "$env:TEMP\vc_redist.x64.exe"
Invoke-WebRequest -Uri $vcRedistUrl -OutFile $vcRedistInstaller
Start-Process -FilePath $vcRedistInstaller -ArgumentList "/quiet /norestart" -Wait -NoNewWindow
Remove-Item $vcRedistInstaller

# Download and install Python 3.9
Write-Host "Installing Python 3.9..." -ForegroundColor Yellow
$pythonUrl = "https://www.python.org/ftp/python/3.9.0/python-3.9.0-amd64.exe"
$pythonInstaller = "$env:TEMP\python-installer.exe"
Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstaller

# Install Python with all options
Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0 Include_pip=1" -Wait -NoNewWindow
Remove-Item $pythonInstaller

# Refresh environment variables
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Create application directory
$appPath = "D:\College Quiz System"
if (Test-Path $appPath) {
    Write-Host "Removing existing installation..." -ForegroundColor Yellow
    Remove-Item -Path $appPath -Recurse -Force
}
New-Item -ItemType Directory -Path $appPath -Force

# Copy project files first
Write-Host "Copying project files..." -ForegroundColor Yellow
Copy-Item -Path "d:\xyz\quiz project\*" -Destination $appPath -Recurse -Force -Exclude @("venv", "env", ".venv", "__pycache__", "*.pyc", "desktop-app", "installer", "build", "dist")

# Create and activate virtual environment
Write-Host "Creating virtual environment..." -ForegroundColor Yellow
Start-Process -FilePath "python" -ArgumentList "-m venv `"$appPath\venv`"" -Wait -NoNewWindow
& "$appPath\venv\Scripts\activate.ps1"

# Install core requirements
Write-Host "Installing Django and core requirements..." -ForegroundColor Yellow
Start-Process -FilePath "$appPath\venv\Scripts\python.exe" -ArgumentList "-m pip install --upgrade pip setuptools wheel" -Wait -NoNewWindow
Start-Process -FilePath "$appPath\venv\Scripts\pip.exe" -ArgumentList "install -r `"$appPath\requirements-minimal.txt`"" -Wait -NoNewWindow

# Initialize database
Write-Host "Initializing database..." -ForegroundColor Yellow
Set-Location -Path $appPath
Start-Process -FilePath "$appPath\venv\Scripts\python.exe" -ArgumentList "manage.py makemigrations" -Wait -NoNewWindow
Start-Process -FilePath "$appPath\venv\Scripts\python.exe" -ArgumentList "manage.py migrate" -Wait -NoNewWindow

# Create a superuser for admin access
Write-Host "Creating admin user..." -ForegroundColor Yellow
$adminUsername = "admin"
$adminEmail = "admin@example.com"
$adminPassword = "admin123"

$createSuperUser = @"
from django.contrib.auth import get_user_model
User = get_user_model()
if not User.objects.filter(username='$adminUsername').exists():
    User.objects.create_superuser('$adminUsername', '$adminEmail', '$adminPassword')
"@

Start-Process -FilePath "$appPath\venv\Scripts\python.exe" -ArgumentList "manage.py shell -c `"$createSuperUser`"" -Wait -NoNewWindow

# Copy startup script
Write-Host "Creating startup script..." -ForegroundColor Yellow
Copy-Item -Path "d:\xyz\quiz project\start_quiz_system.bat" -Destination $appPath -Force

# Create desktop shortcut
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\College Quiz System.lnk")
$Shortcut.TargetPath = "cmd.exe"
$Shortcut.Arguments = "/c `"`"$appPath\start_quiz_system.bat`"`""
$Shortcut.WorkingDirectory = $appPath
$Shortcut.Description = "College Quiz System"
$Shortcut.Save()

Write-Host "Setup complete!" -ForegroundColor Green
Write-Host "Default admin credentials:" -ForegroundColor Yellow
Write-Host "Username: admin" -ForegroundColor Yellow
Write-Host "Password: admin123" -ForegroundColor Yellow
Write-Host "
To start the application:" -ForegroundColor Green
Write-Host "1. Double-click the 'College Quiz System' shortcut on your desktop" -ForegroundColor White
