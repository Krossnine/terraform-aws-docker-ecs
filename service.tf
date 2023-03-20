resource "aws_ecs_service" "ecs_service" {
  name                  = "${var.name}-ecs"
  cluster               = var.cluster_id
  task_definition       = aws_ecs_task_definition.task.arn
  launch_type           = "FARGATE"
  platform_version      = "1.4.0"
  desired_count         = var.min_instance_count
  force_new_deployment  = var.force_new_deployment
  wait_for_steady_state = var.wait_for_steady_state

  network_configuration {
    assign_public_ip = false
    subnets          = var.vpc_private_subnets
    security_groups  = [aws_security_group.sg_ecs.id]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.main.arn
    container_name   = var.name
    container_port   = var.container_port
  }

  tags = merge(var.default_tags, {
    Type : "fargate"
  })
}
