# The name of a pre-set SSH keypair created and downloaded from the AWS console.
#
# https://console.aws.amazon.com/ec2/v2/home?region=ap-southeast-2#KeyPairs:
variable "deployer_key_name"     {
  description = "AWS key pair name."
  default = "pipelite"
}

variable "aws_region"     {
  description = "AWS region to host your network."
  default = "ap-southeast-2"
}

variable "pipelite_instance_type" {
  description = "Instance type"
  default = "t2.small"
}

variable "resource_group_tag" {
  description = "The group name to tag resources with."
  default = "Pipelite"
}

variable "security_group_name" {
  description = "Security group name."
  default = "Pipelite"
}

variable "office_cidr" {
  description = "Public IP CIDR where the lights are located."
}

variable "elb_name" {
  description = "ELB name."
  default = "Pipelite"
}

variable "docker-amis" {
  description = "Docker, 15.04 Ubuntu AMI"
}
