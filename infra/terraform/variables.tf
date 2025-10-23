variable "ssh_key_path" {
  description = "Path to your SSH private key"
  default     = "~/.ssh/ecommerce-key.pem"
}

variable "repo_url" {
  description = "Git repository URL of ecommerce-microservices"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "region" {
  description = "AWS region"
  default     = "us-east-2"
}
