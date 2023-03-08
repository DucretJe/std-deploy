output "vpc_id" {
  description = "ID of the VPC"
  value = aws_vpc.this.id
}

output "sg_id" {
  description = "ID of the security group"
  value = aws_security_group.this.id
}
