<#
.SYNOPSIS
    Disable a user account in Microsoft Entra ID (Offboarding).

.DESCRIPTION
    Disables a user account as part of the offboarding process.
    Prevents the user from signing in while preserving the account.

.PARAMETER UserPrincipalName
    The UPN (email) of the user to disable.

.EXAMPLE
    .\05-Disable-User.ps1 -UserPrincipalName "john.smith@contoso.onmicrosoft.com"

.NOTES
    Author: Amogh Karankal
    Date: March 2026
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName
)

Write-Host "`n🔒 Disabling user account..." -ForegroundColor Cyan

try {
    # Get user details first
    $user = Get-MgUser -UserId $UserPrincipalName -Property DisplayName, AccountEnabled
    
    if (!$user) {
        Write-Host "❌ User not found: $UserPrincipalName" -ForegroundColor Red
        return
    }
    
    if ($user.AccountEnabled -eq $false) {
        Write-Host "⚠️  User is already disabled" -ForegroundColor Yellow
        return
    }
    
    # Disable the account
    Update-MgUser -UserId $UserPrincipalName -AccountEnabled:$false
    
    Write-Host "`n✅ User disabled successfully!" -ForegroundColor Green
    Write-Host "   User: $($user.DisplayName)" -ForegroundColor White
    Write-Host "   UPN: $UserPrincipalName" -ForegroundColor White
    Write-Host "   Status: Disabled" -ForegroundColor Yellow
    Write-Host "`n📋 Offboarding checklist:" -ForegroundColor Cyan
    Write-Host "   ☐ Remove from groups" -ForegroundColor Gray
    Write-Host "   ☐ Revoke licenses" -ForegroundColor Gray
    Write-Host "   ☐ Forward email (if applicable)" -ForegroundColor Gray
    Write-Host "   ☐ Transfer OneDrive files" -ForegroundColor Gray
    
} catch {
    Write-Host "`n❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}
