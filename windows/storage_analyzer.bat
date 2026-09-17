@echo off
setlocal enabledelayedexpansion
title Windows Storage Analysis Tool

set "OUTPUT_FILE=%~dp0storage_analysis_report.txt"

echo ===================================================
echo        WINDOWS STORAGE ANALYSIS TOOL
echo ===================================================
echo Scanning your system storage...
echo Please wait, this may take 30 to 60 seconds.
echo ---------------------------------------------------

(
    echo ========================================================
    echo             WINDOWS STORAGE ANALYSIS REPORT
    echo             Generated: %date% %time%
    echo ========================================================
    echo.
) > "%OUTPUT_FILE%"

echo [*] Checking Drive Free and Total Space...
(
    echo --------------------------------------------------------
    echo 1. LOGICAL DRIVES OVERVIEW
    echo --------------------------------------------------------
    powershell -NoProfile -Command "Get-PSDrive -PSProvider FileSystem | Select-Object Name, @{N='Used(GB)';E={[math]::round($_.Used/1GB,2)}}, @{N='Free(GB)';E={[math]::round($_.Free/1GB,2)}}, @{N='Total(GB)';E={[math]::round(($_.Used+$_.Free)/1GB,2)}} | Format-Table -AutoSize | Out-String -Width 120"
    echo.
) >> "%OUTPUT_FILE%"

echo [*] Scanning User Profile Folders (Downloads, AppData, etc.)...
(
    echo --------------------------------------------------------
    echo 2. USER PROFILE FOLDERS (Above 100MB)
    echo --------------------------------------------------------
    powershell -NoProfile -Command "Get-ChildItem -Path $HOME -Directory -Force -ErrorAction SilentlyContinue | ForEach-Object { $s = (Get-ChildItem -Path $_.FullName -Recurse -File -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum; [PSCustomObject]@{ Folder = $_.Name; 'Size(GB)' = [math]::Round($s / 1GB, 2) } } | Where-Object { $_.'Size(GB)' -gt 0.1 } | Sort-Object 'Size(GB)' -Descending | Format-Table -AutoSize | Out-String -Width 120"
    echo.
) >> "%OUTPUT_FILE%"

echo [*] Scanning C:\ Root Directories...
(
    echo --------------------------------------------------------
    echo 3. C:\ ROOT DIRECTORIES
    echo --------------------------------------------------------
    powershell -NoProfile -Command "Get-ChildItem -Path C:\ -Directory -Force -ErrorAction SilentlyContinue | ForEach-Object { $s = (Get-ChildItem -Path $_.FullName -Recurse -File -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum; [PSCustomObject]@{ Directory = $_.Name; 'Size(GB)' = [math]::Round($s / 1GB, 2) } } | Sort-Object 'Size(GB)' -Descending | Format-Table -AutoSize | Out-String -Width 120"
    echo.
) >> "%OUTPUT_FILE%"

echo [*] Checking Common Temp and Cache Folders...
(
    echo --------------------------------------------------------
    echo 4. TEMP AND CACHE FOLDERS
    echo --------------------------------------------------------
    powershell -NoProfile -Command "$paths = @('C:\Windows\Temp', $env:TEMP, 'C:\Windows\SoftwareDistribution\Download'); foreach ($p in $paths) { if (Test-Path $p) { $s = (Get-ChildItem -Path $p -Recurse -File -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum; [PSCustomObject]@{ Location = $p; 'Size(MB)' = [math]::Round($s / 1MB, 2) } } } | Format-Table -AutoSize | Out-String -Width 120"
    echo.
) >> "%OUTPUT_FILE%"

echo ========================================================
echo Scanning complete!
echo Report saved to: %OUTPUT_FILE%
echo Opening report now...
echo ========================================================

start notepad "%OUTPUT_FILE%"
pause
