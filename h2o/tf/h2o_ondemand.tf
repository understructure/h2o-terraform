provider "aws" {
  region                  = "${var.region}" 
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${var.profile_name}"
}

resource "aws_instance" "h2o1" {
  ami           = "${var.ami}" 
  instance_type = "${var.instance_type}"
  availability_zone = "${var.availability_zone}"
  key_name = "${var.key_name}"
  security_groups = "${var.security_groups}"
  subnet_id = "${var.subnet_id}"
  user_data = "${file("bootstrap_h2o_python3.sh")}"
  ebs_block_device = {
    device_name = "/dev/sdg"
    volume_size = 25
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags {
    Name = "h2o-001"
  } 
}

resource "aws_instance" "h2o2" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.availability_zone}"
  key_name = "${var.key_name}"
  security_groups = "${var.security_groups}"
  subnet_id = "${var.subnet_id}"
  user_data = "${file("bootstrap_h2o_python3.sh")}"
  ebs_block_device = {
    device_name = "/dev/sdg"
    volume_size = 25
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags {
    Name = "h2o-002"
  }
}

resource "aws_instance" "h2o3" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.availability_zone}"
  key_name = "${var.key_name}"
  security_groups = "${var.security_groups}"
  subnet_id = "${var.subnet_id}"
  user_data = "${file("bootstrap_h2o_python3.sh")}"
  ebs_block_device = {
    device_name = "/dev/sdg"
    volume_size = 25
    volume_type = "gp2"
    delete_on_termination = true
  }
  tags {
    Name = "h2o-003"
  }
}

output "ip01" {
  value = "${aws_instance.h2o1.private_ip}"
}

output "ip02" {
  value = "${aws_instance.h2o2.private_ip}"
}

output "ip03" {
  value = "${aws_instance.h2o3.private_ip}"
}

