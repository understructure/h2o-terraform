#!/bin/bash

export USERLOGIN=ec2-user
export MY_IP_ADDRESS=$(curl ifconfig.me)
echo "Current IP address: $MY_IP_ADDRESS"

# kick off Terraform
terraform init
terraform apply -auto-approve

# write file of private IP addresses to each node, modify startup to use this flatfile, and start the service automatically

cat terraform.tfstate | jq '.modules[0].resources[].primary.attributes.private_ip' | sed 's/"//g' > flatfile.txt

# write file of public IPs to each node

cat terraform.tfstate | jq '.modules[0].resources[].primary.attributes.public_ip' | sed 's/"//g' > public_ips.txt

echo "Sleep for 15 seconds to allow IP address to take"

sleep 15

echo "Sleep complete"

# loop over public IPs and scp flatfile of private IPs up to each node

for OUTPUT in $(cat public_ips.txt)
do
	scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/ustruct-ss-laptop.pem -P 22 flatfile.txt ${USERLOGIN}@${OUTPUT}:~
done
