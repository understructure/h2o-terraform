provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${var.profile}"
}

data "aws_vpc" "default" {
  default = true
}


resource "aws_security_group" "allow_ssh_my_ip" {
  name        = "allow_ssh_for_h2o"
  description = "Allow ssh from my IP"
  vpc_id      = "${data.aws_vpc.default.id}" 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32"]
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

