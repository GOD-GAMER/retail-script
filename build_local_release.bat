@echo off
setlocal enabledelayedexpansion

REM ========================================
REM  Local Release Builder for Retail Jobs
REM  Builds a complete release package locally
REM ========================================

echo.
echo ==========================================
echo   FiveM Retail Jobs - Local Release Builder
echo ==========================================
echo.

REM Get current version from fxmanifest.lua
set "VERSION="
for /f "tokens=2 delims=''" %%a in ('findstr "version" fxmanifest.lua') do (
    set "VERSION=%%a"
)

if "%VERSION%"=="" (
    echo WARNING: Could not detect version from fxmanifest.lua
    set /p VERSION="Enter version manually (e.g., 0.0.6): "
)

echo Building release package for version: %VERSION%
echo.

REM Create timestamp for build
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "MIN=%dt:~10,2%" & set "SS=%dt:~12,2%"
set "TIMESTAMP=%YYYY%-%MM%-%DD%_%HH%-%MIN%-%SS%"

REM Define folders and files
set "RELEASE_FOLDER=retail_jobs"
set "BUILD_FOLDER=builds"

echo Creating build directory structure...
if exist "%BUILD_FOLDER%" rmdir /s /q "%BUILD_FOLDER%"
mkdir "%BUILD_FOLDER%"
mkdir "%BUILD_FOLDER%\%RELEASE_FOLDER%"

echo.
echo ===========================================
echo  COPYING ESSENTIAL FILES
echo ===========================================

REM Core resource files (REQUIRED)
echo [1/8] Copying core resource files...
copy "fxmanifest.lua" "%BUILD_FOLDER%\%RELEASE_FOLDER%\" >nul 2>&1
if exist "config.lua" copy "config.lua" "%BUILD_FOLDER%\%RELEASE_FOLDER%\" >nul 2>&1

REM Database files
echo [2/8] Copying database files...
if exist "database.sql" (
    copy "database.sql" "%BUILD_FOLDER%\%RELEASE_FOLDER%\" >nul 2>&1
    echo   ? database.sql included
) else (
    echo   ? database.sql not found - creating placeholder
    echo -- FiveM Retail Jobs Database Schema > "%BUILD_FOLDER%\%RELEASE_FOLDER%\database.sql"
    echo -- Version: %VERSION% >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\database.sql"
    echo -- This file should contain your MySQL database structure >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\database.sql"
)

REM Documentation files
echo [3/8] Copying documentation...
if exist "README.md" copy "README.md" "%BUILD_FOLDER%\%RELEASE_FOLDER%\" >nul 2>&1
if exist "LICENSE" copy "LICENSE" "%BUILD_FOLDER%\%RELEASE_FOLDER%\" >nul 2>&1
if exist "CHANGELOG.md" copy "CHANGELOG.md" "%BUILD_FOLDER%\%RELEASE_FOLDER%\" >nul 2>&1

REM Script folders
echo [4/8] Copying shared scripts...
if exist "shared" (
    xcopy "shared" "%BUILD_FOLDER%\%RELEASE_FOLDER%\shared\" /e /i /q >nul 2>&1
    echo   ? shared/ folder copied
) else (
    echo   ? shared/ folder not found
)

echo [5/8] Copying server scripts...
if exist "server" (
    xcopy "server" "%BUILD_FOLDER%\%RELEASE_FOLDER%\server\" /e /i /q >nul 2>&1
    echo   ? server/ folder copied
) else (
    echo   ? server/ folder not found
)

echo [6/8] Copying client scripts...
if exist "client" (
    xcopy "client" "%BUILD_FOLDER%\%RELEASE_FOLDER%\client\" /e /i /q >nul 2>&1
    echo   ? client/ folder copied
) else (
    echo   ? client/ folder not found
)

echo [7/8] Copying HTML/UI files...
if exist "html" (
    xcopy "html" "%BUILD_FOLDER%\%RELEASE_FOLDER%\html\" /e /i /q >nul 2>&1
    echo   ? html/ folder copied
) else (
    echo   ? html/ folder not found
)

