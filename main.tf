terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


variable "names" {
  type    = list(string)
  default = ["nodejs_instance", "postgresql_instance", "react_instance"]
}



resource "aws_instance" "worker_nodes" {
  ami                  = "ami-0f095f89ae15be883"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.jenkins-project-profile.name
  vpc_security_group_ids = [aws_security_group.instances_sg.id]
  count                = 3

  tags = {
    Name = "${element(var.names, count.index)}"
  }
}

# Security group for all instances
resource "aws_security_group" "instances_sg" {
  name        = "instances_sg"
  description = "Security group for the web application instances"

  # Ingress rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # SSH access from anywhere
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Node.js port access from anywhere
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # PostgreSQL port access from anywhere
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # React port access from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # React port access from anywhere
  }
  # Egress rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
}

# Outputs for IP addresses of each application server
output "node_public_ip" {
  value = aws_instance.worker_nodes[0].public_ip
}

output "postgres_private_ip" {
  value = aws_instance.worker_nodes[1].private_ip
}

output "react_ip" {
  value = aws_instance.worker_nodes[2].public_ip
}
