#!/bin/bash
echo Bringing up a cluster

kind create cluster --image kindest/node:v${K8S_VERSION} --name my-cluster --config /root/config.yml || kind export kubeconfig --name my-cluster

echo Modifying Kubernetes config to point to Kind master node
MASTER_IP=$(docker inspect --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my-cluster-control-plane)
sed -i "s/^    server:.*/    server: https:\/\/$MASTER_IP:6443/" $HOME/.kube/config

cat >> ~/.bashrc <<EOF
alias k="kubectl"
alias kg="kubectl get"
alias kd="kubectl describe"
alias ke="kubectl exec -ti"
alias krm="kubectl delete"
alias kl="kubectl logs"
alias ka="kubectl apply -f"
alias kns="kubens"
alias kctx="kubectx"
EOF

exec "$@"
