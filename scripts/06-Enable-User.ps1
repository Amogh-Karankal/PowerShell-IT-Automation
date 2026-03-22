<#
.SYNOPSIS
    Enable a disabled user account in Microsoft Entra ID.

.DESCRIPTION
    Re-enables a previously disabled user account.
    Restores the user's ability to sign in.

.PARAMETER UserPrincipalName
    The UPN (email) of the user to enable.

.EXAMPLE
    .\06-Enable-User.ps1 -UserPrincipalName "john.smith@contoso.onmicrosoft.com"

.NOTES
    Author: Amogh Karankal
    Date: March 2026
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName
)

Write-Host "`n🔓 Enabling user account..." -ForegroundColor Cyan

try {
    # Get user details first
    $user = Get-MgUser -UserId $UserPrincipalName -Property DisplayName, AccountEnabled
    
    if (!$user) {
        Write-Host "❌ User not found: $UserPrincipalName" -ForegroundColor Red
        return
    }
    
    if ($user.AccountEnabled -eq $true) {
        Write-Host "⚠️  User is already enabled" -ForegroundColor Yellow
        return
    }
    
    # Enable the account
    Update-MgUser -UserId $UserPrincipalName -AccountEnabled:$true
    
    Write-Host "`n✅ User enabled successfully!" -ForegroundColor Green
    Write-Host "   User: $($user.DisplayName)" -ForegroundColor White
    Write-Host "   UPN: $UserPrincipalName" -ForegroundColor White
    Write-Host "   Status: Enabled" -ForegroundColor Green
    
} catch {
    Write-Host "`n❌ Error: $($_.Exception.Message)" -ForegroundColor Red
}
