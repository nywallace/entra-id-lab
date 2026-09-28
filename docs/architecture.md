# Tenant Architecture & RBAC Design

## Tenant setup

Free Entra ID developer tenant (Microsoft 365 Developer Program), 25 synthetic test users.

## Group model (group-based licensing/access, no direct assignments)

| Group | Purpose | Privilege |
|---|---|---|
| grp-Standard-Users | Baseline access | Standard member |
| grp-Finance-Access | Finance app/data access | App role only, no admin |
| grp-Helpdesk-Access | Tier-1 support functions | Scoped helpdesk role, no Global Admin |

## RBAC / least privilege principles applied

1. **No standing admin.** Admin tasks done via eligible (PIM-style) assignment on demand, then removed. On the free tier, done manually and logged.
2. **Access via group only.** Every assignment flows through a named group, so the access review script can attest membership in one place.
3. **Separation of duties.** The user who provisions access (joiner script run) is not the user being reviewed, and helpdesk group cannot modify its own membership.
4. **Default deny.** New users land in Standard only; anything more is an explicit, logged change.

## Why this matters for GRC roles

Every design decision above maps to a control family an IT auditor tests: access provisioning (AU/AC), least privilege (AC-6), separation of duties (AC-5), review cadence (AC-2).
