resource "aws_security_group" "eks" {
  name        = "EKS to Workers"
  description = "Security group for EKS control plane"
  vpc_id      = var.vpc_id
}

resource "aws_security_group" "worker_nodes" {
  name        = "Workers to EKS"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.eks_workers_sg_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.eks_workers_sg_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_security_group_rule" "eks_to_worker_nodes" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_nodes.id
  source_security_group_id = aws_security_group.eks.id
}

resource "aws_security_group_rule" "worker_nodes_to_eks" {
  type                     = "egress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker_nodes.id
  source_security_group_id = aws_security_group.eks.id
}
