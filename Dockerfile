FROM alpine

ARG K8S_VERSION=1.22.0
ARG KIND_VERSION=0.11.1

ENV K8S_VERSION ${K8S_VERSION}
ENV KIND_VERSION ${KIND_VERSION}

RUN apk add --no-cache \
    bash \
    curl \
    docker \
    git \
    jq \
    openssl \
    vim \
    wget \
    nano \
    ncurses \
    unzip \
    tar \
    gettext

# Install kubectl
RUN wget "https://dl.k8s.io/release/v${K8S_VERSION}/bin/linux/amd64/kubectl"; \
    chmod +x ./kubectl; \
    mv ./kubectl /usr/local/bin/kubectl

# Install kind
RUN wget "https://github.com/kubernetes-sigs/kind/releases/download/v${KIND_VERSION}/kind-linux-amd64"; \
    chmod +x ./kind-linux-amd64; \
    mv ./kind-linux-amd64 /usr/local/bin/kind

# Install kubens and kubectx
RUN wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubens; \
    wget https://raw.githubusercontent.com/ahmetb/kubectx/master/kubectx; \
    chmod +x kubens kubectx; \
    mv kubens kubectx /usr/local/bin

RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3; \
    chmod 700 get_helm.sh; \
    ./get_helm.sh; \
    rm get_helm.sh

COPY bootstrap.sh config.yml /root/

RUN chmod +x /root/bootstrap.sh

ENTRYPOINT [ "/root/bootstrap.sh" ]
