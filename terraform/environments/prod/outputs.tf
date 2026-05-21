output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "ecr_student_service_url" {
  value = module.ecr.student_service_url
}

output "ecr_enrollment_service_url" {
  value = module.ecr.enrollment_service_url
}

output "student_service_irsa_arn" {
  value = module.iam_irsa.student_service_irsa_arn
}

output "enrollment_service_irsa_arn" {
  value = module.iam_irsa.enrollment_service_irsa_arn
}