
variable "region" {
  default = "us-east-1"
}

variable "availability_zone" {
	default = "us-east-1c"
}

variable "ami" {
	default = "ami-009d6802948d06e52"
}

variable "instance_type" {
	default = "t2.large"
}

variable "spot_price" {
	default = "0.03"
}

variable "root_ebs_size" {
	default = "20"
}

variable "profile_name" {
  default = "ustruct"
}

variable "key_name" {
	default = "ustruct-ss-DEC18"
}

variable "ssh_key_dir" {
	default = "~/.ssh"
}

// this doesn't work

variable "iam_role" {
	default = "US-EC2-kaggle"
}

variable "my_ip" {
        default = ""
}

variable "ec2_username" {
	default = "ec2-user"
}
