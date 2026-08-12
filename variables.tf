variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default = "ami-0011550b539717e2a"
}

variable "instance_type" {
  default = "t3.micro"
}