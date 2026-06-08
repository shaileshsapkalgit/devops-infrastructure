terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-361697161922"
    key            = "prod/terraform.tfstate"  # Alag key - prod ka alag state!
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
