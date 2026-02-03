terraform {
  backend "s3" {
    bucket         = "poly4-terraform-state-bucket"
    key            = "fivexl-test/demo/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}

