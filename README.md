# PowerShell IT Automation Toolkit

Automate common IT helpdesk tasks in Microsoft Entra ID (Azure AD) using PowerShell and Microsoft Graph API.

![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue?logo=powershell)
![Microsoft Graph](https://img.shields.io/badge/Microsoft%20Graph-API-orange?logo=microsoft)
![License](https://img.shields.io/badge/License-MIT-green)

## 🎯 Overview

This toolkit automates repetitive IT administration tasks, reducing manual effort by up to 80%. Built for IT helpdesk and system administrators managing Microsoft 365 / Entra ID environments.

### Key Features

- **User Provisioning** — Create single or bulk users with auto-generated passwords
- **Group Management** — Add/remove users from security groups
- **Offboarding** — Disable accounts with audit trail
- **Reporting** — Export user reports and identify inactive accounts
- **Automation** — All scripts parameterized for easy integration

## 📁 Scripts Included

| Script | Description |
|--------|-------------|
| `01-Connect-Graph.ps1` | Establish connection to Microsoft Graph API |
| `02-Get-AllUsersReport.ps1` | Export all users to CSV with key attributes |
| `03-New-User.ps1` | Create a new user account |
| `04-Add-UserToGroup.ps1` | Add user to a security group |
| `05-Disable-User.ps1` | Disable user account (offboarding) |
| `06-Enable-User.ps1` | Re-enable a disabled account |
| `07-Find-InactiveUsers.ps1` | Find users inactive for 90+ days |
| `08-Bulk-CreateUsers.ps1` | Bulk create users from CSV file |

## 🚀 Quick Start

### Prerequisites

- Windows PowerShell 5.1 or PowerShell 7+
- Microsoft Graph PowerShell module
- Global Administrator or User Administrator role in Entra ID

### Installation

```powershell
# Install Microsoft Graph module
Install-Module Microsoft.Graph -Scope CurrentUser -Force

# Clone this repository
git clone https://github.com/Amogh-Karankal/PowerShell-IT-Automation.git
cd PowerShell-IT-Automation
```

### Connect to Microsoft Graph

```powershell
# Run the connect script
.\01-Connect-Graph.ps1

# Or connect manually with required scopes
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "Directory.ReadWrite.All"
```

## 📖 Usage Examples

### Create a New User

```powershell
.\03-New-User.ps1 -DisplayName "John Smith" `
                  -UserPrincipalName "john.smith@contoso.onmicrosoft.com" `
                  -JobTitle "IT Support" `
                  -Department "IT"
```

**Output:**
```
✅ User created successfully!
   Display Name: John Smith
   UPN: john.smith@contoso.onmicrosoft.com
   Temp Password: Welcome4821!
```

### Add User to Group

```powershell
.\04-Add-UserToGroup.ps1 -UserDisplayName "John Smith" -GroupDisplayName "IT Team"
```

### Disable User (Offboarding)

```powershell
.\05-Disable-User.ps1 -UserPrincipalName "john.smith@contoso.onmicrosoft.com"
```


### Generate User Report

```powershell
.\02-Get-AllUsersReport.ps1

# Output: CSV file saved to Desktop
```

## 🔐 Required Permissions

| Permission | Purpose |
|------------|---------|
| `User.ReadWrite.All` | Create, update, disable users |
| `Group.ReadWrite.All` | Manage group memberships |
| `Directory.ReadWrite.All` | Full directory access |
| `AuditLog.Read.All` | Sign-in activity (for inactive users) |

## 📊 Sample Output

### User Report Export

| DisplayName | UserPrincipalName | Department | AccountEnabled |
|-------------|-------------------|------------|----------------|
| John Smith | john.smith@contoso.com | IT | True |
| Jane Doe | jane.doe@contoso.com | HR | True |
| Bob Wilson | bob.wilson@contoso.com | Finance | False |

### Inactive Users Report

| DisplayName | LastSignIn | AccountEnabled |
|-------------|------------|----------------|
| Old Account | 2025-01-15 | True |
| Test User | Never | True |

## 🛠️ Customization

### Modify Password Policy

Edit the password generation in `03-New-User.ps1`:

```powershell
# Current: Welcome + random 4 digits + !
$tempPassword = "Welcome" + (Get-Random -Minimum 1000 -Maximum 9999) + "!"

# Custom: More complex password
$tempPassword = "Temp" + (Get-Random -Minimum 100000 -Maximum 999999) + "!@#"
```

### Add Custom User Attributes

Modify the `$newUser` hashtable in user creation scripts:

```powershell
$newUser = @{
    DisplayName = $DisplayName
    UserPrincipalName = $UserPrincipalName
    # Add more attributes:
    OfficeLocation = "Building A"
    MobilePhone = "+1-555-0100"
    UsageLocation = "US"
}
```

## 📝 Best Practices

1. **Test in a dev tenant first** — Never run untested scripts in production
2. **Use least privilege** — Only request permissions you need
3. **Secure credentials** — Delete CSV files with passwords after use
4. **Audit logging** — All changes are logged in Entra ID audit logs
5. **Error handling** — Scripts include try/catch for graceful failures

## 🤝 Contributing

Contributions welcome! Feel free to submit issues and pull requests.

## 📄 License

This project is licensed under the MIT License.

## 👤 Author

**Amogh Karankal**

- GitHub: [@Amogh-Karankal](https://github.com/Amogh-Karankal)
- LinkedIn: [Amogh Karankal](https://www.linkedin.com/in/amoghkarankal/)

---

## 🏷️ Keywords

`PowerShell` `Microsoft Graph` `Azure AD` `Entra ID` `IT Automation` `Helpdesk` `User Provisioning` `Identity Management` `Microsoft 365` `Sysadmin`
