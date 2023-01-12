output "alb" {
  description = "The load balancer resource"
  value       = {
    zone_id    = aws_lb.lb.zone_id
    arn        = aws_lb.lb.arn
    arn_suffix = aws_lb.lb.arn_suffix
    dns        = aws_lb.lb.dns_name
    uri        = "http${local.https_enabled?"s":""}://${aws_lb.lb.dns_name}"
  }
}
