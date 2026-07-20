@echo off
chcp 936 >nul
setlocal EnableDelayedExpansion

echo ============================================
echo GitHub Deploy with Token
echo ============================================
echo.

set /p TOKEN=Please paste your GitHub Token: 
echo.

set REPO=https://github.com/kathrine-ky/test-teaching-platform.git
set REPO_WITH_TOKEN=https://%TOKEN%@github.com/kathrine-ky/test-teaching-platform.git

echo [1/3] Push source code to GitHub master...
git push %REPO_WITH_TOKEN% master
if 0 neq 0 (
    echo Push failed. Please check your token.
    pause
    exit /b
)
echo Source code pushed.
echo.

echo [2/3] Build frontend...
cd /d "%~dp0frontend"
call npm run build
cd /d "%~dp0"
echo Build completed.
echo.

echo [3/3] Deploy to GitHub Pages...
cd /d "%~dp0frontend"
call npx gh-pages -d dist -r %REPO_WITH_TOKEN% -m "deploy: update gh-pages"
cd /d "%~dp0"
if 0 neq 0 (
    echo gh-pages deploy failed.
    pause
    exit /b
)

echo.
echo ============================================
echo Deploy Success!
echo.
echo Source: %REPO%
echo Website: https://kathrine-ky.github.io/test-teaching-platform/
echo ============================================
echo.
echo Note: GitHub Pages may take 1-2 minutes.
echo.
pause
endlocal