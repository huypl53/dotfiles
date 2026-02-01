# Example: Research Skill Output

This document shows what the `/research` skill produces.

## Example Command

```bash
/research "Kubernetes autoscaling with KEDA"
```

## Execution Flow

### Step 1: Web Search
Searches for:
- "Kubernetes autoscaling with KEDA tutorial 2026"
- "KEDA best practices"
- "KEDA github examples"
- "KEDA documentation"

### Step 2: Resource Identification
Finds:
- Official KEDA documentation
- GitHub repos with examples
- Tutorial articles
- Best practice guides

### Step 3: GitHub Downloads
Downloads specific folders:
```bash
~/.claude/skills/research/gh-folder.sh \
  -o research/kubernetes-autoscaling-keda/github/keda-samples \
  https://github.com/kedacore/samples/tree/main/samples

~/.claude/skills/research/gh-folder.sh \
  -o research/kubernetes-autoscaling-keda/github/keda-docs-examples \
  https://github.com/kedacore/keda/tree/main/docs/examples
```

### Step 4: Content Extraction
Saves important articles to `docs/`

### Step 5: Documentation Generation
Creates comprehensive README

## Output Structure

```
research/kubernetes-autoscaling-keda/
├── github/
│   ├── keda-samples/
│   │   ├── azure-queue-scaler/
│   │   ├── kafka-scaler/
│   │   ├── prometheus-scaler/
│   │   └── ...
│   └── keda-docs-examples/
│       ├── scalers/
│       ├── authentication/
│       └── ...
├── docs/
│   ├── web-research.md
│   ├── downloads.log
│   ├── keda-official-concepts.md
│   └── medium-keda-production-guide.md
├── links.md
└── README.md
```

## Generated Files

### links.md

```markdown
# Research Links: Kubernetes autoscaling with KEDA

> Generated: 2026-02-01 15:30:00
> Total resources: 12

## GitHub Resources

### Repository: kedacore/keda
- **URL:** https://github.com/kedacore/keda
- **Stars:** 7,500+
- **Description:** Event-driven autoscaling for Kubernetes
- **Downloaded:** docs/examples/ → github/keda-docs-examples/
- **Last updated:** 2026-01-28

### Repository: kedacore/samples
- **URL:** https://github.com/kedacore/samples
- **Stars:** 500+
- **Description:** Sample applications and deployments using KEDA
- **Downloaded:** samples/ → github/keda-samples/
- **Last updated:** 2026-01-25

## Web Resources

### KEDA - Concepts
- **URL:** https://keda.sh/docs/concepts/
- **Source:** Official KEDA Documentation
- **Summary:** Core concepts of KEDA including scalers, triggers, and ScaledObjects
- **Saved:** docs/keda-official-concepts.md
- **Date:** 2026-02-01

### Production KEDA Deployment Guide
- **URL:** https://medium.com/@author/keda-production-guide
- **Source:** Medium
- **Summary:** Real-world production deployment patterns and gotchas
- **Saved:** docs/medium-keda-production-guide.md
- **Date:** 2025-12-15

### KEDA Scalers Reference
- **URL:** https://keda.sh/docs/scalers/
- **Source:** Official Documentation
- **Summary:** Complete list of available scalers (Kafka, Redis, Prometheus, etc.)
- **Key points:**
  - 60+ built-in scalers
  - Custom external scalers supported
  - Authentication methods
- **Date:** 2026-02-01

## Official Resources

- [KEDA Documentation](https://keda.sh/docs/)
- [KEDA GitHub](https://github.com/kedacore/keda)
- [KEDA Blog](https://keda.sh/blog/)
- [CNCF KEDA Page](https://www.cncf.io/projects/keda/)

## Community Resources

- [KEDA Slack](https://slack.k8s.io/)
- [Stack Overflow: keda tag](https://stackoverflow.com/questions/tagged/keda)
```

### docs/web-research.md

