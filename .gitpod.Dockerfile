FROM gitpod/workspace-full:latest

# kubectl
ARG KUBECTL_VERSION=v1.22.2

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    sudo mv ./kubectl /usr/local/bin/kubectl && \
    mkdir ~/.kube

# Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    (cd /tmp/ ; unzip /tmp/awscliv2.zip) && \
    sudo /tmp/aws/install && \
    rm -rf /tmp/awscliv2.zip /tmp/aws
