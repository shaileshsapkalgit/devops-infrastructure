# ===========================================
# EKS CLUSTER
# ===========================================
resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-${var.environment}"
  version  = var.cluster_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = concat(var.private_subnet_ids, var.public_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true

    # Security group
    security_group_ids = [aws_security_group.eks_cluster.id]
  }

  # Logging - CloudWatch
  enabled_cluster_log_types = ["api", "audit", "authenticator"]

  depends_on = [var.cluster_role_arn]

  tags = {
    Name = "${var.project_name}-${var.environment}-eks"
  }
}

# ===========================================
# OIDC PROVIDER
# IRSA ke liye zaruri - pod level AWS access
# ===========================================
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# ===========================================
# SECURITY GROUP - EKS Cluster
# ===========================================
resource "aws_security_group" "eks_cluster" {
  name        = "${var.project_name}-${var.environment}-eks-cluster-sg"
  description = "EKS Cluster security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Kubernetes API server"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-eks-cluster-sg"
  }
}

# ===========================================
# SECURITY GROUP - EKS Nodes
# ===========================================
resource "aws_security_group" "eks_nodes" {
  name        = "${var.project_name}-${var.environment}-eks-nodes-sg"
  description = "EKS Nodes security group"
  vpc_id      = var.vpc_id

  # Nodes ke beech communication
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
    description = "Node to node communication"
  }

  # Cluster se nodes tak
  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster.id]
    description     = "Cluster to nodes"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-eks-nodes-sg"
  }
}

# ===========================================
# EKS NODE GROUP
# Dev: Spot instances (70% cost saving!)
# Prod: On-demand (reliable)
# ===========================================
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.project_name}-${var.environment}-nodes"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  # Instance config
  instance_types = [var.node_instance_type]

  # Spot vs On-demand
  capacity_type = var.use_spot_instances ? "SPOT" : "ON_DEMAND"

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  # Auto update
  update_config {
    max_unavailable = 1
  }

  # Node labels
  labels = {
    environment = var.environment
    node-type   = var.use_spot_instances ? "spot" : "on-demand"
  }

  depends_on = [var.node_role_arn]

  tags = {
    Name = "${var.project_name}-${var.environment}-nodes"
    "k8s.io/cluster-autoscaler/enabled"                             = "true"
    "k8s.io/cluster-autoscaler/${var.project_name}-${var.environment}" = "owned"
  }
}