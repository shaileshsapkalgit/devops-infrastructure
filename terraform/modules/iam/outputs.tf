output "eks_cluster_role_arn" {
  description = "EKS Cluster IAM Role ARN"
  value       = aws_iam_role.eks_cluster.arn
}

output "eks_nodes_role_arn" {
  description = "EKS Nodes IAM Role ARN"
  value       = aws_iam_role.eks_nodes.arn
}

output "student_service_irsa_arn" {
  description = "Student Service IRSA ARN"
  value       = aws_iam_role.student_service_irsa.arn
}

output "enrollment_service_irsa_arn" {
  description = "Enrollment Service IRSA ARN"
  value       = aws_iam_role.enrollment_service_irsa.arn
}