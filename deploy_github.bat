@echo off
chcp 65001 >nul
echo ============================================
echo   软件测试实践教学平台 - GitHub 一键部署
echo ============================================
echo.

echo [1/3] 推送源码到 GitHub master 分支...
git push github master
if %errorlevel% neq 0 (
    echo.
    echo ❌ 推送失败！可能的原因：
    echo    1. 未授权 Git Credential Manager → 请在弹出的浏览器中点 "Authorize"
    echo    2. 网络问题 → 检查 VPN 或代理
    echo    3. GitHub 账号不对 → 确保登录的是 kathrine-ky
    echo.
    pause
    exit /b
)
echo ✅ 源码推送成功
echo.

echo [2/3] 构建前端生产版本...
cd /d "%~dp0frontend"
call npm run build
cd /d "%~dp0"
echo ✅ 构建完成
echo.

echo [3/3] 部署前端到 GitHub Pages (gh-pages分支)...
cd /d "%~dp0frontend"
call npx gh-pages -d dist -r https://github.com/kathrine-ky/test-teaching-platform.git -m "deploy: update gh-pages [%date% %time%]"
cd /d "%~dp0"
if %errorlevel% neq 0 (
    echo ❌ gh-pages 部署失败，请检查网络后重试
    pause
    exit /b
)

echo.
echo ============================================
echo   🎉 部署成功！
echo.
echo   📎 项目源码: https://github.com/kathrine-ky/test-teaching-platform
echo   🌐 在线演示: https://kathrine-ky.github.io/test-teaching-platform/
echo ============================================
echo.
echo ⚠️  注意：
echo   - GitHub Pages 部署后需等待 1-2 分钟生效
echo   - 前端页面需要后端 API 才能完整使用（登录等功能）
echo   - 如需完整展示，建议用 Render/Railway 部署后端
echo.
echo 如果访问 404，请到仓库 Settings ^> Pages 确认：
echo   Source: Deploy from a branch → Branch: gh-pages / (root)
echo.
pause
