resource "aws_security_group" "sg_ecs" {
  name        = "${var.name}-ecs-tasks-sg"
  description = "SG for ECS"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = var.container_port
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.sg_lb.id]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
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
