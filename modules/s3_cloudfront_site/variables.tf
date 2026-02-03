variable "domain_name" {
  description = "Fully qualified domain name for the static site (e.g. static-dev.example.com)."
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID where the domain_name will be created (unused for demo with default CloudFront domain)."
  type        = string
  default     = null
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for the CloudFront distribution (unused when cloudfront_default_certificate is true)."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags to apply to all resources."
  type        = map(string)
  default     = {}
}

