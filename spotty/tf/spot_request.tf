
provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${var.profile}"
}

resource "aws_spot_instance_request" "spotty" {
  availability_zone = "${var.availability_zone}"
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  spot_price = "${var.spot_price}"
  wait_for_fulfillment = true
  spot_type = "one-time"
  key_name = "${var.key_name}"
  security_groups = "${var.security_groups}"
  subnet_id = "subnet-8a2da3a7"
  user_data = "${file("bootstrap.sh")}"

  root_block_device {
    volume_size = "${var.root_ebs_size}"
  }

  connection {
    user = "ec2-user"
    key_name = "${var.key_name}"
  }

  // Tag will not be added. You can use a script to copy these to the instance but could probably also do it from
  // local with spot_instance_id that's returned
  // https://github.com/terraform-providers/terraform-provider-aws/issues/32
  tags {
    Name = "spotty"
    Env = "dev"
    InstanceType = "spot"
  }

}


output "public_dns01" {
  value = "${aws_spot_instance_request.spotty.public_dns}"
}

output "private_ip01" {
  value = "${aws_spot_instance_request.spotty.private_ip}"
}

