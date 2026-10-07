# EC2 — Compute

- **What:** virtual machines in AWS. Pay per second while running.
- **AMI:** the image an instance boots from (OS + preinstalled software), e.g. Amazon Linux 2023, Ubuntu.
- **Instance types:** family + size, e.g. `t3.micro` (burstable, free tier), `m7g` (general), `c7` (compute), `r7` (memory).
- **Key pairs:** SSH key; AWS keeps the public half, you keep the `.pem`. SSM Session Manager avoids keys entirely.
- **Security Groups:** stateful firewall on the instance, *allow rules only*. Return traffic is allowed automatically.
- **EBS:** network block disk attached to an instance; survives stop/start; snapshots go to S3.
- **Public vs private IP:** private IP is for inside the VPC and stays the same; public IP is auto-assigned and changes on stop/start. Use an Elastic IP for a fixed one.
- **Lifecycle:** `pending → running → stopping → stopped → (start)` or `→ terminated` (gone; root EBS deleted by default).
- **Use cases:** web/app servers, build agents, Kubernetes worker nodes, batch jobs.
