# Mover workflow - change role, revoke old access immediately
# Control objective: no privilege accumulation; old access removed same-day as role change

param(
    [Parameter(Mandatory)][string]$UserPrincipalName,
    [ValidateSet("Standard","Finance","IT-Support")][string]$NewRole
)

$roleGroups = @{
    "Standard"    = "grp-Standard-Users"
    "Finance"     = "grp-Finance-Access"
    "IT-Support"  = "grp-Helpdesk-Access"
}

$user = Get-MgUser -UserId $UserPrincipalName

# 1. Identify current role-based memberships
$memberships = Get-MgUserMemberOfAsSecurityGroup -UserId $user.Id
$roleGroupNames = $roleGroups.Values

foreach ($m in $memberships) {
    if ($roleGroupNames -contains $m.DisplayName) {
        # 2. Revoke ALL previous role groups (no accumulation)
        Remove-MgGroupMemberByRef -GroupId $m.Id -DirectoryObjectId $user.Id
        Write-Host "[AUDIT] Removed from group: $($m.DisplayName)"
    }
}

# 3. Assign the new role group
$newGroup = Get-MgGroup -Filter "displayName eq '$($roleGroups[$NewRole])'"
New-MgGroupMember -GroupId $newGroup.Id -DirectoryObjectId $user.Id

Write-Host "[AUDIT] $(Get-Date -Format o) | User: $UserPrincipalName | New role group: $($roleGroups[$NewRole]) | Old role access revoked"
