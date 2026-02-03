variable "aws_region" {
  description = "AWS region for the dev environment."
  type        = string
}

variable "aws_profile" {
  description = "Optional AWS CLI profile to use for the dev environment."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Base domain name for dev (e.g. dev.example.com or example.com)."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID where records will be created."
  type        = string
}

variable "static_site_subdomain" {
  description = "Subdomain for the static site (without base domain)."
  type        = string
  default     = "static-dev"
}

variable "ecs_site_subdomain" {
  description = "Subdomain for the ECS site (without base domain)."
  type        = string
  default     = "app-dev"
}

variable "ecs_image_url" {
  description = "Container image URI (including tag) for the ECS site in dev."
  type        = string
}

variable "ecs_desired_count" {
  description = "Desired ECS task count for dev."
  type        = number
  default     = 1
}

variable "ecs_cpu" {
  description = "CPU units for dev ECS tasks."
  type        = number
  default     = 256
}

variable "ecs_memory" {
  description = "Memory (MiB) for dev ECS tasks."
  type        = number
  default     = 512
}

variable "static_site_acm_certificate_arn" {
  description = "ACM certificate ARN for the static site CloudFront distribution (must be in us-east-1)."
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources in dev."
  type        = map(string)
  default     = {}
}

