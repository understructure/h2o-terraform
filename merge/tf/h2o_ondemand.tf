provider "aws" {
  region                  = "${var.region}" 
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${var.profile_name}"
}


data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "selected" {
  vpc_id = "${data.aws_vpc.default.id}"
  availability_zone = "${var.availability_zone}"
  default_for_az = true
}

data "external" "example" {
  program = ["sh", "get_ip.sh" ]
}

data "template_file" "flatfile" {
  template = "${file("${path.module}/flatfile.tpl")}"

  vars {
    private01 = "${aws_spot_instance_request.h2o1.private_ip}"
    private02 = "${aws_spot_instance_request.h2o2.private_ip}"
    private03 = "${aws_spot_instance_request.h2o3.private_ip}"
  }
}

resource "aws_security_group" "allow_ssh_my_ip" {
  name        = "allow_ssh_for_h2o"
  description = "Allow ssh from my IP"
  vpc_id      = "${data.aws_vpc.default.id}" 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.external.example.result.ip}/32"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_h2o_communication" {
  name        = "allow_ports_for_h2o"
  description = "Allow ports for H2O nodes to communicate"
  vpc_id      = "${data.aws_vpc.default.id}"

  ingress {
    from_port   = 54321
    to_port     = 54322
    protocol    = "tcp"
    security_groups = ["${aws_security_group.allow_ssh_my_ip.id}"]
  }

  ingress {
    from_port   = 54321
    to_port     = 54322
    protocol    = "udp"
    security_groups = ["${aws_security_group.allow_ssh_my_ip.id}"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}



resource "aws_spot_instance_request" "h2o1" {
  ami           = "${var.ami}" 
  instance_type = "${var.instance_type}"
  availability_zone = "${var.availability_zone}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.allow_ssh_my_ip.id}", "${aws_security_group.allow_h2o_communication.id}"]
  spot_price = "${var.spot_price}"
  spot_type = "one-time"
  subnet_id = "${data.aws_subnet.selected.id}"
  user_data = "${file("bootstrap_h2o_python3.sh")}"
  wait_for_fulfillment = true
  ebs_block_device = {
    device_name = "/dev/sdg"
    volume_size = 25
    volume_type = "gp2"
    delete_on_termination = true
  }

  provisioner "file" {
    content      = "complete"
    destination  = "/home/ec2-user/_SUCCESS"
    connection {
        type         = "ssh"
        user         = "${var.ec2_username}"
        private_key  = "${file("${var.ssh_key_dir}/${var.key_name}.pem")}"
  }
    }

  tags {
    Name = "h2o-001"
  } 
}

resource "aws_spot_instance_request" "h2o2" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.availability_zone}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.allow_ssh_my_ip.id}", "${aws_security_group.allow_h2o_communication.id}"]
  spot_price = "${var.spot_price}"
  spot_type = "one-time"
  subnet_id = "${data.aws_subnet.selected.id}" 
  user_data = "${file("bootstrap_h2o_python3.sh")}"
  wait_for_fulfillment = true
  ebs_block_device = {
    device_name = "/dev/sdg"
    volume_size = 25
    volume_type = "gp2"
    delete_on_termination = true
  }

  provisioner "file" {
    # content      = "${data.template_file.flatfile.rendered}"
    # destination  = "/home/ec2-user/flatfile.txt"
    content      = "complete"
    destination  = "/home/ec2-user/_SUCCESS"
    connection {
        type         = "ssh"
        user         = "${var.ec2_username}"
        private_key  = "${file("${var.ssh_key_dir}/${var.key_name}.pem")}"
  }
    }

  tags {
    Name = "h2o-002"
  }
}

resource "aws_spot_instance_request" "h2o3" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  availability_zone = "${var.availability_zone}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.allow_ssh_my_ip.id}", "${aws_security_group.allow_h2o_communication.id}"]
  spot_price = "${var.spot_price}"
  spot_type = "one-time"
  subnet_id = "${data.aws_subnet.selected.id}"
  user_data = "${file("bootstrap_h2o_python3.sh")}"
  wait_for_fulfillment = true
  ebs_block_device = {
    device_name = "/dev/sdg"
    volume_size = 25
    volume_type = "gp2"
    delete_on_termination = true
  }

  provisioner "file" {
    content      = "complete"
    destination  = "/home/ec2-user/_SUCCESS"
    connection {
        type         = "ssh"
        user         = "${var.ec2_username}"
        private_key  = "${file("${var.ssh_key_dir}/${var.key_name}.pem")}"
  }
    }

  tags {
    Name = "h2o-003"
  }
}

output "ip01" {
  value = "${aws_spot_instance_request.h2o1.private_ip}"
}

output "ip02" {
  value = "${aws_spot_instance_request.h2o2.private_ip}"
}

output "ip03" {
  value = "${aws_spot_instance_request.h2o3.private_ip}"
}

output "public01" {
  value = "${aws_spot_instance_request.h2o1.public_ip}"
}

output "public02" {
  value = "${aws_spot_instance_request.h2o2.public_ip}"
}

output "public03" {
  value = "${aws_spot_instance_request.h2o3.public_ip}"
}

output "commandout" {
  value = "${data.external.example.result}"
}

