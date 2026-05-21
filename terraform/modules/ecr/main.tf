# ===========================================
# ECR - Student Service
# ===========================================
resource "aws_ecr_repository" "student_service" {
  name                 = "${var.project_name}/student-service"
  image_tag_mutability = "MUTABLE"

  # Image scanning - security best practice
  image_scanning_configuration {
    scan_on_push = true
  }

  # Encryption
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "student-service"
  }
}

# ===========================================
# ECR - Enrollment Service
# ===========================================
resource "aws_ecr_repository" "enrollment_service" {
  name                 = "${var.project_name}/enrollment-service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "enrollment-service"
  }
}

# ===========================================
# Lifecycle Policy - Old images auto-delete
# Cost saving - ECR storage free nahi hai
# ===========================================
resource "aws_ecr_lifecycle_policy" "student_service" {
  repository = aws_ecr_repository.student_service.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last ${var.image_retention_count} images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = var.image_retention_count
      }
      action = {
        type = "expire"
      }
    }]
  })
}

resource "aws_ecr_lifecycle_policy" "enrollment_service" {
  repository = aws_ecr_repository.enrollment_service.name

  policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last ${var.image_retention_count} images"
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = var.image_retention_count
      }
      action = {
        type = "expire"
      }
    }]
  })
}