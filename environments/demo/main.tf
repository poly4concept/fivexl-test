terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  common_tags = merge(
    {
      Environment = "demo"
      ManagedBy   = "terraform"
      Project     = "fivexl-website-challenge"
    },
    var.tags
  )
}

module "demo_static_site" {
  source = "../../modules/s3_cloudfront_site"

  # For the demo I deliberately do NOT use Route53, custom domains, or ACM.
  # I pass a simple label as "domain_name" that is only used for naming/tagging.
  domain_name         = "demo-cloudfront-only"
  hosted_zone_id      = null
  acm_certificate_arn = null
  tags                = local.common_tags
}

resource "aws_s3_object" "index" {
  bucket       = module.demo_static_site.bucket_id
  key          = "index.html"
  source       = "${path.module}/../../site/index.html"
  etag         = filemd5("${path.module}/../../site/index.html")
  content_type = "text/html"
}

output "cloudfront_domain_name" {
  description = "Default CloudFront domain name for the demo static site."
  value       = module.demo_static_site.cloudfront_domain_name
}

