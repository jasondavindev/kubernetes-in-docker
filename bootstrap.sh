#!/bin/bash
echo Bringing up a cluster

cat > /root/kind.yml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
EOF

bash -c '/usr/local/bin/kind create cluster --image kindest/node:v1.20.0 --name my-cluster --config /root/kind.yml'

echo Modifying Kubernetes config to point to Kind master node
MASTER_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my-cluster-control-plane)
sed -i "s/^    server:.*/    server: https:\/\/$MASTER_IP:6443/" $HOME/.kube/config

exec "$@"
