#!/bin/bash

export USERLOGIN=ec2-user

# kick off Terraform
terraform init
terraform apply -auto-approve

