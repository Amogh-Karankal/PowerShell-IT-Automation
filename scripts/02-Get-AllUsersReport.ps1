<#
.SYNOPSIS
    Export all Azure AD/Entra ID users to CSV report.

.DESCRIPTION
    Retrieves all users from Microsoft Entra ID and exports to CSV file.
    Useful for auditing, inventory, and compliance reporting.

.OUTPUTS
    CSV file saved to Desktop with timestamp.

.NOTES
    Author: Amogh Karankal
    Date: March 2026
#>

Write-Host "`n📊 Generating User Report..." -ForegroundColor Cyan

# Get all users with relevant properties
$users = Get-MgUser -All -Property `
    DisplayName, `
    UserPrincipalName, `
    Mail, `
    JobTitle, `
    Department, `
    AccountEnabled, `
    CreatedDateTime, `
    UserType | 
Select-Object `
    DisplayName, `
    UserPrincipalName, `
    Mail, `
    JobTitle, `
    Department, `
    AccountEnabled, `
    CreatedDateTime, `
    UserType

# Display in console
Write-Host "`nUser List:" -ForegroundColor Yellow
$users | Format-Table DisplayName, UserPrincipalName, Department, AccountEnabled -AutoSize

# Export to CSV
$timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
$exportPath = "$HOME\Desktop\UserReport_$timestamp.csv"
$users | Export-Csv -Path $exportPath -NoTypeInformation

# Summary
Write-Host "`n✅ Report exported successfully!" -ForegroundColor Green
Write-Host "📁 File: $exportPath" -ForegroundColor White
Write-Host "`n📈 Summary:" -ForegroundColor Cyan
Write-Host "   Total Users: $($users.Count)" -ForegroundColor White
Write-Host "   Enabled: $(($users | Where-Object {$_.AccountEnabled -eq $true}).Count)" -ForegroundColor Green
Write-Host "   Disabled: $(($users | Where-Object {$_.AccountEnabled -eq $false}).Count)" -ForegroundColor Yellow
