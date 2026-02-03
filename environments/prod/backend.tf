terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "fivexl-test/prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}

