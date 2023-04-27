output "endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "aws_eks_cluster_kubeconfig_ca_data" {
  value     = aws_eks_cluster.this.certificate_authority[0].data
  sensitive = true
}

output "name" {
  value = aws_eks_cluster.this.name
}
