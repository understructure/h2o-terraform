#!/bin/bash

set -e

export EC2_USERNAME=ec2-user

# kick off Terraform
terraform init
terraform apply -auto-approve

# write file of private IP addresses to each node, modify startup to use this flatfile, and start the service automatically

# cat terraform.tfstate | jq '.modules[0].resources[].primary.attributes.private_ip' | sed 's/"//g' > flatfile.txt
cat terraform.tfstate | jq '.modules[0].resources[].primary.attributes | select(.private_ip != null) | .private_ip ' | sed 's/"//g' > flatfile.txt

# write file of public IPs to each node

# cat terraform.tfstate | jq '.modules[0].resources[].primary.attributes.public_ip' | sed 's/"//g' > public_ips.txt
cat terraform.tfstate | jq '.modules[0].resources[].primary.attributes | select(.public_ip != null) | .public_ip ' | sed 's/"//g' > public_ips.txt

# shouldn't have to sleep now that Terraform is putting a file up there
# echo "Sleep for 60 seconds to allow IP address to take"

# sleep 60

# echo "Sleep complete"

# loop over public IPs and scp flatfile of private IPs up to each node

for OUTPUT in $(cat public_ips.txt)
do
	scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/ustruct-ss-DEC18.pem -P 22 flatfile.txt ${EC2_USERNAME}@${OUTPUT}:~
done