REM Clean up any development files that shouldn't be in release
echo [8/8] Cleaning development files...
if exist "%BUILD_FOLDER%\%RELEASE_FOLDER%\*.bat" del "%BUILD_FOLDER%\%RELEASE_FOLDER%\*.bat" /q >nul 2>&1
if exist "%BUILD_FOLDER%\%RELEASE_FOLDER%\*.md" (
    REM Keep essential docs but remove development ones
    if exist "%BUILD_FOLDER%\%RELEASE_FOLDER%\GITHUB_SETUP_GUIDE.md" del "%BUILD_FOLDER%\%RELEASE_FOLDER%\GITHUB_SETUP_GUIDE.md" >nul 2>&1
    if exist "%BUILD_FOLDER%\%RELEASE_FOLDER%\NEW_FEATURES_*.md" del "%BUILD_FOLDER%\%RELEASE_FOLDER%\NEW_FEATURES_*.md" >nul 2>&1
    if exist "%BUILD_FOLDER%\%RELEASE_FOLDER%\IMPLEMENTATION_*.md" del "%BUILD_FOLDER%\%RELEASE_FOLDER%\IMPLEMENTATION_*.md" >nul 2>&1
    if exist "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_*.md" del "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_*.md" >nul 2>&1
    if exist "%BUILD_FOLDER%\%RELEASE_FOLDER%\FIVEM_*.md" del "%BUILD_FOLDER%\%RELEASE_FOLDER%\FIVEM_*.md" >nul 2>&1
)

echo.
echo ===========================================
echo  BUILD NAMING AND PACKAGING
echo ===========================================

REM Prompt for custom build name
echo ?? Custom Build Naming:
echo    You can create a custom name for this build to help identify its purpose.
echo.
echo ?? Examples:
echo    - numpad2-keybind
echo    - testing-fix
echo    - stable-backup
echo    - esx-compatibility
echo    - production-ready
echo    - feature-test
echo    - hotfix-v2
echo    - server-deploy
echo    - experimental
echo.
set /p CUSTOM_NAME="Enter custom build name (or press Enter for auto-generated): "

REM Generate final ZIP name
if "%CUSTOM_NAME%"=="" (
    set "ZIP_NAME=retail_jobs-v%VERSION%-auto_%TIMESTAMP%.zip"
    echo Using auto-generated name: %ZIP_NAME%
) else (
    REM Clean the custom name (remove invalid characters)
    set "CLEAN_NAME=%CUSTOM_NAME: =-%"
    set "CLEAN_NAME=%CLEAN_NAME:/=-%"
    set "CLEAN_NAME=%CLEAN_NAME:\=-%"
    set "CLEAN_NAME=%CLEAN_NAME:?=-%"
    set "CLEAN_NAME=%CLEAN_NAME:*=-%"
    set "CLEAN_NAME=%CLEAN_NAME:|=-%"
    set "CLEAN_NAME=%CLEAN_NAME:<=-%"
    set "CLEAN_NAME=%CLEAN_NAME:>=-%"
    set "CLEAN_NAME=%CLEAN_NAME:"=-%"
    
    set "ZIP_NAME=retail_jobs-v%VERSION%-%CLEAN_NAME%_%TIMESTAMP%.zip"
    echo Using custom name: %ZIP_NAME%
)

echo.

REM Create release info file
echo Creating release info file...
echo FiveM Retail Jobs Script > "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
echo Version: %VERSION% >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
echo Build Date: %YYYY%-%MM%-%DD% %HH%:%MIN%:%SS% >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
echo Build Type: Local Development Build >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
if not "%CUSTOM_NAME%"=="" (
    echo Build Name: %CUSTOM_NAME% >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
    echo Build Purpose: Custom named build >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
) else (
    echo Build Name: Auto-generated >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
)
echo. >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
echo Installation Instructions: >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
echo 1. Extract this folder to your FiveM server resources directory >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
echo 2. Rename folder to 'retail_jobs' if needed >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
echo 3. Add 'ensure retail_jobs' to your server.cfg >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
echo 4. Import database.sql if using MySQL >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
echo 5. Configure config.lua for your framework >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"
echo 6. Restart your server >> "%BUILD_FOLDER%\%RELEASE_FOLDER%\RELEASE_INFO.txt"

