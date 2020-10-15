data "aws_caller_identity" "current" {}

# Map role on external clusters
resource "aws_iam_role" "argocd" {
  name               = "argocd-k8s-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.account-assume.json
}

data "aws_iam_policy_document" "account-assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}
