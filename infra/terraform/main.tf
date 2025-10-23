provider "aws" {
  region = var.region
}

# Fetch latest Ubuntu 20.04 LTS AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

# Security Group for SSH and microservices
resource "aws_security_group" "app_sg" {
  name        = "ecommerce-sg"
  description = "Allow SSH and microservices ports"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5173
    to_port     = 5173
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8001
    to_port     = 8003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8025
    to_port     = 8025
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.ec2_instance_type
  key_name               = "ecommerce-key"
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  tags = {
    Name = "EcommerceAppServer"
  }

  # USER DATA SCRIPT
  user_data = <<-EOF
              #!/bin/bash
              set -e

              # Update & install prerequisites
              apt-get update -y
              apt-get install -y git curl apt-transport-https ca-certificates software-properties-common

              # Install Docker
              mkdir -p /etc/apt/keyrings
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | tee /etc/apt/keyrings/docker.asc > /dev/null
              chmod a+r /etc/apt/keyrings/docker.asc
              echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu focal stable" | tee /etc/apt/sources.list.d/docker.list
              apt-get update -y
              DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-ce-rootless-extras docker-buildx-plugin

              # Add ubuntu user to docker group
              groupadd docker || true
              usermod -aG docker ubuntu || true

              # Clone repo using HTTPS with GitHub token
              REPO_URL="https://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@github.com/humpz25/ecommerce-microservices.git"
              if [ ! -d /home/ubuntu/ecommerce-microservices/.git ]; then
                  sudo -u ubuntu git clone $REPO_URL /home/ubuntu/ecommerce-microservices
              else
                  cd /home/ubuntu/ecommerce-microservices
                  sudo -u ubuntu git pull
              fi

              # Deploy microservices
              cd /home/ubuntu/ecommerce-microservices
              sudo -u ubuntu docker compose down || true
              sudo -u ubuntu docker compose up -d --build
              EOF
}
