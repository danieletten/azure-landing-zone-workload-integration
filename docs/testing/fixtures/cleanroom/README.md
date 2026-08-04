# Contoso Orders (workload repository)

Fictional workload. Production application landing zone subscription received via
subscription vending; the platform contract is in `.azure-platform/`.

## Workload requirements

- Linux App Service API + Azure SQL Database + Blob Storage + Key Vault (Bicep in `main.bicep`).
- Data classification: Confidential; must remain in the EU.
- Inbound: private only. Outbound: calls the external payment API `api.payments.example` (HTTPS/443).
- Availability target 99.9%; RTO 4h; RPO 1h.
