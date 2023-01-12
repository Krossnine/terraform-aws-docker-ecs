resource "aws_cloudwatch_log_group" "log_group" {
  name              = var.name
  retention_in_days = var.log_retention_in_days
  tags              = merge(var.default_tags, {
    Type : "logs"
  })
}

resource "aws_s3_bucket" "alb_logs_bucket" {
  bucket = "${var.name}-alb-logs"
  tags = merge(var.default_tags, {
    Type : "logs"
  })
}

resource "aws_s3_bucket_acl" "alb_log_bucket_acl" {
  bucket = aws_s3_bucket.alb_logs_bucket.id
  acl    = "private"
}
