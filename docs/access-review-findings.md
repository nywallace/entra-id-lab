# Access Review — Sample Findings & Evidence

## Weekly review output (sample)

=== Members of grp-Standard-Users ===
User                          Enabled  Reviewed
----                          -------  --------
[nyjah.test@labdomain.onmicrosoft.com](mailto:nyjah.test@labdomain.onmicrosoft.com)  True   2026-09-28T09:14:00
[fin.sim1@labdomain.onmicrosoft.com](mailto:fin.sim1@labdomain.onmicrosoft.com)    True   2026-09-28T09:14:00

=== Risky sign-ins (7 days) ===
riskType         detectedDateTime        userPrincipalName        riskLevel
--------        ----------------        -----------------        ---------
unfamiliarFeatures 2026-09-24T03:12Z   mover.sim2@labdomain...   medium

## Control check results

| Check | Result |
|---|---|
| Disabled user with active group membership | 1 finding (test-injected), remediated same day via offboard script |
| MFA registration coverage | 100% of enabled users |
| Legacy auth attempts | 0 (blocked by CA policy 2) |

## Finding example (injected for testing)

Test user was disabled but left in a group intentionally. Review script flagged it; remediation ran `offboard-user.ps1` and cleared the membership. This is exactly the control failure pattern audited in real offboarding reviews.

Replace this page with your own actual review output when you run the script in your tenant — keep the structure.
