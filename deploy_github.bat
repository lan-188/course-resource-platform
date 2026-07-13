@echo off
echo ============================================
echo   软件测试实践教学平台 - GitHub 一键部署
echo ============================================
echo.

echo [1/4] 拉取远程最新代码...
git pull github master
if %errorlevel% neq 0 (
    echo 拉取失败，请检查网络或凭证
    pause
    exit /b
)

echo [2/4] 提交本地变更...
git add frontend/vue.config.js frontend/package-lock.json deploy_github.bat
git commit -m "chore: 配置GitHub Pages部署 + publicPath适配"
echo.

echo [3/4] 推送代码到 GitHub...
git push github master
if %errorlevel% neq 0 (
    echo 推送失败！请确保已授权 Git Credential Manager
    pause
    exit /b
)

echo [4/4] 部署 dist 到 gh-pages 分支...
cd frontend
call npx gh-pages -d dist -r https://github.com/kathrine-ky/test-teaching-platform.git -m "deploy: update gh-pages"
cd ..

echo.
echo ============================================
echo   部署完成！访问以下网址查看项目：
echo   https://kathrine-ky.github.io/test-teaching-platform/
echo ============================================
echo.
echo 如果 404，请到 GitHub 仓库 Settings - Pages
echo 确认 Source 已设置为 gh-pages 分支
echo.
pause
