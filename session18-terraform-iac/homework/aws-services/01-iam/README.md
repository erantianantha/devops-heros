# IAM — Governance

- **What:** Identity and Access Management. Decides *who* can do *what* on *which* AWS resource. Global, free.
- **Users:** a person or app with long-term credentials (password / access keys). **Groups:** collections of users that share permissions.
- **Roles:** identities with *temporary* credentials, assumed by EC2, Lambda, other accounts, or GitHub Actions (OIDC). Prefer roles over access keys.
- **Policies:** JSON documents of `Effect / Action / Resource / Condition`. Attached to users, groups or roles. An explicit `Deny` always wins.
- **Permissions:** default is deny; access exists only where a policy allows it.
- **Least privilege:** grant only the actions and resources needed, e.g. `s3:GetObject` on one bucket, not `s3:*` on `*`.
- **Best practices:** MFA on root and never use root day to day; no long-lived keys in code; roles for workloads; review with IAM Access Analyzer.
- **Use cases:** EC2 role to read S3; CI pipeline role to deploy; read-only auditor group.
