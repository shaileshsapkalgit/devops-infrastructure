terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-361697161922"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
