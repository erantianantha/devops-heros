# Session 12: Troubleshooting Guide & Common Pitfalls

This directory covers common debugging scenarios, production gotchas, and edge cases encountered when working with Kubernetes ConfigMaps, Secrets, and Ingress.

---

## 📑 Troubleshooting Guides

### 1. [The Trailing Newline Secret Bug](file:///Users/ananthadatta/Desktop/devops-heros/session-12-ingress-configmaps-secrets/troubleshooting/secret-base64-gotcha.md)
- **Symptom:** Authentication failures or invalid tokens even though the raw string looks identical.
- **Root Cause:** Using `echo` instead of `echo -n` embeds an ASCII newline (`\n` / `0x0a`) into the Base64-encoded string.
- **Fix:** Always encode secrets using `echo -n "<secret>" | base64`.

---

## 🔍 Additional Common Gotchas

### 2. ConfigMap Updates Not Reflected in Container
- **Environment variables (`env`, `envFrom`)**: Evaluated only at container process startup. Updating a ConfigMap will **not** update environment variables in running pods.
  - **Resolution:** Trigger a rolling update with `kubectl rollout restart deployment/<deployment-name>`.
- **Volume Mounts with `subPath`**: When a file is mounted into a container using `volumeMounts.subPath`, Kubernetes will **not** dynamically update the file when the ConfigMap changes.
  - **Resolution:** Mount the entire directory instead of using `subPath`, or restart the pod.

### 3. Ingress Routing Issues
- **HTTP 404 Not Found**: The Ingress Controller received the request, but no host or path rules matched the URL.
  - Check `kubectl describe ingress <ingress-name>` and ensure the `host` and `path` match the request URL and headers.
  - Check path type (`Prefix` vs `Exact`).
- **HTTP 503 Service Unavailable**: The Ingress route matched, but the targeted Service has no healthy backend endpoints.
  - Check `kubectl get endpoints <service-name>` — if it shows `<none>`, verify that the Service `selector` matches the Pod labels and that the Pods are passing readiness probes.
