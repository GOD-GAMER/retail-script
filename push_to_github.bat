@echo off
echo ========================================
echo  FiveM Retail Script - GitHub Push
echo ========================================
echo.

echo Step 1: Pushing to GitHub...
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ? SUCCESS: Code pushed to GitHub!
    echo.
    echo ?? Repository URL: https://github.com/GOD-GAMER/retail-script
    echo.
    echo ========================================
    echo  Next Steps:
    echo ========================================
    echo 1. Go to: https://github.com/GOD-GAMER/retail-script
    echo 2. Click "Releases" in the right sidebar
    echo 3. Click "Create a new release"
    echo 4. Fill in:
    echo    - Tag version: v0.0.2
    echo    - Release title: ?? FiveM Retail Jobs Script v0.0.2
    echo    - Description: Copy from RELEASE_NOTES.md
    echo 5. Upload retail_jobs-v0.0.2.zip (if you have it)
    echo 6. Click "Publish release"
    echo.
    echo ========================================
    echo  Create Release Package:
    echo ========================================
    echo Run: create_release_package.bat
    echo.
) else (
    echo.
    echo ? ERROR: Failed to push to GitHub
    echo.
    echo Make sure you:
    echo 1. Created the repository on GitHub first
    echo 2. Repository name is exactly: retail-script
    echo 3. You're logged in to GitHub
    echo 4. You have internet connection
    echo.
    echo Then run this script again!
)

echo.
echo Press any key to continue...
pause >nul