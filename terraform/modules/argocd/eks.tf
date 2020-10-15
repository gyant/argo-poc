data "aws_eks_cluster" "cluster" {
  count = var.create_eks ? 1 : 0
  name  = module.cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  count = var.create_eks ? 1 : 0
  name  = module.cluster.cluster_id
}

provider "kubernetes" {
  alias                  = "argo-poc"
  host                   = element(concat(data.aws_eks_cluster.cluster[*].endpoint, list("")), 0)
  cluster_ca_certificate = base64decode(element(concat(data.aws_eks_cluster.cluster[*].certificate_authority.0.data, list("")), 0))
  token                  = element(concat(data.aws_eks_cluster_auth.cluster[*].token, list("")), 0)
  load_config_file       = false
  version                = "~> 1.9"
}

module "cluster" {
  source = "terraform-aws-modules/eks/aws"
  providers = {
    kubernetes = kubernetes.argo-poc
  }

  cluster_name    = "argocd-${var.environment}"
  cluster_version = var.k8s_version
  subnets         = var.subnets
  vpc_id          = var.vpc_id
  enable_irsa     = true
  create_eks      = var.create_eks
  manage_aws_auth = var.manage_aws_auth

  workers_additional_policies = [

  ]

  worker_groups = [
    {
      instance_type = "t3.medium"
      asg_max_size  = 1
      asg_min_size  = 1
    }
  ]
}
