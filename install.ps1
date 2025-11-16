# ============================================================
# Docker Cleanup Pro Installer for Windows
# ============================================================

$installDir = "$env:USERPROFILE\.local\bin"
$scriptUrl = "https://raw.githubusercontent.com/mtpontes/docker-cleanup-pro/refs/heads/main/docker-cleanup-pro.ps1"
$scriptPath = Join-Path $installDir "docker-cleanup-pro.ps1"

# Create directory if it does not exist
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir | Out-Null
}

# Download script
Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath

# Unblock
Unblock-File -Path $scriptPath

# Add to PATH if needed
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")

if ($currentPath -notlike "*$installDir*") {
    [Environment]::SetEnvironmentVariable(
        "Path",
        "$currentPath;$installDir",
        "User"
    )
    Write-Output "Path updated. You may need to restart your terminal."
}

Write-Output "Docker Cleanup Pro installed successfully."
Write-Output "Run: docker-cleanup-pro"
