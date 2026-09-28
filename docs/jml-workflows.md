# JML Workflows — Control Mapping

## Joiner
1. HR trigger (simulated) → `create-users.ps1`
2. Account created **disabled-from-day-one privilege**: only role group added, forced password change at first sign-in
3. MFA registration enforced by Conditional Access at first sign-in
4. Audit line written: `[AUDIT] ... | Action: Joiner-provision`

**Controls tested:** least privilege at provisioning, no default admin, authentication strength at onboarding.

## Mover
1. Role change (simulated) → `mover-role-change.ps1`
2. All previous role groups removed BEFORE new group assigned
3. Access tokens re-issued only under new group membership
4. Audit line: old groups revoked, new group named

**Controls tested:** privilege accumulation prevention, same-day revocation, entitlement accuracy.

## Leaver
1. Departure (simulated) → `offboard-user.ps1`
2. Order matters: disable account → revoke sessions → strip groups → reset password
3. Verification: attempted sign-in fails; risky sign-in log shows no post-departure activity
4. Audit line: full deprovision record

**Controls tested:** same-day termination, session revocation, orphaned-account prevention.

## Review cadence in this lab
- Access review script run weekly (see `access-review-findings.md` for sample output)
- Sign-in risk detections checked on the same pass
- Control failure check: disabled user still holding a group membership is a flagged finding
