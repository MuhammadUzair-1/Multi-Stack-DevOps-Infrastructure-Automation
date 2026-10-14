output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "frontend_public_ip" {
  description = "Public IP of frontend/bastion instance"
  value       = aws_instance.frontend.public_ip
}

output "frontend_public_dns" {
  description = "Public DNS name of frontend/bastion instance"
  value       = aws_instance.frontend.public_dns
}

output "backend_private_ip" {
  description = "Private IP of backend instance"
  value       = aws_instance.backend.private_ip
}

output "database_private_ip" {
  description = "Private IP of database instance"
  value       = aws_instance.database.private_ip
}
