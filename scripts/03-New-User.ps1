<#
.SYNOPSIS
    Create a new user in Microsoft Entra ID.

.DESCRIPTION
    Creates a new user account with specified properties.
    Sets temporary password with force change on first login.

.PARAMETER DisplayName
    Full name of the user.

.PARAMETER UserPrincipalName
    Login email address (user@domain.onmicrosoft.com).

.PARAMETER JobTitle
    User's job title.

.PARAMETER Department
    User's department.

.EXAMPLE
    .\03-New-User.ps1 -DisplayName "John Smith" -UserPrincipalName "john.smith@contoso.onmicrosoft.com"

.NOTES
    Author: Amogh Karankal
    Date: March 2026
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$DisplayName,
    
    [Parameter(Mandatory=$true)]
    [string]$UserPrincipalName,
    
    [Parameter(Mandatory=$false)]
    [string]$JobTitle = "",
    
    [Parameter(Mandatory=$false)]
    [string]$Department = ""
)

# Generate mail nickname from UPN
$mailNickname = ($UserPrincipalName -split "@")[0] -replace "\.", ""

# Generate temporary password
$tempPassword = "Welcome" + (Get-Random -Minimum 1000 -Maximum 9999) + "!"

# Create password profile
$passwordProfile = @{
    Password = $tempPassword
    ForceChangePasswordNextSignIn = $true
}

# Build user object
$newUser = @{
    DisplayName = $DisplayName
    UserPrincipalName = $UserPrincipalName
    MailNickname = $mailNickname
    AccountEnabled = $true
    PasswordProfile = $passwordProfile
    JobTitle = $JobTitle
    Department = $Department
}

Write-Host "`n👤 Creating new user..." -ForegroundColor Cyan

try {
    $createdUser = New-MgUser -BodyParameter $newUser
    
    Write-Host "`n✅ User created successfully!" -ForegroundColor Green
    Write-Host "`n📋 User Details:" -ForegroundColor Yellow
    Write-Host "   Display Name: $DisplayName" -ForegroundColor White
    Write-Host "   UPN: $UserPrincipalName" -ForegroundColor White
    Write-Host "   Job Title: $JobTitle" -ForegroundColor White
    Write-Host "   Department: $Department" -ForegroundColor White
    Write-Host "   Temp Password: $tempPassword" -ForegroundColor Magenta
    Write-Host "`n⚠️  User must change password on first login" -ForegroundColor Yellow
    
} catch {
    Write-Host "`n❌ Error creating user: $($_.Exception.Message)" -ForegroundColor Red
}
