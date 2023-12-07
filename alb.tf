resource "aws_security_group" "sg_lb" {
  name        = var.name
  description = "SG Load balancer for ${var.name}"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = var.container_port
    to_port     = var.container_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Type : "load-balancer"
  })
}

resource "aws_lb" "lb" {
  name                       = "${var.name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg_lb.id]
  subnets                    = var.vpc_public_subnets
  enable_deletion_protection = false

  tags = merge(var.default_tags, {
    Type : "load-balancer"
  })
}

resource "aws_alb_target_group" "main" {
  name        = "${var.name}-alb-tg"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = var.health_check_threshold
    interval            = var.health_check_interval
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = "200-399"
    timeout             = var.health_check_timeout
    unhealthy_threshold = var.health_check_unhealthy_threshold
  }

  tags = merge(var.default_tags, {
    Type : "load-balancer"
  })

  depends_on = [aws_lb.lb]
}

resource "aws_alb_listener" "http_only" {
  count             = var.https_enabled ? 0 : 1
  load_balancer_arn = aws_lb.lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}

resource "aws_alb_listener" "http_redirect_to_https" {
  count             = var.https_enabled ? 1 : 0
  load_balancer_arn = aws_lb.lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "https" {
  count             = var.https_enabled ? 1 : 0
  load_balancer_arn = aws_lb.lb.id
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}