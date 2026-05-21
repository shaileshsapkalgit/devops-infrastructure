output "student_service_irsa_arn" {
  value = aws_iam_role.student_service_irsa.arn
}

output "enrollment_service_irsa_arn" {
  value = aws_iam_role.enrollment_service_irsa.arn
}