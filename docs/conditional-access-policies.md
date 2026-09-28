# Conditional Access & MFA Policy Design

Policies tested in the lab tenant:

| # | Policy | Applied to | Rationale |
|---|---|---|---|
| 1 | Require MFA for all users | All users | Baseline; blocks token replay from phished passwords |
| 2 | Block legacy authentication | All users | Legacy protocols bypass MFA entirely |
| 3 | Require MFA + compliant device for admin | Global admin/privileged roles | Higher bar for privileged accounts; standing privilege is already avoided via RBAC model |
| 4 | Sign-in risk: require MFA on risky sign-in | All users | Risk-based step-up; pairs with the risky-sign-in section of the access review script |

## Evidence produced
- Policy export per configuration (`Get-MgIdentityConditionalAccessPolicy`)
- Sign-in logs filtered per policy result (success/blocked)
- Test matrix: each policy verified with a passing and a failing scenario

## What this demonstrates for GRC/IAM roles
Policy design tied to risk tiers, MFA coverage verification, and — critically for audit work — producing the **evidence trail** that proves the control operates, not just that it exists.
