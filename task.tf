locals {
  ecs_ingress_rules_with_container = concat(
    var.ecs_ingress_rules,
    [{
      protocol         = "tcp"
      from_port        = var.container_port
      to_port          = var.container_port
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      security_groups  = [aws_security_group.sg_lb.id]
    }]
  )
}

resource "aws_security_group" "sg_ecs" {
  name        = "${var.name}-ecs-tasks-sg"
  description = "SG for ECS"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.ecs_ingress_rules_with_container
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      cidr_blocks      = lookup(ingress.value, "cidr_blocks", null)
      description      = lookup(ingress.value, "description", null)
      ipv6_cidr_blocks = lookup(ingress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(ingress.value, "prefix_list_ids", null)
      security_groups  = lookup(ingress.value, "security_groups", null)
      self             = lookup(ingress.value, "self", null)
    }
  }

  dynamic "egress" {
    for_each = var.ecs_egress_rules
    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      cidr_blocks      = lookup(egress.value, "cidr_blocks", null)
      description      = lookup(egress.value, "description", null)
      ipv6_cidr_blocks = lookup(egress.value, "ipv6_cidr_blocks", null)
      prefix_list_ids  = lookup(egress.value, "prefix_list_ids", null)
      security_groups  = lookup(egress.value, "security_groups", null)
      self             = lookup(egress.value, "self", null)
    }
  }

  tags = merge(var.default_tags, {
    Type : "security"
  })
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.name
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.name
      image     = var.docker_image
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      environment = concat(
        var.env_vars,
        var.force_new_deployment ? [{ name : "LAST_DEPLOYMENT", value : timestamp() }] : [],
      )
      logConfiguration = {
        logDriver = "awslogs",
        "options" = {
          "awslogs-group"         = aws_cloudwatch_log_group.log_group.name
          "awslogs-stream-prefix" = var.name
          "awslogs-region"        = var.region
        }
      }
    }
  ])

  tags = merge(var.default_tags, {
    Type : "fargate"
  })
}
