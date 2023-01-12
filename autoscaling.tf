resource "aws_appautoscaling_target" "autoscaling_target" {
  count              = var.max_instance_count > 1 ? 1 : 0
  min_capacity       = var.min_instance_count
  max_capacity       = var.max_instance_count
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "autoscaling_memory_policy" {
  count              = var.max_instance_count > 1 ? 1 : 0
  name               = "${var.name}-memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscaling_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaling_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscaling_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.autoscaling_memory_limit
  }
}

resource "aws_appautoscaling_policy" "autoscaling_cpu_policy" {
  count              = var.max_instance_count > 1 ? 1 : 0
  name               = "${var.name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.autoscaling_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.autoscaling_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.autoscaling_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = var.autoscaling_cpu_limit
  }
}