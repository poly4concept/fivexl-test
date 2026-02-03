variable "aws_region" {
  description = "AWS region for the demo environment."
  type        = string
}

variable "aws_profile" {
  description = "Optional AWS CLI profile to use for the demo environment."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags applied to all resources in the demo environment."
  type        = map(string)
  default     = {}
}

