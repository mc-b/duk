FROM gitpod/workspace-base:2022-09-11-15-11-40

# kubectl
ARG KUBECTL_VERSION=v1.22.2
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    sudo mv ./kubectl /usr/local/bin/kubectl && \
    mkdir ~/.kube

# helm3
RUN curl -L https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# kubefwd
RUN wget https://github.com/txn2/kubefwd/releases/download/1.22.3/kubefwd_Linux_x86_64.tar.gz -O /tmp/kubefwd.tgz && \
    tar xzf /tmp/kubefwd.tgz kubefwd && \
    sudo mv kubefwd /usr/local/bin/kubefwd && \
    rm -f /tmp/kubefwd.tgz

# Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" && \
    (cd /tmp/ ; unzip /tmp/awscliv2.zip) && \
    sudo /tmp/aws/install && \
    rm -rf /tmp/awscliv2.zip /tmp/aws

# terraform, wireguard and python
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - && \
    sudo apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    sudo apt-get update && \
    sudo install-packages wireguard terraform python pip
