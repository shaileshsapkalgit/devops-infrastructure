# IRSA - Student Service
resource "aws_iam_role" "student_service_irsa" {
  name = "${var.project_name}-${var.environment}-student-service-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${var.oidc_provider_url}:aud" = "sts.amazonaws.com"
          "${var.oidc_provider_url}:sub" = "system:serviceaccount:default:student-service"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "student_service_policy" {
  name = "${var.project_name}-${var.environment}-student-service-policy"
  role = aws_iam_role.student_service_irsa.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource = "arn:aws:secretsmanager:*:${var.aws_account_id}:secret:${var.project_name}/*"
    }]
  })
}

# IRSA - Enrollment Service
resource "aws_iam_role" "enrollment_service_irsa" {
  name = "${var.project_name}-${var.environment}-enrollment-service-irsa"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${var.oidc_provider_url}:aud" = "sts.amazonaws.com"
          "${var.oidc_provider_url}:sub" = "system:serviceaccount:default:enrollment-service"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "enrollment_service_policy" {
  name = "${var.project_name}-${var.environment}-enrollment-service-policy"
  role = aws_iam_role.enrollment_service_irsa.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret"
      ]
      Resource = "arn:aws:secretsmanager:*:${var.aws_account_id}:secret:${var.project_name}/*"
    }]
  })
}