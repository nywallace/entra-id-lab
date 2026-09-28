# Joiner workflow - provision user with role-based access
# Control objective: least privilege from day one; access assigned via group, never direct

param(
    [Parameter(Mandatory)][string]$DisplayName,
    [Parameter(Mandatory)][string]$UserPrincipalName,
    [ValidateSet("Standard","Finance","IT-Support")][string]$Role = "Standard"
)

$roleGroup = @{
    "Standard"    = "grp-Standard-Users"
    "Finance"     = "grp-Finance-Access"
    "IT-Support"  = "grp-IT-Helpdesk"
}

$newUser = New-MgUser -DisplayName $DisplayName `
    -UserPrincipalName $UserPrincipalName `
    -MailNickname ($UserPrincipalName.Split("@")[0]) `
    -AccountEnabled:$true `
    -PasswordProfile @{
        Password   = ([[System.Web.Security.Me](https://System.Web.Security.Me)mbership]::GeneratePassword(16,4))
        ForceChangePasswordNextSignIn = $true
    } -UsageLocation "US"

$group = Get-MgGroup -Filter "displayName eq '$($roleGroup[$Role])'"
New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $newUser.Id

Write-Host "[AUDIT] $(Get-Date -Format o) | User: $UserPrincipalName | Group: $($roleGroup[$Role]) | Action: Joiner-provision"
