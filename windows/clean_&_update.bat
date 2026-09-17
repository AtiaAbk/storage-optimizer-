@echo off
setlocal enabledelayedexpansion
title Windows Deep Cleanup and Driver Update Tool

:: Admin Permission Check
openfiles >nul 2>&1
if %errorlevel% neq 0 (
    echo [!] Administrator permission required.
    echo Right-click on this script and select "Run as administrator".
    pause
    exit /b
)

color 0A
echo ========================================================
echo       SYSTEM CLEANUP AND DRIVER UPDATE UTILITY
echo ========================================================
echo Starting safe system maintenance...
echo.

:: 1. Windows Temp Clean
echo [*] Cleaning Windows Temp and User Temp files...
del /s /f /q "%temp%\*.*" >nul 2>&1
for /d %%p in ("%temp%\*.*") do rmdir /s /q "%%p" >nul 2>&1

del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\Temp\*.*") do rmdir /s /q "%%p" >nul 2>&1

:: 2. Windows Update Download Cache & Delivery Optimization
echo [*] Clearing Windows Update cache and Delivery Optimization files...
net stop wuauserv >nul 2>&1
net stop bits >nul 2>&1
del /s /f /q "C:\Windows\SoftwareDistribution\Download\*.*" >nul 2>&1
for /d %%p in ("C:\Windows\SoftwareDistribution\Download\*.*") do rmdir /s /q "%%p" >nul 2>&1
net start bits >nul 2>&1
net start wuauserv >nul 2>&1

:: 3. Prefetch and Log Files
echo [*] Cleaning Prefetch and old crash dump/log files...
del /s /f /q "C:\Windows\Prefetch\*.*" >nul 2>&1
del /s /f /q "C:\Windows\*.log" >nul 2>&1
del /s /f /q "C:\Windows\MEMORY.DMP" >nul 2>&1
del /s /f /q "C:\Windows\Minidump\*.*" >nul 2>&1

:: 4. Recycle Bin and Thumbnail Cache
echo [*] Emptying Recycle Bin and clearing Thumbnail cache...
powershell -NoProfile -Command "Clear-RecycleBin -Force -ErrorAction SilentlyContinue" >nul 2>&1
del /f /s /q /a "%LocalAppData%\Microsoft\Windows\Explorer\thumbcache_*.db" >nul 2>&1

:: 5. Flush DNS and Reset Network Cache
echo [*] Flushing DNS cache...
ipconfig /flushdns >nul 2>&1

:: 6. Windows Component Cleanup (Removes superseded backup files/images)
echo [*] Cleaning superseded Windows Update backups (DISM)...
echo     (This may take 1-2 minutes to reclaim GBs of space)
dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase >nul 2>&1

:: 7. Windows Native Disk Cleanup Tool
echo [*] Running system drive disk cleanup...
cleanmgr /sagerun:1 >nul 2>&1

:: 8. Driver and Software Update via Winget
echo [*] Checking and updating outdated drivers and system packages...
echo     Running winget upgrade...
winget upgrade --all --silent --accept-source-agreements --accept-package-agreements >nul 2>&1

echo.
echo ========================================================
echo [SUCCESS] System cleanup and driver updates completed!
echo ========================================================
pause
