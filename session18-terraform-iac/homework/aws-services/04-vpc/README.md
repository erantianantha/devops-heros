# VPC — Networking

- **What:** your private, isolated network inside an AWS region.
- **CIDR:** the VPC's IP range, e.g. `10.20.0.0/16` (65,536 IPs). Subnets take slices of it.
- **Subnets:** a CIDR slice in **one** Availability Zone, e.g. `10.20.1.0/24`. AWS reserves 5 IPs per subnet.
- **Route tables:** decide where traffic goes; associated with subnets. Every table has a `local` route for the VPC CIDR.
- **Internet Gateway:** lets the VPC reach the internet; a route `0.0.0.0/0 → igw` makes a subnet public.
- **NAT Gateway:** sits in a public subnet so *private* subnets can reach out (updates, APIs) but can't be reached from outside. Billed per hour.
- **Security Groups:** stateful, instance-level, allow-only.
- **Network ACLs:** stateless, subnet-level, allow **and** deny, evaluated by rule number. Return traffic must be allowed explicitly.
- **Public vs private subnet:** public = route to an IGW (load balancers, bastion); private = no IGW route, only NAT (apps, databases).
