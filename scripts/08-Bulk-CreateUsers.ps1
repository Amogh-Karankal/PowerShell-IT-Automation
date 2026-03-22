<#
.SYNOPSIS
    Bulk create users from a CSV file.

.DESCRIPTION
    Creates multiple user accounts from a CSV file.
    Generates temporary passwords and logs results.

.PARAMETER CsvPath
    Path to the CSV file containing user data.

.EXAMPLE
    .\08-Bulk-CreateUsers.ps1 -CsvPath "C:\Users\admin\Desktop\NewUsers.csv"

.NOTES
    Author: Amogh Karankal
    Date: March 2026
    
    CSV Format Required:
    DisplayName,UserPrincipalName,JobTitle,Department
    John Smith,john.smith@domain.onmicrosoft.com,IT Support,IT
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$CsvPath
)

Write-Host "`n📥 Bulk User Creation" -ForegroundColor Cyan
Write-Host "━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan

# Check if file exists
if (!(Test-Path $CsvPath)) {
    Write-Host "❌ File not found: $CsvPath" -ForegroundColor Red
    return
}

# Import CSV
$users = Import-Csv -Path $CsvPath
Write-Host "📋 Found $($users.Count) users to create`n" -ForegroundColor White

# Track results
$created = @()
$failed = @()

foreach ($user in $users) {
    # Generate password
    $tempPassword = "Welcome" + (Get-Random -Minimum 1000 -Maximum 9999) + "!"
    $mailNickname = ($user.UserPrincipalName -split "@")[0] -replace "\.", ""
    
    $passwordProfile = @{
        Password = $tempPassword
        ForceChangePasswordNextSignIn = $true
    }
    
    $newUser = @{
        DisplayName = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        MailNickname = $mailNickname
        AccountEnabled = $true
        PasswordProfile = $passwordProfile
        JobTitle = $user.JobTitle
        Department = $user.Department
    }
    
    try {
        New-MgUser -BodyParameter $newUser | Out-Null
        Write-Host "✅ Created: $($user.DisplayName)" -ForegroundColor Green
        
        $created += [PSCustomObject]@{
            DisplayName = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            TempPassword = $tempPassword
            Status = "Created"
        }
    } catch {
        Write-Host "❌ Failed: $($user.DisplayName) - $($_.Exception.Message)" -ForegroundColor Red
        
        $failed += [PSCustomObject]@{
            DisplayName = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            Error = $_.Exception.Message
            Status = "Failed"
        }
    }
}

# Summary
Write-Host "`n━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "📈 Results:" -ForegroundColor Cyan
Write-Host "   ✅ Created: $($created.Count)" -ForegroundColor Green
Write-Host "   ❌ Failed: $($failed.Count)" -ForegroundColor Red

# Export results with passwords
if ($created.Count -gt 0) {
    $exportPath = "$HOME\Desktop\BulkCreateResults_$(Get-Date -Format 'yyyy-MM-dd_HHmmss').csv"
    $created | Export-Csv -Path $exportPath -NoTypeInformation
    Write-Host "`n📁 Credentials saved: $exportPath" -ForegroundColor Yellow
    Write-Host "⚠️  Share passwords securely and delete this file after distribution!" -ForegroundColor Yellow
}
