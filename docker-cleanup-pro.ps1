# ============================================================
# DOCKER CLEANUP PRO v1.0
# ============================================================
# Professional Docker cleanup script
# Created by: Matheus Nevoa
# Linkedin: https://www.linkedin.com/in/matheusnevoa/
# Github: https://github.com/matheusnevoa
#
# Adapted for Windows by: Mateus Pontes
# Fork: https://github.com/mtpontes/docker-cleanup-pro
# ============================================================

param(
    [Parameter(Mandatory=$false)]
    [string]$Command,

    [switch]$Y
)

function Show-Banner {
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host "           DOCKER CLEANUP PRO v1.1" -ForegroundColor Cyan
    Write-Host "==============================================" -ForegroundColor Cyan
    Write-Host ""
}

function Show-DiskUsage {
    Write-Host "System usage report:" -ForegroundColor Blue
    Write-Host "----------------------------------------------"
    
    Write-Host "Docker usage:" -ForegroundColor White
    try { docker system df 2>$null }
    catch { Write-Host "Docker not found or not running" -ForegroundColor Red }
    
    Write-Host ""
    Write-Host "Disk usage:" -ForegroundColor White

    $drive = Get-PSDrive C | Select-Object Used, Free
    $total = $drive.Used + $drive.Free
    $usedGB = [math]::Round($drive.Used / 1GB, 2)
    $totalGB = [math]::Round($total / 1GB, 2)
    $percentUsed = [math]::Round(($drive.Used / $total) * 100, 2)

    Write-Host ("Used: {0} GB / {1} GB ({2} percent)" -f $usedGB, $totalGB, $percentUsed)
    Write-Host ""
}

function Count-Resources {
    $containers = (docker ps -aq 2>$null).Count
    $images = (docker images -q 2>$null).Count
    $volumes = (docker volume ls -q 2>$null).Count
    $networks = (docker network ls -q 2>$null).Count
    
    Write-Host "Docker resources found:" -ForegroundColor White
    Write-Host "  Containers: $containers"
    Write-Host "  Images: $images"
    Write-Host "  Volumes: $volumes"
    Write-Host "  Networks: $networks"
    Write-Host ""
}

function Invoke-BasicCleanup {
    Write-Host "Running basic cleanup..." -ForegroundColor Green
    docker container prune -f
    docker network prune -f
    docker image prune -f
    Write-Host "Basic cleanup completed." -ForegroundColor Green
}

function Invoke-AdvancedCleanup {
    Write-Host "Running advanced cleanup..." -ForegroundColor Yellow
    docker volume prune -f
    docker image prune -a -f
    docker builder prune -f
    Write-Host "Advanced cleanup completed." -ForegroundColor Yellow
}

function Invoke-TotalCleanup {
    if (-not $Y) {
        $confirm = Read-Host "Are you sure you want to clean everything? (y/N)"
        if ($confirm -notmatch '^[yY]') {
            Write-Host "Total cleanup aborted by user." -ForegroundColor Cyan
            return
        }
    }

    Write-Host "Running TOTAL cleanup..." -ForegroundColor Red
    docker system prune -a --volumes -f
    Write-Host "Total cleanup completed." -ForegroundColor Red
}

function Show-Help {
    Write-Host ""
    Write-Host "Usage:"
    Write-Host "  docker-cleanup <command>"
    Write-Host ""
    Write-Host "Available commands:"
    Write-Host "  basic-cleanup     | bc       Runs basic cleanup"
    Write-Host "  advanced-cleanup  | ac       Runs advanced cleanup"
    Write-Host "  total-cleanup     | tc       Runs total cleanup (use -y to skip confirmation)"
    Write-Host "  disk-report       | dr       Shows system usage report"
    Write-Host ""
}

# =======================
# CLI entry point
# =======================

Show-Banner

if (-not $Command) {
    Show-Help
    exit 0
}

switch ($Command.ToLower()) {

    "basic-cleanup" { Invoke-BasicCleanup }
    "bc"            { Invoke-BasicCleanup }

    "advanced-cleanup" { Invoke-AdvancedCleanup }
    "ac"               { Invoke-AdvancedCleanup }

    "total-cleanup" { Invoke-TotalCleanup }
    "tc"            { Invoke-TotalCleanup }

    "disk-report" { 
        Show-DiskUsage
        Count-Resources
    }
    "dr" {
        Show-DiskUsage
        Count-Resources
    }

    default {
        Write-Host "Invalid command: $Command" -ForegroundColor Red
        Show-Help
        exit 1
    }
}

exit 0
