terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  required_version = ">= 1.6.0"
}

provider "aws" {
  region = var.aws_region
}


# Get the latest Amazon Linux 2023 AMI
data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

# Security Group
resource "aws_security_group" "apache_sg" {
  name        = "terraform-apache-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-apache-sg"
  }
}

# EC2 Instance
resource "aws_instance" "apache" {
  ami           = data.aws_ssm_parameter.amazon_linux.value
  instance_type = "t2.micro"

  # IMPORTANT:
  # This must be the EC2 Key Pair NAME in AWS.
  # Do NOT put the .pem filename here.
  key_name = "demo"

  vpc_security_group_ids = [
    aws_security_group.apache_sg.id
  ]

  user_data = <<-EOF
    #!/bin/bash

    # Update packages
    dnf update -y

    # Install Apache
    dnf install -y httpd

    # Start Apache
    systemctl start httpd

    # Enable Apache after reboot
    systemctl enable httpd

    # Create test webpage
    echo "<html>
    <head>
      <title>Terraform Apache Server</title>
    </head>
    <body>
      <h1>Hello Buddy!</h1>
      <h2>Apache installed using Terraform User Data</h2>
      <p>EC2 Instance: $(hostname)</p>
    </body>
    </html>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "Terraform-Apache"
  }
}