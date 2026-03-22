<#
.SYNOPSIS
    Connect to Microsoft Graph API with required permissions.

.DESCRIPTION
    Establishes connection to Microsoft Graph for user and group management.
    Must be run before executing other scripts in this toolkit.

.NOTES
    Author: Amogh Karankal
    Date: March 2026
    Requires: Microsoft.Graph PowerShell module
#>

# Install module if not present
if (!(Get-Module -ListAvailable -Name Microsoft.Graph)) {
    Write-Host "Installing Microsoft Graph module..." -ForegroundColor Yellow
    Install-Module Microsoft.Graph -Scope CurrentUser -Force
}

# Import required modules
Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Groups

# Connect with required scopes
$scopes = @(
    "User.ReadWrite.All",
    "Group.ReadWrite.All", 
    "Directory.ReadWrite.All"
)

Write-Host "Connecting to Microsoft Graph..." -ForegroundColor Cyan
Connect-MgGraph -Scopes $scopes -NoWelcome

# Verify connection
$context = Get-MgContext
if ($context) {
    Write-Host "`n✅ Connected successfully!" -ForegroundColor Green
    Write-Host "Account: $($context.Account)" -ForegroundColor White
    Write-Host "Tenant: $($context.TenantId)" -ForegroundColor White
    Write-Host "`nGranted Scopes:" -ForegroundColor Cyan
    $context.Scopes | ForEach-Object { Write-Host "  • $_" -ForegroundColor Gray }
} else {
    Write-Host "❌ Connection failed" -ForegroundColor Red
}
