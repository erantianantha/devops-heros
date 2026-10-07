# Session 13 — Storage, HPA & Probes

minikube v1.39 · Kubernetes v1.37 · 2 nodes. All output is real.

## Task 1 — Volumes
See [`01-kubernetes-volumes/README.md`](01-kubernetes-volumes/README.md).

## Task 2 — HPA hands-on (`04-hpa/`)

| Step | Result |
| :--- | :--- |
| Deploy app + `hpa.yaml` | HPA showed `cpu: <unknown>/50%`: **no metrics-server** |
| Fix | `minikube addons enable metrics-server` → `cpu: 0%/50%` |
| Load generator ([`04-hpa/load-generator.yaml`](04-hpa/load-generator.yaml)) | 63% → scaled **1 → 2** |
| More load (4 generators) | CPU didn't rise: `wget: bad address`, node **conntrack table full** |
| Fix | generator hits `$HPA_DEMO_SERVICE_SERVICE_HOST` (no DNS) → 82% → **2 → 4 → 5** (max) |
| Stop load | held 5 min (stabilization) → 4 → 2 → 1 |

- Formula: `desired = ceil(current × currentCPU% / target%)`, e.g. `ceil(2 × 82/50) = 4`.
- Instructor's `hpa/load_generator.sh` on macOS hit **AirPlay on port 5000** (HTTP 403 AirTunes). On port 5050 the `port-forward` tunnel died after ~540 connections. In-cluster load ([`hpa/load-generator.yaml`](hpa/load-generator.yaml)) scaled yatri-backend **2 → 10**.

![no metrics](screenshots/07-hpa-unknown-no-metrics.png)
![metrics-server](screenshots/08-metrics-server.png)
![scaled](screenshots/12-hpa-scaled-out.png)
![describe](screenshots/13-hpa-describe.png)
![scale down](screenshots/14-hpa-scale-down.png)

## Probes (`05-probes/`)
- **Startup:** "has it booted?" (`2s × 30 = 60s` budget). Liveness/readiness wait for it.
- **Readiness** broken → Pod `Running` but `0/1`, removed from endpoints, curl `Connection refused`. **No restart.**
- **Liveness** broken → restart every ~20s → `CrashLoopBackOff`.
- Gotcha: probe fields on a bare Pod are immutable, so `kubectl apply` fails; use `kubectl replace --force`.

![readiness](screenshots/18-probes-readiness-broken.png)
![liveness](screenshots/19-probes-liveness-broken.png)

## Task 3 — Mini project (`mini-project/`)

| Check | Result |
| :--- | :--- |
| Deploy (ns, PVC, deployment, svc, HPA) | 2 replicas on **2 different nodes** |
| Storage persistence | guide's check passed, but the replica on the other node had an **empty `/data`** |
| Root cause | `standard` class = hostPath PV with **no nodeAffinity** → each node has its own copy |
| Fix ([`pvc-local-path.yaml`](mini-project/pvc-local-path.yaml)) | `local-path` class (WaitForFirstConsumer) pins the PV → all replicas on one node, same data |
| Fix snag | provisioner helper image hit Docker Hub **429** → pointed it at cached `busybox:1.36` |
| Service | `port-forward 8080:80` → HTTP 200 |
| HPA | guide's generator plateaued at **40%** (no scale); 2 extra DNS-free generators → 81% → **2 → 4** |
| Finding | liveness killed a busy Pod under load. Cause: **conntrack table full** (`dmesg: table full, dropping packet`) |
| Bonus 1 | target 50% → 30%: same load now scales 2 → 3 |
| Bonus 2 | bad readiness + `Recreate` strategy = **full outage** (0 endpoints) → `rollout undo` |
| Bonus 3 | bad liveness → restart every 15s → `CrashLoopBackOff` |

![deploy](screenshots/24-mini-deploy.png)
![split](screenshots/25-mini-storage-split.png)
![fixed](screenshots/29-mini-storage-fixed.png)
![hpa](screenshots/31-mini-hpa.png)
![bonus 2](screenshots/36-bonus2-readiness-gating.png)
