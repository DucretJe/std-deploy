output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "sg_id" {
  description = "ID of the security group"
  value       = aws_security_group.this.id
}

output "private_subnet_ids" {
  description = "List of IDs of the subnets"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "List of IDs of the subnets"
  value       = aws_subnet.public[*].id
}
