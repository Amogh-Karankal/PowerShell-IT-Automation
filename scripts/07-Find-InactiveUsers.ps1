<#
.SYNOPSIS
    Find users who haven't signed in for a specified number of days.

.DESCRIPTION
    Identifies inactive user accounts based on last sign-in activity.
    Useful for security audits and license optimization.

.PARAMETER Days
    Number of days of inactivity (default: 90).

.EXAMPLE
    .\07-Find-InactiveUsers.ps1 -Days 90

.NOTES
    Author: Amogh Karankal
    Date: March 2026
    Requires: AuditLog.Read.All permission for sign-in data
#>

param(
    [Parameter(Mandatory=$false)]
    [int]$Days = 90
)

Write-Host "`n🔍 Finding users inactive for $Days+ days..." -ForegroundColor Cyan

try {
    $cutoffDate = (Get-Date).AddDays(-$Days)
    
    # Get all users with sign-in activity
    $allUsers = Get-MgUser -All -Property DisplayName, UserPrincipalName, AccountEnabled, SignInActivity, CreatedDateTime
    
    $inactiveUsers = @()
    
    foreach ($user in $allUsers) {
        $lastSignIn = $user.SignInActivity.LastSignInDateTime
        
        # User is inactive if never signed in OR last sign-in is before cutoff
        if ($null -eq $lastSignIn -or $lastSignIn -lt $cutoffDate) {
            $inactiveUsers += [PSCustomObject]@{
                DisplayName = $user.DisplayName
                UserPrincipalName = $user.UserPrincipalName
                AccountEnabled = $user.AccountEnabled
                LastSignIn = if ($lastSignIn) { $lastSignIn.ToString("yyyy-MM-dd") } else { "Never" }
                CreatedDate = if ($user.CreatedDateTime) { $user.CreatedDateTime.ToString("yyyy-MM-dd") } else { "Unknown" }
            }
        }
    }
    
    if ($inactiveUsers.Count -gt 0) {
        Write-Host "`n⚠️  Found $($inactiveUsers.Count) inactive users:" -ForegroundColor Yellow
        $inactiveUsers | Format-Table -AutoSize
        
        # Export to CSV
        $exportPath = "$HOME\Desktop\InactiveUsers_$(Get-Date -Format 'yyyy-MM-dd').csv"
        $inactiveUsers | Export-Csv -Path $exportPath -NoTypeInformation
        Write-Host "📁 Report saved: $exportPath" -ForegroundColor Green
    } else {
        Write-Host "`n✅ No inactive users found!" -ForegroundColor Green
    }
    
    # Summary
    Write-Host "`n📈 Summary:" -ForegroundColor Cyan
    Write-Host "   Total Users: $($allUsers.Count)" -ForegroundColor White
    Write-Host "   Inactive ($Days+ days): $($inactiveUsers.Count)" -ForegroundColor Yellow
    Write-Host "   Active: $($allUsers.Count - $inactiveUsers.Count)" -ForegroundColor Green
    
} catch {
    Write-Host "`n❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Note: Sign-in activity requires AuditLog.Read.All permission" -ForegroundColor Gray
}
