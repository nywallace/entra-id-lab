# Joiner workflow - provision user with role-based access
# Control objective: least privilege from day one; access assigned via group, never direct

param(
    [Parameter(Mandatory)][string]$DisplayName,
    [Parameter(Mandatory)][string]$UserPrincipalName,
    [ValidateSet("Standard","Finance","IT-Support")][string]$Role = "Standard"
)

# Map role to security group (group-based access = auditable, reviewable)
$roleGroup = @{
    "Standard"    = "grp-Standard-Users"
    "Finance"     = "grp-Finance-Access"
    "IT-Support"  = "grp-IT-Helpdesk"
}

# 1. Create the account
$newUser = New-MgUser -DisplayName $DisplayName `
    -UserPrincipalName $UserPrincipalName `
    -MailNickname ($UserPrincipalName.Split("@")[0]) `
    -AccountEnabled:$true `
    -PasswordProfile @{
        Password   = ([[System.Web.Security.Me](https://System.Web.Security.Me)mbership]::GeneratePassword(16,4))
        ForceChangePasswordNextSignIn = $true
    } -UsageLocation "US"

# 2. Add ONLY the role group - no direct role assignments, no standing privilege
$group = Get-MgGroup -Filter "displayName eq '$($roleGroup[$Role])'"
New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $newUser.Id

# 3. Evidence: log the assignment
Write-Host "[AUDIT] $(Get-Date -Format o) | User: $UserPrincipalName | Group: $($roleGroup[$Role]) | Action: Joiner-provision"
