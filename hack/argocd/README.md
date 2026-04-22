# ArgoCD Health Checks for kgateway

This directory contains ArgoCD health check customizations for `gateway.kgateway.dev` resources. These health checks are implemented as Lua scripts and can be contributed to the [argoproj/argo-cd](https://github.com/argoproj/argo-cd) repository under `resource_customizations/`.

## Patterns

### Pattern 1: Standard Kubernetes Conditions
Used by: `Backend`, `GatewayExtension`
Checks the `status.conditions[]` field for an `Accepted` condition.

### Pattern 2: Gateway API Policy Attachment
Used by: `TrafficPolicy`, `ListenerPolicy`, `BackendConfigPolicy`, `HTTPListenerPolicy`
Checks the `status.ancestors[].conditions[]` field. The resource is considered healthy only if at least one ancestor is present and all ancestors have accepted the policy.

### Pattern 3: No Status
Used by: `DirectResponse`, `GatewayParameters`
Always returns `Healthy` as long as the resource exists. For `GatewayParameters`, status is currently unimplemented in the CRD.

## How to use

To use these health checks in your ArgoCD installation, you can add them to the `argocd-cm` ConfigMap:

```yaml
data:
  resource.customizations: |
    gateway.kgateway.dev/Backend:
      health.lua: |
        <content of Backend/health.lua>
    gateway.kgateway.dev/TrafficPolicy:
      health.lua: |
        <content of TrafficPolicy/health.lua>
    ...
```

The health check scripts are located in `resource_customizations/gateway.kgateway.dev/`.
