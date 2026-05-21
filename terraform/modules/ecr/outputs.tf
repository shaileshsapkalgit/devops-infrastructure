output "student_service_url" {
  description = "Student service ECR URL"
  value       = aws_ecr_repository.student_service.repository_url
}

output "enrollment_service_url" {
  description = "Enrollment service ECR URL"
  value       = aws_ecr_repository.enrollment_service.repository_url
}

output "student_service_name" {
  description = "Student service ECR name"
  value       = aws_ecr_repository.student_service.name
}

output "enrollment_service_name" {
  description = "Enrollment service ECR name"
  value       = aws_ecr_repository.enrollment_service.name
}