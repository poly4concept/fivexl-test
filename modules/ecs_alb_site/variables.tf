variable "domain_name" {
  description = "Fully qualified domain name for the ECS-backed site (e.g. app-dev.example.com)."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID where the domain_name will be created."
  type        = string
}

variable "aws_region" {
  description = "AWS region where ECS and ALB will be deployed."
  type        = string
}

variable "image_url" {
  description = "Container image URI (including tag) to run in ECS Fargate. HTML should be baked into this image."
  type        = string
}

variable "cpu" {
  description = "Fargate task CPU units."
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate task memory in MiB."
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Desired number of ECS tasks."
  type        = number
  default     = 2
}

variable "tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}

