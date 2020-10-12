data "aws_eks_cluster" "cluster" {
  name = module.poc-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.poc-cluster.cluster_id
}

provider "kubernetes" {
  alias                  = "argo-poc"
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "poc-cluster" {
  source = "terraform-aws-modules/eks/aws"
  providers = {
    kubernetes = kubernetes.argo-poc
  }

  cluster_name    = "argocd-poc-cluster"
  cluster_version = "1.17"
  subnets         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true

  workers_additional_policies = [

  ]

  worker_groups = [
    {
      instance_type = "t3.medium"
      asg_max_size  = 1
    }
  ]
}

data "aws_eks_cluster" "app-cluster" {
  name = module.app-cluster.cluster_id
}

data "aws_eks_cluster_auth" "app-cluster" {
  name = module.app-cluster.cluster_id
}

provider "kubernetes" {
  alias                  = "app"
  host                   = data.aws_eks_cluster.app-cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.app-cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.app-cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "app-cluster" {
  source = "terraform-aws-modules/eks/aws"
  providers = {
    kubernetes = kubernetes.app
  }

  cluster_name    = "argocd-app-cluster"
  cluster_version = "1.17"
  subnets         = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true

  workers_additional_policies = [

  ]

  worker_groups = [
    {
      instance_type = "t3.medium"
      asg_max_size  = 1
    }
  ]
}
