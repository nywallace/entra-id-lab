# Access review - evidence gathering for periodic attestation
# Control objective: attest group assignments + review sign-in anomalies

# 1. Full membership export per role group (the review artifact)
$groups = Get-MgGroup -Filter "displayName eq 'grp-Standard-Users'"
foreach ($g in $groups) {
    Write-Host "=== Members of $($g.DisplayName) ==="
    Get-MgGroupMember -GroupId $g.Id | ForEach-Object {
        $u = Get-MgUser -UserId $_.Id -Property displayName,userPrincipalName,accountEnabled
        [PSCustomObject]@{
            User        = $u.UserPrincipalName
            Enabled     = $u.AccountEnabled
            Reviewed    = (Get-Date -Format o)
        }
    } | Format-Table
}

# 2. Risky sign-ins in last 7 days (anomaly review)
Write-Host "=== Risky sign-ins (7 days) ==="
$risky = Get-MgRiskDetection -Top 50
$risky | Select-Object riskType, detectedDateTime, userPrincipalName, riskLevel |
    Sort-Object detectedDateTime -Descending | Format-Table

# 3. Flag disabled users who still hold memberships (control failure check)
Write-Host "=== CONTROL CHECK: group members with disabled accounts ==="
$members = Get-MgGroupMember -GroupId $groups[0].Id
foreach ($m in $members) {
    $u = Get-MgUser -UserId $m.Id -Property accountEnabled,userPrincipalName
    if (-not $u.AccountEnabled) {
        Write-Host "[FINDING] Disabled user retains group access: $($u.UserPrincipalName)"
    }
}
