@echo off
echo ========================================
echo  FiveM Retail Script - GitHub Push v0.0.3
echo ========================================
echo.

echo Step 1: Pushing to GitHub...
git add .
git commit -m "Release v0.0.3 - FiveM Native Keybind Integration

? NEW FEATURES:
- FiveM Settings Menu Integration for keybinds
- Professional keybind system like ESX/QBCore
- Fixed interaction conflicts with priority system
- Enhanced new player experience with starting bonuses
- Separate clock in/out zones from work stations

?? FIXES:
- Clock out issues resolved
- Work station overlap eliminated  
- Interaction cooldown system
- Keybind conflicts prevented

?? IMPROVEMENTS:
- Real-time keybind customization
- Controller support via FiveM settings
- Tutorial system for new players
- Enhanced XP progression"

git push origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ? SUCCESS: Code pushed to GitHub!
    echo.
    echo ?? Repository URL: https://github.com/GOD-GAMER/retail-script
    echo.
    echo ========================================
    echo  Next Steps for v0.0.3 Release:
    echo ========================================
    echo 1. Go to: https://github.com/GOD-GAMER/retail-script
    echo 2. Click "Releases" in the right sidebar
    echo 3. Click "Create a new release"
    echo 4. Fill in:
    echo    - Tag version: v0.0.3
    echo    - Release title: ?? FiveM Retail Jobs Script v0.0.3
    echo    - Description: Copy from RELEASE_NOTES.md
    echo 5. Upload retail_jobs-v0.0.3.zip
    echo 6. Click "Publish release"
    echo.
    echo ========================================
    echo  ?? v0.0.3 Highlights:
    echo ========================================
    echo ? FiveM Native Keybind Integration
    echo ?? Fixed all interaction conflicts
    echo ?? Enhanced new player experience
    echo ?? Professional keybind system
    echo ?? Improved performance and stability
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
    echo 1. Have committed all changes
    echo 2. Repository exists on GitHub
    echo 3. You're logged in to GitHub
    echo 4. You have internet connection
    echo.
    echo Then run this script again!
)

echo.
echo Press any key to continue...
pause >nul