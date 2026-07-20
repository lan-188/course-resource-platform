@echo off
chcp 936 >nul
echo ============================================
echo Gitee Pages Deploy - jiang-yuanlan
echo ============================================
echo.
echo [1/2] Build frontend...
cd /d "%~dp0frontend"
call npm run build
cd /d "%~dp0"
echo Build completed.
echo.
echo [2/2] Push source to Gitee...
git remote add gitee-personal https://gitee.com/jiang-yuanlan/course-resource-platform.git 2>nul
git push gitee-personal master
if 0 neq 0 (
    echo Push failed. Check Gitee credentials.
    pause
    exit /b
)
echo Source pushed.
echo.
echo [3/3] Deploy dist to Gitee Pages...
cd /d "%~dp0frontend"
call npx gh-pages -d dist -r https://gitee.com/jiang-yuanlan/course-resource-platform.git -b pages -m "deploy: gitee pages"
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
echo Source: https://gitee.com/jiang-yuanlan/course-resource-platform
echo Website: https://jiang-yuanlan.gitee.io/course-resource-platform
echo ============================================
echo.
echo IMPORTANT: Go to Gitee - Services - Gitee Pages,
echo Enable and select the pages branch.
echo.
pause