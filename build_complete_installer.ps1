# Complete Installer Build Script for Quiz Application
# This script builds the Electron app and creates a single .exe installer

$ErrorActionPreference = "Stop"
$projectRoot = $PSScriptRoot
$desktopAppDir = Join-Path $projectRoot "desktop-app"
$installerDir = Join-Path $projectRoot "installer"
$dependenciesDir = Join-Path $installerDir "dependencies"
$distDir = Join-Path $projectRoot "dist"

# Create necessary directories
function EnsureDirectoryExists($path) {
    if (-not (Test-Path $path)) {
        New-Item -ItemType Directory -Path $path | Out-Null
        Write-Host "Created directory: $path" -ForegroundColor Green
    }
}

EnsureDirectoryExists $installerDir
EnsureDirectoryExists $dependenciesDir
EnsureDirectoryExists $distDir

# Step 1: Download dependencies if they don't exist
$nodeInstallerPath = Join-Path $dependenciesDir "node-v16.20.0-x64.msi"
$pythonInstallerPath = Join-Path $dependenciesDir "python-3.9.13-amd64.exe"

if (-not (Test-Path $nodeInstallerPath)) {
    Write-Host "Downloading Node.js installer..." -ForegroundColor Yellow
    $nodeUrl = "https://nodejs.org/dist/v16.20.0/node-v16.20.0-x64.msi"
    Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeInstallerPath
}

if (-not (Test-Path $pythonInstallerPath)) {
    Write-Host "Downloading Python installer..." -ForegroundColor Yellow
    $pythonUrl = "https://www.python.org/ftp/python/3.9.13/python-3.9.13-amd64.exe"
    Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstallerPath
}

# Step 2: Build the Electron app
Write-Host "Building Electron app..." -ForegroundColor Green
Set-Location $desktopAppDir

# Install dependencies if node_modules doesn't exist
if (-not (Test-Path (Join-Path $desktopAppDir "node_modules"))) {
    Write-Host "Installing npm dependencies..." -ForegroundColor Yellow
    npm install
}

# Build the Electron app
npm run dist

# Step 3: Copy the Electron build to the dist folder
$electronBuildDir = Join-Path $desktopAppDir "dist"
$electronAppDist = Join-Path $distDir "electron-app"

EnsureDirectoryExists $electronAppDist

# Find the unpacked directory in the Electron build
$unpackedDir = Get-ChildItem -Path $electronBuildDir -Filter "win-unpacked" -Recurse | Select-Object -First 1
if ($unpackedDir) {
    Write-Host "Copying Electron app to dist folder..." -ForegroundColor Yellow
    Copy-Item -Path "$($unpackedDir.FullName)\*" -Destination $electronAppDist -Recurse -Force
} else {
    Write-Error "Could not find the win-unpacked directory in the Electron build"
    exit 1
}

# Step 4: Build the Inno Setup installer
Write-Host "Building Inno Setup installer..." -ForegroundColor Green
$innoSetupPath = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if (-not (Test-Path $innoSetupPath)) {
    $innoSetupPath = "C:\Program Files\Inno Setup 6\ISCC.exe"
    if (-not (Test-Path $innoSetupPath)) {
        Write-Host "Inno Setup not found. Downloading and installing..." -ForegroundColor Yellow
        $innoSetupUrl = "https://files.jrsoftware.org/is/6/innosetup-6.2.1.exe"
        $innoSetupInstaller = Join-Path $dependenciesDir "innosetup-6.2.1.exe"
        Invoke-WebRequest -Uri $innoSetupUrl -OutFile $innoSetupInstaller
        Start-Process -FilePath $innoSetupInstaller -ArgumentList "/VERYSILENT /SUPPRESSMSGBOXES /NORESTART" -Wait
        Remove-Item $innoSetupInstaller -Force
        
        # Check again for Inno Setup
        $innoSetupPath = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
        if (-not (Test-Path $innoSetupPath)) {
            $innoSetupPath = "C:\Program Files\Inno Setup 6\ISCC.exe"
            if (-not (Test-Path $innoSetupPath)) {
                Write-Error "Failed to install Inno Setup. Please install it manually and try again."
                exit 1
            }
        }
    }
}

# Run Inno Setup compiler
$innoScript = Join-Path $installerDir "QuizApp-Complete.iss"
& $innoSetupPath $innoScript

# Step 5: Verify the installer was created
$installerPath = Join-Path $distDir "QuizApp-Complete-Installer.exe"
if (Test-Path $installerPath) {
    Write-Host "Installer created successfully: $installerPath" -ForegroundColor Green
} else {
    Write-Error "Failed to create installer"
    exit 1
}

Write-Host "Build process completed successfully!" -ForegroundColor Green
Write-Host "Installer location: $installerPath" -ForegroundColor Cyan
