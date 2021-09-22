#!/bin/bash
echo Bringing up a cluster

cat > /root/kind.yml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 6443
    hostPort: 6443
    listenAddress: "0.0.0.0" # Optional, defaults to "0.0.0.0"
    protocol: tcp # Optional, defaults to tcp
EOF

kind create cluster --image kindest/node:v1.20.0 --name my-cluster --config /root/kind.yml || kind export kubeconfig --name my-cluster

echo Modifying Kubernetes config to point to Kind master node
MASTER_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my-cluster-control-plane)
sed -i "s/^    server:.*/    server: https:\/\/$MASTER_IP:6443/" $HOME/.kube/config

cat > ~/.bashrc <<EOF
alias k="kubectl"
alias kg="kubectl get"
alias kd="kubectl describe"
alias ke="kubectl exec -ti"
alias krm="kubectl delete"
alias ka="kubectl apply -f"
EOF

exec "$@"
