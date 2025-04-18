# Build script for Quiz System
Write-Host "Building Quiz System Executable..." -ForegroundColor Green

# Ensure we're in the correct directory
$projectPath = "D:\College Quiz System"
Set-Location -Path $projectPath

# Activate virtual environment
& "$projectPath\venv\Scripts\activate.ps1"

# Build the executable using PyInstaller
Write-Host "Creating executable..." -ForegroundColor Yellow
& "$projectPath\venv\Scripts\pyinstaller.exe" --onefile --windowed --icon="$projectPath\static\images\favicon.ico" --name="QuizSystem" "$projectPath\quiz_app.py"

# Copy necessary files to dist folder
Write-Host "Copying project files..." -ForegroundColor Yellow
Copy-Item -Path "$projectPath\*" -Destination "$projectPath\dist\QuizSystem" -Recurse -Force -Exclude "build", "dist", "__pycache__", "*.pyc"

# Create desktop shortcut to the executable
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\College Quiz System.lnk")
$Shortcut.TargetPath = "$projectPath\dist\QuizSystem.exe"
$Shortcut.WorkingDirectory = "$projectPath\dist"
$Shortcut.Description = "College Quiz System"
$Shortcut.Save()

Write-Host "Build complete!" -ForegroundColor Green
Write-Host "You can now run the application from the desktop shortcut" -ForegroundColor Green
