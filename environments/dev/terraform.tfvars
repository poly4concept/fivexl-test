aws_region  = "eu-west-1"
aws_profile = "dev-profile" # or null to use default credentials

domain_name    = "dev.example.com"
hosted_zone_id = "ZCHANGEDEV123"

static_site_subdomain = "static"
ecs_site_subdomain    = "app"

# Example ECR image URI; replace with your own
ecs_image_url = "123456789012.dkr.ecr.eu-west-1.amazonaws.com/fivexl-site:dev"

ecs_desired_count = 2
ecs_cpu           = 256
ecs_memory        = 512

tags = {
  Owner = "platform-team"
}

