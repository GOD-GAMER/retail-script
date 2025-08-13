@echo off
echo ========================================
echo  Creating Clean Release Package v0.0.4
echo ========================================
echo.

echo Creating retail_jobs folder...
if exist "retail_jobs" rmdir /s /q "retail_jobs"
mkdir "retail_jobs"

echo Copying ESSENTIAL SERVER FILES ONLY...
echo.

REM Core resource files
copy "fxmanifest.lua" "retail_jobs\" >nul
copy "config.lua" "retail_jobs\" >nul

REM Database (if exists)
if exist "database.sql" copy "database.sql" "retail_jobs\" >nul

REM Documentation (essential only)
copy "README.md" "retail_jobs\" >nul
copy "CHANGELOG.md" "retail_jobs\" >nul
copy "LICENSE" "retail_jobs\" >nul

echo Copying script folders...
xcopy "shared" "retail_jobs\shared\" /e /i /q >nul
xcopy "server" "retail_jobs\server\" /e /i /q >nul
xcopy "client" "retail_jobs\client\" /e /i /q >nul
xcopy "html" "retail_jobs\html\" /e /i /q >nul

echo.
echo Cleaning up unnecessary files from package...
REM Remove any development files that might have been copied
if exist "retail_jobs\*.bat" del "retail_jobs\*.bat" /q
if exist "retail_jobs\GITHUB_SETUP_GUIDE.md" del "retail_jobs\GITHUB_SETUP_GUIDE.md"
if exist "retail_jobs\NEW_FEATURES_*.md" del "retail_jobs\NEW_FEATURES_*.md"