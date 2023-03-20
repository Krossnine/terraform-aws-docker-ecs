variable "autoscaling_cpu_limit" {
  description = "CPU limit for autoscaling"
  default     = 80
}

variable "autoscaling_memory_limit" {
  description = "Memory limit for autoscaling"
  default     = 80
}

variable "certificate_arn" {
  default = null
}

variable "cluster_id" {

}

variable "cluster_name" {

}

variable "container_port" {
  description = "Exposed port of docker"
  default     = 80
}

variable "default_tags" {
  default = {}
}

variable "health_check_path" {
  default = "/"
}

variable "health_check_interval" {
  default = 300
}

variable "docker_image" {
  description = "Name of the docker image"
}

variable "env_vars" {
  default = []
}

variable "log_retention_in_days" {
  description = "Log retention in days"
  default     = 30
}

variable "max_instance_count" {
  description = "Maximum number of task instance"
  default     = 2
}

variable "min_instance_count" {
  description = "Minimum number of task instance"
  default     = 1
}

variable "name" {
  description = "The name of the app (used to prefix aws resources)"
}

variable "region" {
  description = "The region where the docker image should be deployed"
}

variable "task_cpu" {
  description = "Task definition CPU"
  default     = 256
}

variable "task_memory" {
  description = "Task definition Memory"
  default     = 512
}

variable "vpc_id" {
  description = "Public vpc id for load balancer"
}

variable "vpc_private_subnets" {
  description = "Private vpc subnets for ecs"
}

variable "vpc_public_subnets" {
  description = "Public vpc subnets for load balancer"
}

variable "https_enabled" {
  description = "Should enable https for alb ?"
}

variable "wait_for_steady_state" {
  description = "Wait for steady state"
  default     = true
}

variable "force_new_deployment" {
  description = "Force new deployment"
  default     = true
}