output "alb" {
  description = "The load balancer resource"
  value       = {
    zone_id    = aws_lb.lb.zone_id
    arn        = aws_lb.lb.arn
    arn_suffix = aws_lb.lb.arn_suffix
    dns        = aws_lb.lb.dns_name
    uri        = "http${var.https_enabled?"s":""}://${aws_lb.lb.dns_name}"
  }
}

output "log_group" {
  description = "The log group resource"
  value       = aws_cloudwatch_log_group.log_group.arn
}
