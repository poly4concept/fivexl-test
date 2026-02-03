variable "aws_region" {
  description = "AWS region for the prod environment."
  type        = string
}

variable "aws_profile" {
  description = "Optional AWS CLI profile to use for the prod environment."
  type        = string
  default     = null
}

variable "domain_name" {
  description = "Base domain name for prod (e.g. example.com)."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID where records will be created."
  type        = string
}

variable "static_site_subdomain" {
  description = "Subdomain for the static site (without base domain)."
  type        = string
  default     = "www"
}

variable "ecs_site_subdomain" {
  description = "Subdomain for the ECS site (without base domain)."
  type        = string
  default     = "app"
}

variable "ecs_image_url" {
  description = "Container image URI (including tag) for the ECS site in prod."
  type        = string
}

variable "ecs_desired_count" {
  description = "Desired ECS task count for prod."
  type        = number
  default     = 3
}

variable "ecs_cpu" {
  description = "CPU units for prod ECS tasks."
  type        = number
  default     = 512
}

variable "ecs_memory" {
  description = "Memory (MiB) for prod ECS tasks."
  type        = number
  default     = 1024
}

variable "tags" {
  description = "Common tags applied to all resources in prod."
  type        = map(string)
  default     = {}
}

