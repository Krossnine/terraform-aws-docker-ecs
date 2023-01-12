locals {
  https_enabled = var.certificate_arn != null ? true: false
}