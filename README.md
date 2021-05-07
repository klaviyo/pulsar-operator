# Klaviyo Fork of Pulsar Operator

Temporary fork of the Pulsar operator so that Klaviyo can bootstrap one-off experimental deployments of Pulsar.

Experimental/expedience-oriented only. Not intended for Klaviyo's (current or future) production use.

### Build

```
brew install golang
make build
make image REPOSITORY=YOUR_DOCKER_REPO
make install

Use command ```kubectl get pods``` to check Pulsar Operator deploy status.

### Define Your Pulsar Cluster

We have to run an old version of Pulsar to get things working:

```yaml
---
apiVersion: pulsar.apache.org/v1alpha1
kind: PulsarCluster
metadata:
  name: blt1
spec:
  autoRecovery:
    image:
      repository: apachepulsar/pulsar
      tag: 2.5.1
      pullPolicy: IfNotPresent
  bookie:
    image:
      repository: apachepulsar/pulsar
      tag: 2.5.1
      pullPolicy: IfNotPresent
    size: 11
    storageClassName: "gp2"
    journalStorageCapacity: 10
    ledgersStorageCapacity: 10
  broker:
    image:
      repository: apachepulsar/pulsar
      tag: 2.5.1
      pullPolicy: IfNotPresent
    size: 15
  proxy:
    image:
      repository: apachepulsar/pulsar
      tag: 2.5.1
      pullPolicy: IfNotPresent
    size: 15
  zookeeper:
    image:
      repository: apachepulsar/pulsar
      tag: 2.5.1
      pullPolicy: IfNotPresent
    size: 3
```

## Other Tips

1. If you need pulsar prometheus, grafana need configuration, for example:
```
apiVersion: pulsar.apache.org/v1alpha1
kind: PulsarCluster
metadata:
  name: example-pulsarcluster
spec:
  zookeeper:
    size: 3
  autoRecovery:
    size: 3
  bookie:
    size: 3
  broker:
    size: 3
  proxy:
    size: 3
  monitor:
    enable: true                // true/false: active monitor
    prometheusPort: 30002       // prometheus expose port on kubernetes
    grafanaPort: 30003          // grafana expose port on kubernetes
    ingress:                    // ingress configuration
      enable: true
      annotations:
        kubernetes.io/ingress.class: "nginx"
```

1. If you need pulsar manager expose by ingress, for example:
```
apiVersion: pulsar.apache.org/v1alpha1
kind: PulsarCluster
metadata:
  name: example-pulsarcluster
spec:
  zookeeper:
    size: 3
  autoRecovery:
    size: 3
  bookie:
    size: 3
  broker:
    size: 3
  proxy:
    size: 3
  manager:
    enable: true                            // true/false: active manager
    host: manager.pulsar.com
    annotations:
      kubernetes.io/ingress.class: "nginx"
```
