#!/bin/bash

cat <<%EOF% >$HOME/.ssh/config
StrictHostKeyChecking no
UserKnownHostsFile /dev/null
LogLevel error
User ubuntu
%EOF%


# Alias
alias tf='terraform'
alias tfa='terraform apply -auto-approve'
alias tfd='terraform destroy -auto-approve'
alias tfi='terraform init'
alias tfo='terraform output'
alias tfp='terraform plan'

cat <<%EOF% >>$HOME/.bashrc
alias tf='terraform'
alias tfa='terraform apply -auto-approve'
alias tfd='terraform destroy -auto-approve'
alias tfi='terraform init'
alias tfo='terraform output'
alias tfp='terraform plan'
