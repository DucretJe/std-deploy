locals {
  subnet_ids = (
    var.eks_private_access && !var.eks_public_access ? var.eks_cluster_private_subnets_ids :
    !var.eks_private_access && var.eks_public_access ? var.eks_cluster_public_subnets_ids :
    var.eks_private_access && var.eks_public_access ? concat(var.eks_cluster_private_subnets_ids, var.eks_cluster_public_subnets_ids) :
    []
  )
}
