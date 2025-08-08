# Simple key generation script
# Usage: .\scripts\generate-keys-simple.ps1

Write-Host "Generating keys for Render.com deployment..." -ForegroundColor Green

# Generate random keys
$jwtSecret = [System.Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
$anonKey = [System.Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
$serviceRoleKey = [System.Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
$dbPassword = [System.Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(16))

Write-Host ""
Write-Host "Generated Keys:" -ForegroundColor Cyan
Write-Host "==============" -ForegroundColor Cyan
Write-Host ""
Write-Host "JWT_SECRET: $jwtSecret" -ForegroundColor Yellow
Write-Host ""
Write-Host "ANON_KEY: $anonKey" -ForegroundColor Yellow
Write-Host ""
Write-Host "SERVICE_ROLE_KEY: $serviceRoleKey" -ForegroundColor Yellow
Write-Host ""
Write-Host "DB_PASSWORD: $dbPassword" -ForegroundColor Yellow
Write-Host ""

Write-Host "Copy these keys to your Render.com environment variables!" -ForegroundColor Green
Write-Host "See RENDER_DEPLOY.md for detailed instructions." -ForegroundColor Green

