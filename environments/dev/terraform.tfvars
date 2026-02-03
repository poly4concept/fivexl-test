aws_region  = "us-east-1"
aws_profile = "dev-profile" # or null to use default credentials

domain_name    = "dev.example.com"
hosted_zone_id = "ZCHANGEDEV123"

static_site_subdomain = "static"
ecs_site_subdomain    = "app"

# Example ECR image URI; replace with your own
ecs_image_url = "123456789012.dkr.ecr.us-east-1.amazonaws.com/fivexl-site:dev"

ecs_desired_count = 1
ecs_cpu           = 256
ecs_memory        = 512

static_site_acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/CHANGE-ME-DEV"

tags = {
  Owner = "platform-team"
}

