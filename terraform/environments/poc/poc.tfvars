environment = "poc"
route53_zone = "ryanthompson.fogops.io"
cert_fqdn = "argocd.ryanthompson.fogops.io"
tags = {
  "Environment": "poc",
  "Terraform": true,
  "Owner": "ryan.thompson@foghornconsulting.com",
}
create_eks = true
manage_aws_auth = true