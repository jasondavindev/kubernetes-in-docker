FROM alpine

RUN apk add --no-cache \
    bash \
    curl \
    docker \
    git \
    jq \
    openssl \
    vim \
    wget \
    nano

# Install kubectl
RUN wget https://dl.k8s.io/release/v1.20.0/bin/linux/amd64/kubectl; \
    chmod +x ./kubectl; \
    mv ./kubectl /usr/local/bin/kubectl

# Install kind
RUN wget https://github.com/kubernetes-sigs/kind/releases/download/v0.11.1/kind-linux-amd64; \
    chmod +x ./kind-linux-amd64; \
    mv ./kind-linux-amd64 /usr/local/bin/kind

COPY bootstrap.sh /root/bootstrap.sh

RUN chmod +x /root/bootstrap.sh

ENTRYPOINT [ "/root/bootstrap.sh" ]
