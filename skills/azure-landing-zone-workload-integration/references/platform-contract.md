# Platform Contract Overlay

Purpose: consume an **organization-specific** platform contract supplied as an
overlay in the workload repository, instead of embedding organization values in
this skill. The generic skill stays organization-neutral.

```
Generic public skill  +  generated platform contract  +  workload architecture/IaC
        =  workload integration assessment
```

## Where the overlay lives

Default location in the workload repository:

```
.azure-platform/
├── platform-contract.yaml   # structured facts (see assets/platform-contract-template.yaml)
└── platform-guidance.md     # human guidance and request processes
```

The contract is typically rendered by the platform team's subscription-vending
process. Treat it as **organization-supplied context, not universal truth**.

## Source precedence

When establishing platform facts, use this order (higher wins):

1. `.azure-platform/platform-contract.yaml`
2. `.azure-platform/platform-guidance.md`
3. Other organization-specific repository documentation
4. Workload IaC and application configuration
5. Read-only Azure discovery — **only with explicit user permission**
6. Official public Microsoft documentation (general behavior, never as the org's contract)
7. Clearly marked assumptions

Never treat item 6 (public reference architecture) as the organization's actual
contract.

## Provenance and freshness

Read `metadata.contractVersion`, `generatedAt`, `sourceRepository`, and
`sourceRevision`. If provenance is missing or the contract is old, proceed but
flag it as low-confidence and recommend regenerating the contract. Do not silently
trust an unversioned contract.

## Drift and conflict handling

When two sources conflict (e.g. the contract says egress is via central firewall
but the IaC deploys a NAT gateway):

1. Do not silently pick one.
2. Report a possible **platform-contract drift** condition.
3. State exactly which values conflict and their sources.
4. Point to the platform owner / update mechanism (`metadata.platformOwner`,
   `supportChannel`).
5. Do not modify central resources to resolve it.

Platform teams should update generated contracts through a pull request when the
platform changes (regenerate from the platform source, bump `contractVersion`).

## Degraded mode (no contract present)

If `.azure-platform/platform-contract.yaml` is absent:

- Say so explicitly and operate in **degraded discovery mode**.
- Fall back to the precedence list (repo docs, IaC, opt-in read-only discovery).
- State missing platform facts as assumptions/`TODO`; do **not** invent regions,
  tags, DNS zones, policies, IDs, or owners.
- Still separate workload actions from platform requests.

## Using the contract well

- Do not re-ask the workload team for facts the contract already answers.
- Do not raise a platform request for a capability the contract marks as already
  registered, automated, or workload-permitted (for example, provider already
  registered, or private DNS integrated by policy).
- Only raise a request for a genuine dependency the workload cannot compliantly
  satisfy itself.

Source links: [official-source-map.md](official-source-map.md).
