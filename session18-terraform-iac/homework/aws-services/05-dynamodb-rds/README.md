# DynamoDB & RDS — Databases

## DynamoDB
- **NoSQL:** fully managed key-value/document DB, single-digit-ms latency at any scale, serverless (on-demand or provisioned capacity).
- **Tables / Items / Attributes:** a table holds items (rows); items are sets of attributes (fields); no fixed schema beyond the key.
- **Partition key:** hashed to pick the storage partition; must spread load evenly (e.g. `userId`).
- **Sort key:** optional second part of the key; items with the same partition key are sorted by it, enabling range queries (`orderDate`).
- **Use cases:** sessions, carts, gaming leaderboards, IoT events, Terraform state locking.

## RDS
- **Relational DB:** managed SQL databases. AWS handles patching, backups and failover; you handle schema and queries.
- **Engines:** PostgreSQL, MySQL, MariaDB, Oracle, SQL Server, plus Aurora (AWS's MySQL/Postgres-compatible engine).
- **DB instances:** sized like EC2 (`db.t4g.micro` ...) with EBS storage.
- **Security:** private subnets, Security Groups, encryption at rest (KMS) and in transit (TLS), IAM DB auth, Secrets Manager for passwords.
- **Backups:** automated daily snapshots + transaction logs → point-in-time restore (1–35 days); manual snapshots kept until deleted.
- **Multi-AZ:** synchronous standby in another AZ with automatic failover. For **availability**, not read scaling.
- **Read replicas:** asynchronous copies that serve reads. For **read scaling**; can be promoted.
- **Use cases:** transactional apps (orders, payments, users) that need joins, constraints and ACID.
