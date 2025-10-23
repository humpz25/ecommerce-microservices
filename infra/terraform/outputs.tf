output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "frontend_url" {
  description = "Frontend URL"
  value       = "http://${aws_instance.app_server.public_ip}:5173"
}

output "catalog_url" {
  description = "Catalog service URL"
  value       = "http://${aws_instance.app_server.public_ip}:8001"
}

output "checkout_url" {
  description = "Checkout service URL"
  value       = "http://${aws_instance.app_server.public_ip}:8002"
}

output "email_url" {
  description = "Email service URL"
  value       = "http://${aws_instance.app_server.public_ip}:8003"
}

output "mailhog_url" {
  description = "Mailhog URL"
  value       = "http://${aws_instance.app_server.public_ip}:8025"
}
