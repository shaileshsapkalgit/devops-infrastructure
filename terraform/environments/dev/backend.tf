terraform {
  backend "s3" {
    bucket         = "devops-terraform-state-334044476918"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}