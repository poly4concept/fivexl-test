terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket"
    key            = "fivexl-test/dev/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    use_lockfile   = true
  }
}

