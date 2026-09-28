# Leaver workflow - full deprovisioning
# Control objective: immediate access termination for departing personnel (matches
# the offboarding audit check performed at Amtrak: 100% same-day deprovisioning)

param([Parameter(Mandatory)][string]$UserPrincipalName)

$user = Get-MgUser -UserId $UserPrincipalName

# 1. Disable the account FIRST - kills live sessions, blocks new sign-ins
Update-MgUser -UserId $user.Id -AccountEnabled:$false

# 2. Revoke all refresh tokens / active sessions
Revoke-MgUserSignInSession -UserId $user.Id

# 3. Strip every group membership (including role groups)
$memberships = Get-MgUserMemberOfAsSecurityGroup -UserId $user.Id
foreach ($m in $memberships) {
    Remove-MgGroupMemberByRef -GroupId $m.Id -DirectoryObjectId $user.Id
    Write-Host "[AUDIT] Removed from group: $($m.DisplayName)"
}

# 4. Reset password to a random value (unknown to leaver)
Update-MgUser -UserId $user.Id -PasswordProfile @{
    Password = ([[System.Web.Security.Me](https://System.Web.Security.Me)mbership]::GeneratePassword(24,6))
    ForceChangePasswordNextSignIn = $true
}

Write-Host "[AUDIT] $(Get-Date -Format o) | User: $UserPrincipalName | Action: Leaver-deprovisioned | Account disabled, sessions revoked, groups stripped"
