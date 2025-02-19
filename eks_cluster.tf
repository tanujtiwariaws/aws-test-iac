# 1. Create the EKS Cluster
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.eks_cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn
  vpc_config {
    subnet_ids = [var.webserver_subnet_id[var.env]]
  }

  version = var.eks_k8s_version

  tags = {
    Name = var.eks_cluster_name
  }
}

# 2. IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.eks_cluster_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AmazonEKSClusterPolicy to the EKS cluster role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# Attach AmazonEC2ContainerRegistryReadOnly to the EKS cluster role (to allow the cluster to pull images)
resource "aws_iam_role_policy_attachment" "eks_ecr_readonly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_cluster_role.name
}

# 3. Create Node Group for EKS
resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.eks_node_group_name
  node_role_arn       = aws_iam_role.eks_node_role.arn
  subnet_ids      = [var.webserver_subnet_id[var.env]]
  instance_types  = [var.eks_node_instance_type]
  scaling_config {
    desired_size = var.eks_node_min_size
    max_size     = var.eks_node_max_size
    min_size     = var.eks_node_min_size
  }

  tags = {
    Name = "${var.eks_cluster_name}-node-group"
  }
}

# 4. IAM Role for EKS Node Group
resource "aws_iam_role" "eks_node_role" {
  name               = "${var.eks_node_group_name}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AmazonEKSWorkerNodePolicy to the EKS node role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

# Attach AmazonEC2ContainerRegistryReadOnly to the EKS node role
resource "aws_iam_role_policy_attachment" "eks_ecr_readonly_node" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

resource "kubernetes_service" "app_service" {
  metadata {
    name      = "app-service"
    namespace = "default"
  }
  spec {
    selector = {
      app = "my-app"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}
