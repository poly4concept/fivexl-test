aws_region  = "us-east-1"
aws_profile = "prod-profile" # or null to use default credentials

domain_name    = "example.com"
hosted_zone_id = "ZCHANGEPROD123"

static_site_subdomain = "www"
ecs_site_subdomain    = "app"

# Example ECR image URI; replace with your own
ecs_image_url = "123456789012.dkr.ecr.us-east-1.amazonaws.com/fivexl-site:prod"

ecs_desired_count = 2
ecs_cpu           = 512
ecs_memory        = 1024

static_site_acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/CHANGE-ME-PROD"

tags = {
  Owner = "platform-team"
}

