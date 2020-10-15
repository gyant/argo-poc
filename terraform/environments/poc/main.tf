module "argo" {
  source = "../../modules/argocd"

  environment     = var.environment
  route53_zone    = var.route53_zone
  cert_fqdn       = var.cert_fqdn
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  create_kms      = true
  create_eks      = var.create_eks
  manage_aws_auth = var.manage_aws_auth

  tags = var.tags
}
