# Microsoft Entra ID | Identity Lifecycle Management Lab

Hands-on identity governance lab demonstrating joiner-mover-leaver (JML) workflows, RBAC, least privilege, MFA, Conditional Access, and access reviews in a Microsoft Entra ID tenant.

**Why this repo exists:** Proves hands-on IAM governance capability for IT GRC / IAM Analyst roles. Every workflow below maps to a control objective a GRC team audits.

## What's in here

| Path | What it demonstrates |
|---|---|
| `scripts/create-users.ps1` | Joiner: onboarding with role-based group assignment |
| `scripts/mover-role-change.ps1` | Mover: privilege changes with old-access revocation |
| `scripts/offboard-user.ps1` | Leaver: immediate de-provisioning + access revocation |
| `scripts/access-review.ps1` | Access review: group memberships + risky sign-ins |
| `docs/architecture.md` | Tenant design: groups, RBAC model, least-privilege principles |
| `docs/jml-workflows.md` | Full JML procedures with control mapping |
| `docs/access-review-findings.md` | Sample review output + audit evidence trail |
| `docs/conditional-access-policies.md` | MFA + Conditional Access policy design |

## Control objectives covered

- **JML lifecycle:** provisioning, role change, deprovisioning within defined SLA
- **Least privilege:** RBAC-scoped group memberships, no standing admin
- **MFA / Conditional Access:** risk-based policy design for admin vs. standard users
- **Access reviews:** periodic attestation of assignments, sign-in anomaly review
- **Audit evidence:** documented procedures + scripted, repeatable verification

## Tools

Microsoft Entra ID (free/developer tenant), Microsoft Graph PowerShell SDK.

## Usage

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Connect-MgGraph -Scopes "User.ReadWrite.All","Group.ReadWrite.All","Policy.Read.All","AuditLog.Read.All","Directory.AccessAsUser.All"
```

Then run scripts from `scripts/` in order. Each script is commented with the control objective it satisfies.

---

*Lab environment. Usernames are synthetic. Details reflect my own tenant testing — adjust to match yours if reusing.*
