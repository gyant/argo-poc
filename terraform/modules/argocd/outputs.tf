output "cert_arn" {
  value = aws_acm_certificate.cert.arn
}

output "kms_key" {
  value = local.kms_output
}

output "role" {
  value = aws_iam_role.argocd
}