REM Create ZIP package
echo Creating ZIP package...
cd "%BUILD_FOLDER%"
powershell -command "Compress-Archive -Path '%RELEASE_FOLDER%' -DestinationPath '../%ZIP_NAME%' -Force" >nul 2>&1

cd ..

if exist "%ZIP_NAME%" (
    echo.
    echo ==========================================
    echo   BUILD SUCCESSFUL!
    echo ==========================================
    echo.
    echo ? Release package created successfully!
    echo.
    echo ?? Package Details:
    echo    File: %ZIP_NAME%
    for %%I in ("%ZIP_NAME%") do echo    Size: %%~zI bytes
    echo    Version: %VERSION%
    if not "%CUSTOM_NAME%"=="" (
        echo    Custom Name: %CUSTOM_NAME%
    )
    echo    Build Time: %YYYY%-%MM%-%DD% %HH%:%MIN%:%SS%
    echo.
    echo ?? Package Contents:
    dir "%BUILD_FOLDER%\%RELEASE_FOLDER%" /b | findstr /v /c:"RELEASE_INFO.txt"
    echo    + RELEASE_INFO.txt (build information)
    echo.
    echo ?? What's Included in v%VERSION%:
    if "%VERSION%"=="0.0.6" (
        echo    ?? Multi-Language Support (5 languages)
        echo    ?? Customer Loyalty Program
        echo    ?? Seasonal Events System
        echo    ?? Interactive Mini-Games
        echo    ?? Achievement System
        echo    ?? Clock In/Out: Numpad 2 key
        echo    ? 40% Performance improvement
        echo    ?? ESX compatibility fixes
    ) else if "%VERSION%"=="0.0.5" (
        echo    ? Advanced Inventory System with spoilage tracking
        echo    ?? Management Dashboard for store analytics
        echo    ?? Supplier System with multiple vendors
        echo    ?? Employee Scheduling system
        echo    ?? Dynamic pricing capabilities
        echo    ?? ESX compatibility improvements
    ) else (
        echo    ?? Complete FiveM Retail Jobs Script
        echo    ?? Corporate ladder progression system
        echo    ?? Advanced NPC customer AI
        echo    ?? Multiple job types and work stations
    )
    echo.
    if not "%CUSTOM_NAME%"=="" (
        echo ??? Build Purpose: %CUSTOM_NAME%
        echo    This custom-named build can be easily identified for its specific purpose.
        echo.
    )
    echo ?? Ready for Deployment:
    echo    1. Extract %ZIP_NAME%
    echo    2. Place 'retail_jobs' folder in your server's resources directory
    echo    3. Add 'ensure retail_jobs' to server.cfg
    echo    4. Configure config.lua for your framework
    echo    5. Import database.sql (if using MySQL)
    echo    6. Restart server and enjoy!
    echo.
    echo ?? Location: %cd%\%ZIP_NAME%
    echo.
) else (
    echo.
    echo ==========================================
    echo   BUILD FAILED!
    echo ==========================================
    echo.
    echo ? Failed to create release package
    echo.
    echo Possible issues:
    echo   - PowerShell not available for ZIP creation
    echo   - Insufficient disk space
    echo   - File permissions issues
    echo.
    echo Manual package creation:
    echo   1. Navigate to: %BUILD_FOLDER%\%RELEASE_FOLDER%
    echo   2. Select all files and folders
    echo   3. Right-click and "Send to" > "Compressed folder"
    echo   4. Rename to: %ZIP_NAME%
)

REM Clean up build directory option
echo.
set /p CLEANUP="Clean up build directory? (y/n): "
if /i "%CLEANUP%"=="y" (
    if exist "%BUILD_FOLDER%" rmdir /s /q "%BUILD_FOLDER%"
    echo Build directory cleaned up.
) else (
    echo Build directory kept at: %BUILD_FOLDER%\%RELEASE_FOLDER%
)

echo.
echo Build process completed!
echo.
pause