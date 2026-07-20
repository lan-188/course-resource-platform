@echo off
chcp 936 >nul
echo ============================================
echo GitHub Deploy (Secure)
echo ============================================
echo.
powershell -ExecutionPolicy Bypass -File "%~dp0deploy_github_secure.ps1"