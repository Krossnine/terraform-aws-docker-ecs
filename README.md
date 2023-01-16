# Terraform Aws Docker ECS #

This Terraform module deploys a docker image using fargate/ecs and loadbalancer

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_alb_listener.http_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener.http_redirect_to_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_listener.https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_listener) | resource |
| [aws_alb_target_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/alb_target_group) | resource |
| [aws_appautoscaling_policy.autoscaling_cpu_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.autoscaling_memory_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.autoscaling_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_cloudwatch_log_group.log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_service.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_execution_role_efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_s3_bucket.alb_logs_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.alb_log_bucket_acl](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_security_group.sg_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sg_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_iam_policy_document.ecs_task_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_cpu_limit"></a> [autoscaling\_cpu\_limit](#input\_autoscaling\_cpu\_limit) | CPU limit for autoscaling | `number` | `80` | no |
| <a name="input_autoscaling_memory_limit"></a> [autoscaling\_memory\_limit](#input\_autoscaling\_memory\_limit) | Memory limit for autoscaling | `number` | `80` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | n/a | `any` | `null` | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | n/a | `any` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Exposed port of docker | `number` | `80` | no |
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | n/a | `map` | `{}` | no |
| <a name="input_docker_image"></a> [docker\_image](#input\_docker\_image) | Name of the docker image | `any` | n/a | yes |
| <a name="input_env_vars"></a> [env\_vars](#input\_env\_vars) | n/a | `list` | `[]` | no |
| <a name="input_health_check_interval"></a> [health\_check\_interval](#input\_health\_check\_interval) | n/a | `number` | `300` | no |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | n/a | `string` | `"/"` | no |
| <a name="input_https_enabled"></a> [https\_enabled](#input\_https\_enabled) | Should enable https for alb ? | `any` | n/a | yes |
| <a name="input_log_retention_in_days"></a> [log\_retention\_in\_days](#input\_log\_retention\_in\_days) | Log retention in days | `number` | `30` | no |
| <a name="input_max_instance_count"></a> [max\_instance\_count](#input\_max\_instance\_count) | Maximum number of task instance | `number` | `2` | no |
| <a name="input_min_instance_count"></a> [min\_instance\_count](#input\_min\_instance\_count) | Minimum number of task instance | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the app (used to prefix aws resources) | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where the docker image should be deployed | `any` | n/a | yes |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | Task definition CPU | `number` | `256` | no |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | Task definition Memory | `number` | `512` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Public vpc id for load balancer | `any` | n/a | yes |
| <a name="input_vpc_private_subnets"></a> [vpc\_private\_subnets](#input\_vpc\_private\_subnets) | Private vpc subnets for ecs | `any` | n/a | yes |
| <a name="input_vpc_public_subnets"></a> [vpc\_public\_subnets](#input\_vpc\_public\_subnets) | Public vpc subnets for load balancer | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb"></a> [alb](#output\_alb) | The load balancer resource |
<!-- END_TF_DOCS -->