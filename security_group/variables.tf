
variable "region" {
  default = "us-east-1"
}

variable "availability_zone" {
	default = "us-east-1a"
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

variable "profile" {
  default = "ustruct"
}

variable "key_name" {
	default = "ustruct-ss-DEC18"
}

variable "security_groups" {
	default = ["sg-041c5475",  "sg-04eeb4e0fbc2ceb89"]
}

variable "my_ip" {
        default = ""
}

// this doesn't work

variable "iam_role" {
	default = "US-EC2-kaggle"
}
