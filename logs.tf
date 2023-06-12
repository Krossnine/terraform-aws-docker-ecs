resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.name
  retention_in_days = var.log_retention_in_days
  tags = merge(var.default_tags, {
    Type : "logs"
  })
}
