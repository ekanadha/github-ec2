variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  description = "AMI ID for EC2"
  type        = string
  default = "ami-002a40b851b082e7d"
}

variable "instance_type" {
  default = "t3.micro"
}