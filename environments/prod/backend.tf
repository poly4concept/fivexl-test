terraform {
  backend "s3" {
    bucket         = "CHANGE_ME-prod-terraform-state-bucket"
    key            = "fivexl-test/prod/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "CHANGE_ME-prod-terraform-locks"
    encrypt        = true
  }
}

