# Responsibility model (fictional org RACI)

**Fictional** example of how one organization splits responsibilities. Other
organizations differ — this is the source that the platform team encodes into the
generated contract, not a universal model.

| Capability | Platform team | Workload team |
|---|---|---|
| Management groups, central Azure Policy | Owns | Consumes (complies) |
| Subscription vending, RBAC baseline | Owns | Requests / consumes |
| Hub networking, firewall, egress, route tables | Owns | Consumes central egress |
| Workload VNet + subnets (this product line) | Provisions | Uses (no self-create) |
| Central private DNS zones + policy DNS integration | Owns / automates | References approved zone groups |
| Private endpoints on workload resources | — | Owns |
| Identity platform (tenant, PIM, Conditional Access) | Owns | Consumes |
| Workload managed identities + RBAC on own resources | — | Owns |
| Cross-subscription access to shared services | Approves/grants | Requests |
| Central Log Analytics + diagnostic policy | Owns / automates | Consumes; owns workload alerts |
| Resource provider registration (baseline) | Registers at vending | Registers `workloadMayRegister` set |
| Cost ownership, budgets, tags | Sets budget guardrails | Owns spend + applies tags |

Requests that the workload team cannot self-serve go to the platform queue defined
in the contract (`metadata.supportChannel`).
