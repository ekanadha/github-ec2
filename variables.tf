variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default = "ami-035827357e3c7e810"
}

variable "instance_type" {
  default = "t3.micro"
}