```markdown
# Web Research: Kubernetes autoscaling with KEDA

> Research Date: 2026-02-01 15:30:00
> Search queries: 5
> Sources found: 12

## Search Summary

Searched for:
1. "Kubernetes autoscaling with KEDA tutorial 2026"
2. "KEDA best practices"
3. "KEDA github examples"
4. "KEDA documentation"
5. "KEDA vs HPA comparison"

## Key Findings

### What is KEDA?

KEDA (Kubernetes Event Driven Autoscaling) is a CNCF project that extends Kubernetes autoscaling capabilities beyond CPU/memory metrics to event-driven scaling based on:
- Message queues (Kafka, RabbitMQ, Azure Queue)
- Metrics systems (Prometheus, Datadog)
- Databases (PostgreSQL, Redis)
- Cloud services (AWS SQS, GCP Pub/Sub)

### Core Concepts

1. **Scaler**
   - Component that monitors an event source
   - 60+ built-in scalers available
   - Custom external scalers supported

2. **ScaledObject**
   - Custom Resource that defines scaling behavior
   - Links a Deployment/StatefulSet to scalers
   - Configures min/max replicas and triggers

3. **ScaledJob**
   - For job-based workloads
   - Scales based on queue depth or pending items

4. **TriggerAuthentication**
   - Manages credentials for scalers
   - Supports secrets, service accounts, pod identity

### Common Use Cases

1. **Message Queue Processing**
   - Scale workers based on queue depth
   - Most common KEDA use case
   - Example: Kafka consumer scaling

2. **Scheduled Scaling**
   - CRON-based scaling
   - Predictable traffic patterns
   - Cost optimization

3. **Metrics-Based Scaling**
   - Custom application metrics via Prometheus
   - External API metrics
   - Business metrics (orders/sec, etc.)

### vs Horizontal Pod Autoscaler (HPA)

| Feature | KEDA | HPA |
|---------|------|-----|
| Metrics | Event-driven (queues, metrics) | CPU/Memory |
| Scale to Zero | Yes | No (min 1) |
| Custom Metrics | 60+ scalers built-in | Requires metrics server |
| Complexity | Higher (more options) | Lower (simpler) |
| Use Case | Event-driven workloads | Resource-based scaling |

**Recommendation:** Use KEDA for event-driven apps, HPA for traditional apps.

### Best Practices

1. **Start Simple**
   - Begin with one scaler
   - Test scaling behavior
   - Add complexity gradually

2. **Set Appropriate Cooldowns**
   - Prevent flapping
   - Default: 300s scale down, 0s scale up
   - Adjust based on workload

3. **Monitor Scaler Metrics**
   - KEDA exposes Prometheus metrics
   - Track scaler errors
   - Monitor scaling events

4. **Use Fallback**
   - Configure fallback replica count
   - Handle scaler failures gracefully

5. **Resource Limits**
   - Set proper CPU/memory limits
   - Prevent resource exhaustion
   - Consider startup time

### Common Pitfalls

1. **Aggressive Scaling**
   - Too-sensitive triggers
   - Rapid scale up/down
   - Solution: Tune cooldown periods

2. **Authentication Issues**
   - Incorrect credentials
   - Missing permissions
   - Solution: Use TriggerAuthentication properly

3. **Scaler Misconfiguration**
   - Wrong metrics
   - Incorrect thresholds
   - Solution: Test with kubectl describe scaledobject

## Top Resources

1. **Official Docs** (⭐⭐⭐⭐⭐)
   - https://keda.sh/docs/
   - Comprehensive, up-to-date
   - Great examples

2. **KEDA Samples Repo** (⭐⭐⭐⭐⭐)
   - https://github.com/kedacore/samples
   - Real-world examples
   - Multiple scalers demonstrated

3. **Production Guide** (⭐⭐⭐⭐)
   - Medium article (see links.md)
   - Production experience
   - Gotchas and solutions

## Related Topics to Explore

- KEDA HTTP Add-on for HTTP-based scaling
- KEDA integration with Argo Rollouts
- Custom external scalers development
- KEDA with serverless frameworks (Knative)

---

*Research compiled: 2026-02-01 15:30:00*
```

### docs/downloads.log

```
[2026-02-01 15:32] Starting download: kedacore/samples/tree/main/samples
[2026-02-01 15:32] Method: SVN export
[2026-02-01 15:32] Output: research/kubernetes-autoscaling-keda/github/keda-samples/
[2026-02-01 15:33] Status: Success
[2026-02-01 15:33] Files downloaded: 28
[2026-02-01 15:33] Size: 1.2 MB

[2026-02-01 15:33] Starting download: kedacore/keda/tree/main/docs/examples
[2026-02-01 15:33] Method: SVN export
[2026-02-01 15:33] Output: research/kubernetes-autoscaling-keda/github/keda-docs-examples/
[2026-02-01 15:34] Status: Success
[2026-02-01 15:34] Files downloaded: 45
[2026-02-01 15:34] Size: 890 KB

[2026-02-01 15:34] Download summary: 2 folders, 73 total files, 2.09 MB
```

