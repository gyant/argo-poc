locals {
  kms_output = var.create_kms == true ? {
    arn    = aws_kms_key.key[0].arn
    key_id = aws_kms_key.key[0].key_id
  } : {}
}
