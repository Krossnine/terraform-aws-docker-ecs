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

variable "health_check_threshold" {
  default = 3
}

variable "health_check_timeout" {
  default = 30
}

variable "health_check_unhealthy_threshold" {
  default = 2
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
  description = "Public vpc subnets for load balancer. If vpc_public_subnets is null then alb will use private subnets"
  default = null
}

variable "https_enabled" {
  description = "Should enable https for alb ?"
}

variable "ssl_policy" {
  default = "ELBSecurityPolicy-TLS-1-2-2017-01"
  description = "SSL security policy"
}

variable "wait_for_steady_state" {
  description = "Wait for steady state"
  default     = true
}

variable "force_new_deployment" {
  description = "Force new deployment"
  default     = true
}

variable "ecs_ingress_rules" {
  description = "ECS task ingress rules"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = optional(string, "tcp")
    cidr_blocks      = optional(list(string), ["0.0.0.0/0"])
    description      = optional(string)
    ipv6_cidr_blocks = optional(list(string))
    prefix_list_ids  = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))

  default = []
}

variable "ecs_egress_rules" {
  description = "ECS ingress rules"
  type = list(object({
    from_port        = number
    to_port          = number
    protocol         = optional(string, "tcp")
    cidr_blocks      = optional(list(string), ["0.0.0.0/0"])
    description      = optional(string)
    ipv6_cidr_blocks = optional(list(string), ["::/0"])
    prefix_list_ids  = optional(list(string))
    security_groups  = optional(list(string))
    self             = optional(bool)
  }))

  default = [
    {
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
}
