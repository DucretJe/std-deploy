output "vpc_id" {
  value = aws_vpc.this.id
}

output "sg_id" {
  value = aws_security_group.this.id
}
