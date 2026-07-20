$ErrorActionPreference = "Stop"

Write-Host "============================================"
Write-Host "GitHub Deploy with Secure Token Input"
Write-Host "============================================"
Write-Host ""

$token = Read-Host "Please paste your GitHub Token (it will be hidden)" -AsSecureString
$plainToken = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($token))

$repo = "https://github.com/lan-188/course-resource-platform.git"
$repoWithToken = "https://$plainToken@github.com/lan-188/course-resource-platform.git"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$frontendDir = Join-Path $projectRoot "frontend"

Write-Host "[1/3] Push source code to GitHub master..."
cd $projectRoot
git push $repoWithToken master
if ($LASTEXITCODE -ne 0) {
    Write-Host "Push failed. Please check your token." -ForegroundColor Red
    pause
    exit 1
}
Write-Host "Source code pushed." -ForegroundColor Green
Write-Host ""

Write-Host "[2/3] Build frontend..."
cd $frontendDir
npm run build
if ($LASTEXITCODE -ne 0) {
    Write-Host "Build failed." -ForegroundColor Red
    pause
    exit 1
}
cd $projectRoot
Write-Host "Build completed." -ForegroundColor Green
Write-Host ""

Write-Host "[3/3] Deploy frontend to GitHub Pages..."
cd $frontendDir
npx gh-pages -d dist -r $repoWithToken -m "deploy: update gh-pages"
if ($LASTEXITCODE -ne 0) {
    Write-Host "gh-pages deploy failed." -ForegroundColor Red
    pause
    exit 1
}
cd $projectRoot

Write-Host ""
Write-Host "============================================" -ForegroundColor Green
Write-Host "Deploy Success!" -ForegroundColor Green
Write-Host ""
Write-Host "Source: $repo"
Write-Host "Website: https://lan-188.github.io/course-resource-platform/"
Write-Host "============================================"
Write-Host ""
Write-Host "Note: GitHub Pages may take 1-2 minutes to take effect."
Write-Host ""
pause
