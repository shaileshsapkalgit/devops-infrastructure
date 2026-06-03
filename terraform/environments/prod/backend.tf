terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-836095228526"
    key            = "prod/terraform.tfstate"  # Alag key - prod ka alag state!
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}