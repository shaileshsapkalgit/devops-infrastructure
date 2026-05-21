variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "prod"
}

variable "project_name" {
  type    = string
  default = "devops-portfolio"
}

variable "aws_account_id" {
  type    = string
  default = "334044476918"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"  # Prod - alag CIDR range!
}

variable "cluster_name" {
  type    = string
  default = "devops-portfolio-prod"
}

variable "cluster_version" {
  type    = string
  default = "1.30"
}

variable "node_instance_type" {
  type    = string
  default = "t3.large"
}

variable "node_desired_size" {
  type    = number
  default = 3
}

variable "node_min_size" {
  type    = number
  default = 2
}

variable "node_max_size" {
  type    = number
  default = 5
}