### README.md

```markdown
# Research: Kubernetes Autoscaling with KEDA

> **Generated:** 2026-02-01 15:35:00
> **Research focus:** both (web + github)
> **Resources gathered:** 12 (2 downloaded, 10 links)

## Overview

KEDA (Kubernetes Event Driven Autoscaling) is a CNCF project that extends Kubernetes autoscaling beyond CPU/memory to event-driven metrics. It enables scaling based on message queues, custom metrics, databases, and cloud services, with support for scaling to zero replicas.

This research provides comprehensive resources for understanding and implementing KEDA, including official examples, production patterns, and best practices.

## Quick Start

**Start here if you're new to KEDA:**

1. **Understand concepts:** Read `docs/keda-official-concepts.md`
2. **See examples:** Explore `github/keda-samples/`
3. **Try a simple scaler:** Start with `github/keda-samples/prometheus-scaler/`

**Already familiar? Jump to:**
- Production patterns: `docs/medium-keda-production-guide.md`
- Advanced examples: `github/keda-docs-examples/scalers/`

## Resources Summary

### Downloaded GitHub Folders (2)

#### 1. kedacore/samples - Main Samples
- **Location:** `github/keda-samples/`
- **Source:** [kedacore/samples](https://github.com/kedacore/samples/tree/main/samples)
- **Contains:** 28 complete example applications
- **Files:** YAML manifests, Dockerfiles, setup scripts
- **Best for:** Learning different scaler types

**Key examples:**
- `kafka-scaler/` - Kafka consumer autoscaling
- `prometheus-scaler/` - Custom metrics from Prometheus
- `azure-queue-scaler/` - Azure Queue Storage
- `rabbitmq-scaler/` - RabbitMQ queue depth
- `redis-scaler/` - Redis list length

#### 2. kedacore/keda - Documentation Examples
- **Location:** `github/keda-docs-examples/`
- **Source:** [kedacore/keda](https://github.com/kedacore/keda/tree/main/docs/examples)
- **Contains:** 45 example configurations
- **Files:** ScaledObject YAMLs, authentication examples
- **Best for:** Reference configurations for specific scalers

**Highlights:**
- `scalers/` - All 60+ scaler examples
- `authentication/` - TriggerAuthentication patterns
- `scaledjobs/` - Job-based scaling examples

### Web Articles & Documentation (3)

#### 1. KEDA Concepts (Official)
- **Source:** [keda.sh/docs/concepts](https://keda.sh/docs/concepts/)
- **Saved as:** `docs/keda-official-concepts.md`
- **Summary:** Core KEDA architecture and terminology
- **Key takeaways:**
  - ScaledObject vs ScaledJob
  - How scalers work
  - Trigger authentication patterns

#### 2. Production KEDA Deployment Guide
- **Source:** [Medium article](https://medium.com/@author/keda-production-guide)
- **Saved as:** `docs/medium-keda-production-guide.md`
- **Summary:** Real-world deployment patterns and gotchas
- **Key takeaways:**
  - Production configuration recommendations
  - Common pitfalls and solutions
  - Monitoring and observability setup

#### 3. KEDA Scalers Reference
- **Source:** [keda.sh/docs/scalers](https://keda.sh/docs/scalers/)
- **Summary:** Complete scaler catalog
- **Covers:** 60+ built-in scalers with config examples

## Key Concepts

### 1. Event-Driven Autoscaling
Unlike traditional HPA (CPU/memory), KEDA scales based on external events:
- Message queue depth (Kafka, RabbitMQ, SQS)
- Custom metrics (Prometheus, Datadog)
- Database load (PostgreSQL, Redis)
- Scheduled events (CRON)

### 2. Scale to Zero
KEDA can scale deployments to 0 replicas when no events are pending, saving resources. When events arrive, KEDA scales up automatically.

### 3. Scaler Architecture
Each scaler is a plugin that:
1. Monitors an external system
2. Reports current metric value
3. Triggers scaling decisions
4. Handles authentication

### 4. TriggerAuthentication
Secure credential management for scalers using:
- Kubernetes secrets
- Service accounts
- Pod identity (AWS IRSA, Azure Workload Identity)

## Best Practices

### 1. Start with One Scaler
- **Rationale:** Understand behavior before adding complexity
- **Source:** Production guide, community recommendations
- **Example:** Start with Prometheus before adding Kafka

### 2. Configure Cooldown Periods
- **Rationale:** Prevent rapid scaling (flapping)
- **Source:** Official docs
- **Recommendation:**
  - Scale down: 300s (5 minutes)
  - Scale up: 0s (immediate)
  - Adjust based on workload startup time

### 3. Set Min/Max Replicas
- **Rationale:** Prevent runaway scaling
- **Source:** Production experience
- **Recommendation:**
  ```yaml
  minReplicaCount: 1  # or 0 for scale-to-zero
  maxReplicaCount: 10 # based on cluster capacity
  ```

### 4. Monitor Scaler Health
- **Rationale:** Detect misconfiguration early
- **Source:** Production guide
- **Tools:**
  - `kubectl describe scaledobject`
  - Prometheus metrics from KEDA
  - KEDA operator logs

### 5. Use Fallback Configuration
- **Rationale:** Handle scaler failures gracefully
- **Source:** Official docs
- **Config:**
  ```yaml
  fallback:
    failureThreshold: 3
    replicas: 2
  ```

## Common Patterns

### Pattern 1: Kafka Consumer Scaling
- **Description:** Scale workers based on consumer lag
- **When to use:** Processing Kafka messages with variable load
- **Example:** `github/keda-samples/kafka-scaler/`
- **Config:**
  ```yaml
  triggers:
  - type: kafka
    metadata:
      topic: my-topic
      lagThreshold: "10"
      consumerGroup: my-group
  ```

### Pattern 2: Prometheus Metrics Scaling
- **Description:** Scale based on custom application metrics
- **When to use:** Application exposes Prometheus metrics
- **Example:** `github/keda-samples/prometheus-scaler/`
- **Config:**
  ```yaml
  triggers:
  - type: prometheus
    metadata:
      serverAddress: http://prometheus:9090
      query: sum(rate(http_requests_total[1m]))
      threshold: "100"
  ```

### Pattern 3: Queue Depth Scaling
- **Description:** Scale based on message queue length
- **When to use:** Workers processing from queues (SQS, RabbitMQ)
- **Example:** `github/keda-samples/rabbitmq-scaler/`
- **Config:**
  ```yaml
  triggers:
  - type: rabbitmq
    metadata:
      queueName: tasks
      queueLength: "5"
  ```

## Example Code

### Complete ScaledObject Example

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: kafka-scaledobject
  namespace: default
spec:
  scaleTargetRef:
    name: kafka-consumer  # deployment to scale
  minReplicaCount: 0      # scale to zero
  maxReplicaCount: 10     # max replicas
  pollingInterval: 30     # check every 30s
  cooldownPeriod: 300     # 5 min cooldown
  triggers:
  - type: kafka
    metadata:
      bootstrapServers: kafka:9092
      consumerGroup: my-group
      topic: events
      lagThreshold: "10"
    authenticationRef:
      name: keda-kafka-auth
---
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: keda-kafka-auth
  namespace: default
spec:
  secretTargetRef:
  - parameter: sasl
    name: kafka-secrets
    key: sasl
  - parameter: username
    name: kafka-secrets
    key: username
  - parameter: password
    name: kafka-secrets
    key: password
```

