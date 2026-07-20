@echo off
chcp 936 >nul
echo ============================================
echo GitHub Deploy Script
echo ============================================
echo.
echo [1/3] Push source code to GitHub master...
git push github master
if 0 neq 0 (
    echo.
    echo Push failed. Please check:
    echo   1. Git Credential Manager authorization
    echo   2. Network connection
    echo   3. GitHub account is kathrine-ky
    echo.
    pause
    exit /b
)
echo Source code pushed successfully.
echo.
echo [2/3] Build frontend production bundle...
cd /d "%~dp0frontend"
call npm run build
cd /d "%~dp0"
echo Build completed.
echo.
echo [3/3] Deploy frontend to GitHub Pages...
cd /d "%~dp0frontend"
call npx gh-pages -d dist -r https://github.com/kathrine-ky/test-teaching-platform.git -m "deploy: update gh-pages"
cd /d "%~dp0"
if 0 neq 0 (
    echo gh-pages deploy failed. Please retry.
    pause
    exit /b
)
echo.
echo ============================================
echo Deploy Success!
echo.
echo Source: https://github.com/kathrine-ky/test-teaching-platform
echo Website: https://kathrine-ky.github.io/test-teaching-platform/
echo ============================================
echo.
echo Note: GitHub Pages may take 1-2 minutes to take effect.
echo.
pause