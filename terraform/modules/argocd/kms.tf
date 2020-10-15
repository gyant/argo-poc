resource "aws_kms_key" "key" {
  count = var.create_kms == true ? 1 : 0 # if create_kms is true, set count to 1

  description             = "Argo ${var.environment} KMS Key"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "key" {
  count = var.create_kms == true ? 1 : 0 # if create_kms is true, set count to 1

  name          = "alias/argo-${var.environment}-key"
  target_key_id = aws_kms_key.key[0].key_id
}
