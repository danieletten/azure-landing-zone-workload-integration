# Platform request: shared-service role assignment

**Status: Alternative illustrative example.** NOT required by the primary Contoso
Orders scenario. Use when a workload identity needs access to a shared platform
service in another subscription. Fictional values.

Follows
[`assets/platform-team-request.md`](../../skills/azure-landing-zone-workload-integration/assets/platform-team-request.md).

## Request identifier
REQ-orders-RBAC-illus

## Requested capability or change
Assign the workload's user-assigned managed identity `id-orders-app` the built-in
role **Key Vault Secrets User** on the shared platform Key Vault
`kv-shared-platform` in subscription `sub-platform-shared`.

## Business context
Contoso Orders must read a shared certificate/secret managed centrally by the
platform team.

## Technical justification
The identity lives in the workload subscription; the target resource is in a
different, platform-owned subscription. The workload team cannot assign roles
outside its own resources.

## Existing automated path checked
Confirmed the contract limits `identity.workloadRoleAssignmentPermissions` to the
workload's own resource groups; cross-subscription grants go through the platform.

## Platform request channel / owner
platform-requests@contoso.example (Cloud Platform Team).

## Affected subscription and environment
- Subscription (target): `sub-platform-shared`
- Environment: prod
- Affected resources: `kv-shared-platform`

## Relevant platform component
Shared platform Key Vault + RBAC.

## Security and compliance implications
Least-privilege data-plane role on a single vault; no management-plane rights; scoped
to one identity. PIM/approval may apply.

## Alternatives considered
Duplicating the secret into the workload Key Vault — rejected (defeats central
management and rotation).

## Why workload-side remediation is insufficient
The workload team cannot assign roles on resources it does not own.

## Requested completion or dependency date
Before the feature that consumes the shared secret ships.

## Request owner
T. Lead, Contoso Orders.

## Validation and acceptance criteria
`id-orders-app` can read the specific secret from `kv-shared-platform`; it has no
other permissions on the vault.

## Rollback or expiry (where applicable)
Time-bound if the access is temporary; review at access recertification.