See `github/keda-samples/` for more complete examples with applications.

## Directory Structure

```
kubernetes-autoscaling-keda/
├── github/                           # Downloaded GitHub folders
│   ├── keda-samples/                # kedacore/samples
│   │   ├── kafka-scaler/
│   │   ├── prometheus-scaler/
│   │   ├── rabbitmq-scaler/
│   │   └── ... (25 more examples)
│   └── keda-docs-examples/          # kedacore/keda docs
│       ├── scalers/
│       ├── authentication/
│       └── scaledjobs/
├── docs/                             # Saved web content
│   ├── web-research.md              # Search findings
│   ├── downloads.log                # Download log
│   ├── keda-official-concepts.md    # KEDA concepts
│   └── medium-keda-production-guide.md
├── links.md                          # All links collected
└── README.md                         # This file
```

## Learning Path

### Beginner
1. **Understand concepts:** Read `docs/keda-official-concepts.md`
2. **Simple example:** Try `github/keda-samples/prometheus-scaler/`
3. **Deploy KEDA:** Follow official quickstart

### Intermediate
1. **Real scaler:** Implement `github/keda-samples/kafka-scaler/`
2. **Authentication:** Study `github/keda-docs-examples/authentication/`
3. **Production patterns:** Read `docs/medium-keda-production-guide.md`

