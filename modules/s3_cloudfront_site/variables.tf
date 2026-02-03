variable "domain_name" {
  description = "Fully qualified domain name for the static site (e.g. static-dev.example.com)."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID where the domain_name will be created."
  type        = string
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for the CloudFront distribution (must be in us-east-1 for custom domains)."
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}

