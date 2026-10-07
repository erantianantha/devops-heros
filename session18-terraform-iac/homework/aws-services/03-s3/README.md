# S3 — Storage

- **What:** object storage with effectively unlimited capacity and 11 nines of durability. Accessed over HTTP API, not mounted as a disk.
- **Buckets:** top-level containers; the name is globally unique; each bucket lives in one region.
- **Objects:** a file + metadata, addressed by key (`logs/2026/app.log`), up to 5 TB each.
- **Storage classes:** Standard → Standard-IA → One Zone-IA → Glacier Instant/Flexible/Deep Archive (cheaper storage, slower or costlier retrieval). Intelligent-Tiering moves objects automatically.
- **Versioning:** keeps every version; protects against overwrite and delete (a delete adds a delete marker).
- **Lifecycle policies:** rules like "move to Glacier after 30 days, delete after 365".
- **Encryption:** SSE-S3 is on by default; SSE-KMS for key control and audit; TLS in transit.
- **Bucket policies:** resource-based JSON policy. Block Public Access is on by default; keep it on unless it's a static website.
- **Use cases:** backups, logs, static websites, data lakes, Terraform remote state, artifact storage.