### Advanced
1. **Multiple triggers:** Combine scalers in one ScaledObject
2. **Custom external scaler:** Build your own scaler
3. **KEDA internals:** Study operator source code

## References

### Official Documentation
- [KEDA Documentation](https://keda.sh/docs/)
- [KEDA Concepts](https://keda.sh/docs/concepts/)
- [Scalers Reference](https://keda.sh/docs/scalers/)
- [KEDA Blog](https://keda.sh/blog/)

### GitHub Repositories
- [kedacore/keda](https://github.com/kedacore/keda) - Main project
- [kedacore/samples](https://github.com/kedacore/samples) - Example applications
- [kedacore/http-add-on](https://github.com/kedacore/http-add-on) - HTTP scaling add-on

### Articles & Tutorials
- [Production Guide](https://medium.com/@author/keda-production-guide) - Medium, 2025-12-15
- [KEDA vs HPA](https://keda.sh/docs/concepts/scaling-deployments/) - Official comparison

### Tools & Libraries
- [KEDA CLI](https://github.com/kedacore/keda/tree/main/cmd/keda-adapter) - Command-line tool
- [KEDA Helm Chart](https://github.com/kedacore/charts) - Deployment chart

### Community
- [KEDA Slack](https://slack.k8s.io/) - #keda channel
- [Stack Overflow](https://stackoverflow.com/questions/tagged/keda)
- [CNCF KEDA Page](https://www.cncf.io/projects/keda/)

## Next Steps

### 1. Try it out

**Install KEDA:**
```bash
helm repo add kedacore https://kedacore.github.io/charts
helm install keda kedacore/keda --namespace keda --create-namespace
```

**Deploy example:**
```bash
cd github/keda-samples/prometheus-scaler
kubectl apply -f .
```

### 2. Explore examples
- Start with `github/keda-samples/prometheus-scaler/`
- Try `github/keda-samples/kafka-scaler/` if using Kafka
- Browse all scalers in `github/keda-docs-examples/scalers/`

### 3. Further research
- **KEDA HTTP Add-on** - HTTP request-based scaling
- **Custom external scalers** - Build your own scaler
- **KEDA + Argo Rollouts** - Progressive delivery
- **Serverless frameworks** - KEDA with Knative

## Notes

**KEDA vs HPA:**
- Use KEDA for event-driven workloads (queues, metrics)
- Use HPA for resource-based scaling (CPU, memory)
- Can use both together for different deployments

**Version:**
- Examples tested with KEDA 2.x
- Check compatibility with your Kubernetes version

**Cloud Integration:**
- Azure: Native support with Azure Workload Identity
- AWS: Works with IRSA for credential management
- GCP: Compatible with Workload Identity

**Performance:**
- KEDA adds minimal overhead
- Polling interval affects responsiveness
- Default 30s polling is usually sufficient

---

*Research compiled using Claude Code /research skill*
*Tool: ~/.claude/skills/research/gh-folder.sh*
*Generated: 2026-02-01 15:35:00*
```

## Final Output

```
✅ Research Complete: Kubernetes autoscaling with KEDA

📁 Location: research/kubernetes-autoscaling-keda/
📊 Summary:
   • GitHub folders: 2
   • Web articles: 3
   • Total links: 12

📚 Downloaded Resources:
   • kedacore/samples/tree/main/samples (28 files)
   • kedacore/keda/tree/main/docs/examples (45 files)

📝 Key Findings:
   • KEDA enables event-driven autoscaling beyond CPU/memory
   • 60+ built-in scalers for queues, metrics, databases
   • Scale-to-zero capability saves resources
   • Production patterns emphasize gradual rollout

📖 Documentation: research/kubernetes-autoscaling-keda/README.md

💡 Next: Review README.md for organized learning path
```
