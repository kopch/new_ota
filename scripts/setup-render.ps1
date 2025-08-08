# PowerShell script for Render.com setup
# Usage: .\scripts\setup-render.ps1

Write-Host "Setting up Render.com deployment..." -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green

# Generate keys if not exists
if (-not (Test-Path ".env.keys")) {
    Write-Host "Generating keys..." -ForegroundColor Yellow
    
    # Generate JWT_SECRET
    $jwtSecret = [System.Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
    
    # Generate ANON_KEY
    $anonKey = [System.Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
    
    # Generate SERVICE_ROLE_KEY
    $serviceRoleKey = [System.Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
    
    # Generate DB_PASSWORD
    $dbPassword = [System.Convert]::ToBase64String([System.Security.Cryptography.RandomNumberGenerator]::GetBytes(16))
    
    # Save to file
    @"
JWT_SECRET=$jwtSecret
ANON_KEY=$anonKey
SERVICE_ROLE_KEY=$serviceRoleKey
DB_PASSWORD=$dbPassword
"@ | Out-File -FilePath ".env.keys" -Encoding UTF8
}

# Load keys
$envContent = Get-Content ".env.keys" -Raw
$envVars = @{}
foreach ($line in $envContent -split "`n") {
    if ($line -match "^([^=]+)=(.*)$") {
        $envVars[$matches[1]] = $matches[2]
    }
}

Write-Host ""
Write-Host "Generated Keys:" -ForegroundColor Cyan
Write-Host "JWT_SECRET: $($envVars['JWT_SECRET'])" -ForegroundColor White
Write-Host "ANON_KEY: $($envVars['ANON_KEY'])" -ForegroundColor White
Write-Host "SERVICE_ROLE_KEY: $($envVars['SERVICE_ROLE_KEY'])" -ForegroundColor White
Write-Host "DB_PASSWORD: $($envVars['DB_PASSWORD'])" -ForegroundColor White
Write-Host ""

Write-Host "Render.com Setup Instructions:" -ForegroundColor Green
Write-Host "=============================" -ForegroundColor Green

Write-Host ""
Write-Host "1. Create services on Render.com:" -ForegroundColor Yellow
Write-Host "   - Frontend: Web Service (Node.js)" -ForegroundColor White
Write-Host "   - Database: PostgreSQL" -ForegroundColor White
Write-Host "   - n8n: Web Service (Node.js)" -ForegroundColor White
Write-Host "   - Browserless: Web Service (Docker)" -ForegroundColor White
Write-Host ""

Write-Host "2. Frontend Environment Variables:" -ForegroundColor Yellow
Write-Host "   NODE_ENV=production" -ForegroundColor White
Write-Host "   PUBLIC_SITE_URL=https://listing-auditor-frontend.onrender.com" -ForegroundColor White
Write-Host "   SUPABASE_PUBLIC_URL=https://listing-auditor-db.onrender.com" -ForegroundColor White
Write-Host "   SUPABASE_ANON_KEY=$($envVars['ANON_KEY'])" -ForegroundColor White
Write-Host ""

Write-Host "3. n8n Environment Variables:" -ForegroundColor Yellow
Write-Host "   N8N_HOST=listing-auditor-n8n.onrender.com" -ForegroundColor White
Write-Host "   N8N_PROTOCOL=https" -ForegroundColor White
Write-Host "   N8N_WEBHOOK_URL=https://listing-auditor-n8n.onrender.com" -ForegroundColor White
Write-Host "   N8N_BASIC_AUTH_ACTIVE=true" -ForegroundColor White
Write-Host "   N8N_BASIC_AUTH_USER=admin" -ForegroundColor White
Write-Host "   N8N_BASIC_AUTH_PASSWORD=your_secure_password" -ForegroundColor White
Write-Host "   SUPABASE_URL=https://listing-auditor-db.onrender.com" -ForegroundColor White
Write-Host "   SUPABASE_ANON_KEY=$($envVars['ANON_KEY'])" -ForegroundColor White
Write-Host "   MANUS_API_KEY=your_manus_api_key" -ForegroundColor White
Write-Host "   BROWSERLESS_URL=https://listing-auditor-browserless.onrender.com" -ForegroundColor White
Write-Host ""

Write-Host "4. Database Environment Variables:" -ForegroundColor Yellow
Write-Host "   POSTGRES_PASSWORD=$($envVars['DB_PASSWORD'])" -ForegroundColor White
Write-Host "   POSTGRES_DB=listing_auditor" -ForegroundColor White
Write-Host "   POSTGRES_USER=listing_auditor_user" -ForegroundColor White
Write-Host "   JWT_SECRET=$($envVars['JWT_SECRET'])" -ForegroundColor White
Write-Host "   ANON_KEY=$($envVars['ANON_KEY'])" -ForegroundColor White
Write-Host "   SERVICE_ROLE_KEY=$($envVars['SERVICE_ROLE_KEY'])" -ForegroundColor White
Write-Host ""

Write-Host "5. Browserless Environment Variables:" -ForegroundColor Yellow
Write-Host "   MAX_CONCURRENT_SESSIONS=10" -ForegroundColor White
Write-Host "   CONNECTION_TIMEOUT=300000" -ForegroundColor White
Write-Host "   MAX_QUEUE_LENGTH=10" -ForegroundColor White
Write-Host "   TOKEN=your_browserless_token" -ForegroundColor White
Write-Host ""

Write-Host "Useful Links:" -ForegroundColor Cyan
Write-Host "   - Render Dashboard: https://dashboard.render.com" -ForegroundColor Blue
Write-Host "   - Manus AI: https://manus.ai" -ForegroundColor Blue
Write-Host "   - Stripe: https://stripe.com" -ForegroundColor Blue
Write-Host ""

Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "   1. Create Manus AI account and get API key" -ForegroundColor White
Write-Host "   2. Add MANUS_API_KEY to n8n variables" -ForegroundColor White
Write-Host "   3. Setup Stripe (optional)" -ForegroundColor White
Write-Host "   4. Import workflow to n8n" -ForegroundColor White
Write-Host ""

Write-Host "Setup completed!" -ForegroundColor Green
Write-Host "Follow instructions in DEPLOYMENT.md" -ForegroundColor White
