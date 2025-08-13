@echo off
echo ========================================
echo  Creating Release Package
echo ========================================
echo.

echo Creating retail_jobs folder...
if exist "retail_jobs" rmdir /s /q "retail_jobs"
mkdir "retail_jobs"

echo Copying essential files...
copy "fxmanifest.lua" "retail_jobs\" >nul
copy "config.lua" "retail_jobs\" >nul
copy "database.sql" "retail_jobs\" >nul
copy "README.md" "retail_jobs\" >nul
copy "CHANGELOG.md" "retail_jobs\" >nul
copy "TROUBLESHOOTING.md" "retail_jobs\" >nul
copy "LICENSE" "retail_jobs\" >nul

echo Copying folders...
xcopy "shared" "retail_jobs\shared\" /e /i /q >nul
xcopy "server" "retail_jobs\server\" /e /i /q >nul
xcopy "client" "retail_jobs\client\" /e /i /q >nul
xcopy "html" "retail_jobs\html\" /e /i /q >nul

echo Creating ZIP file...
powershell -command "Compress-Archive -Path 'retail_jobs' -DestinationPath 'retail_jobs-v0.0.2.zip' -Force"

if exist "retail_jobs-v0.0.2.zip" (
    echo.
    echo ? SUCCESS: Release package created!
    echo.
    echo ?? File: retail_jobs-v0.0.2.zip
    echo ?? Size: 
    dir "retail_jobs-v0.0.2.zip" | findstr "retail_jobs-v0.0.2.zip"
    echo.
    echo This file is ready to upload to your GitHub release!
    echo.
) else (
    echo.
    echo ? ERROR: Failed to create ZIP file
    echo Make sure PowerShell is available
)

echo.
echo Press any key to continue...
pause >nul