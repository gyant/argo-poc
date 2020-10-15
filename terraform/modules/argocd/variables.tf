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

variable "subnets" {
  type        = list(string)
  description = "List of subnet IDs to use for EKS cluster creation."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the network the cluster will be created in."
}

variable "create_kms" {
  type        = bool
  default     = true
  description = "Toggle whether or not the module should generate a KMS key for the user for the purpose of integartion with sops for secret encryption on an environment-by-environment basis"
}

variable "create_eks" {
  type        = bool
  default     = true
  description = "Useful for allowing us to tear down the k8s clusters gracefully."
}

variable "manage_aws_auth" {
  type        = bool
  description = "Allows a step 1 procedure for bringing down eks cluster gracefully."
  default     = true
}
