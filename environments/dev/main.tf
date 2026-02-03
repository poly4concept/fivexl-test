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
  region = var.aws_region
  profile = var.aws_profile
}

locals {
  static_site_domain = "${var.static_site_subdomain}.${var.domain_name}"
  ecs_site_domain    = "${var.ecs_site_subdomain}.${var.domain_name}"

  common_tags = merge(
    {
      Environment = "dev"
      ManagedBy   = "terraform"
      Project     = "fivexl-website-challenge"
    },
    var.tags
  )
}

module "static_site" {
  source = "../../modules/s3_cloudfront_site"

  domain_name         = local.static_site_domain
  hosted_zone_id      = var.hosted_zone_id
  acm_certificate_arn = var.static_site_acm_certificate_arn
  tags                = local.common_tags
}

module "ecs_site" {
  source = "../../modules/ecs_alb_site"

  domain_name   = local.ecs_site_domain
  hosted_zone_id = var.hosted_zone_id
  aws_region    = var.aws_region
  image_url     = var.ecs_image_url
  cpu           = var.ecs_cpu
  memory        = var.ecs_memory
  desired_count = var.ecs_desired_count
  tags          = local.common_tags
}

# Static site content and CloudFront invalidation

resource "aws_s3_object" "static_site_index" {
  bucket       = module.static_site.bucket_id
  key          = "index.html"
  source       = "${path.module}/../../site/index.html"
  etag         = filemd5("${path.module}/../../site/index.html")
  content_type = "text/html"
}

resource "null_resource" "static_site_invalidation" {
  triggers = {
    index_html_etag = aws_s3_object.static_site_index.etag
  }

  provisioner "local-exec" {
    command = "aws cloudfront create-invalidation --distribution-id ${module.static_site.cloudfront_distribution_id} --paths '/*'"
  }
}

output "static_site_url" {
  description = "Public URL of the static site (Route53 record)."
  value       = module.static_site.route53_record_fqdn
}

output "ecs_site_url" {
  description = "Public URL of the ECS-backed site (Route53 record)."
  value       = module.ecs_site.route53_record_fqdn
}

