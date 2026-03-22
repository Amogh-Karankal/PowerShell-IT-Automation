<#
.SYNOPSIS
    Add a user to a security group in Microsoft Entra ID.

.DESCRIPTION
    Adds an existing user to an existing security group.
    Useful for granting access during onboarding.

.PARAMETER UserDisplayName
    Display name of the user to add.

.PARAMETER GroupDisplayName
    Display name of the target group.

.EXAMPLE
    .\04-Add-UserToGroup.ps1 -UserDisplayName "John Smith" -GroupDisplayName "IT Team"

.NOTES
    Author: Amogh Karankal
    Date: March 2026
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$UserDisplayName,
    
    [Parameter(Mandatory=$true)]
    [string]$GroupDisplayName
)

Write-Host "`n🔗 Adding user to group..." -ForegroundColor Cyan

try {
    # Find user
    $user = Get-MgUser -Filter "displayName eq '$UserDisplayName'"
    if (!$user) {
        Write-Host "❌ User '$UserDisplayName' not found" -ForegroundColor Red
        return
    }
    
    # Find group
    $group = Get-MgGroup -Filter "displayName eq '$GroupDisplayName'"
    if (!$group) {
        Write-Host "❌ Group '$GroupDisplayName' not found" -ForegroundColor Red
        return
    }
    
    # Add user to group
    New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $user.Id
    
    Write-Host "`n✅ Successfully added!" -ForegroundColor Green
    Write-Host "   User: $($user.DisplayName)" -ForegroundColor White
    Write-Host "   Group: $($group.DisplayName)" -ForegroundColor White
    
} catch {
    if ($_.Exception.Message -like "*already exist*") {
        Write-Host "`n⚠️  User is already a member of this group" -ForegroundColor Yellow
    } else {
        Write-Host "`n❌ Error: $($_.Exception.Message)" -ForegroundColor Red
    }
}
