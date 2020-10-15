variable "environment" {
  type        = string
  description = "Environment name"
}

variable "k8s_version" {
  type        = string
  default     = "1.17"
  description = "Version of k8s to configure cluster with."
}

variable "tags" {
  type        = map(string)
  description = "Desired tags to be attributed to all resources."
}

variable "route53_zone" {
  type        = string
  description = "Domain for r53 hosted zone."
}

variable "cert_fqdn" {
  type        = string
  description = "Full FQDN for the certificate."
}

variable "create_eks" {
  type        = bool
  description = "Allows optional EKS destruction variable."
  default     = true
}

variable "manage_aws_auth" {
  type        = bool
  description = "Allows a step 1 procedure for bringing down eks cluster gracefully."
  default     = true
}
