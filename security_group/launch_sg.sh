#!/bin/bash

export USERLOGIN=ec2-user
export TF_VAR_my_ip=$(curl ifconfig.me)
echo "My IP address: $TF_VAR_my_ip"

# kick off Terraform
terraform init
terraform apply -auto-approve

