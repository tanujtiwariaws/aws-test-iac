# Variables related to EKS Cluster

variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default = "nodejseks"
}

variable "eks_node_group_name" {
  description = "The name of the EKS node group"
  type        = string
  default = "nodejsgroup"
}

variable "eks_node_instance_type" {
  description = "EC2 instance type for the EKS nodes"
  type        = string
  default     = "t3.medium"
}

variable "eks_node_min_size" {
  description = "Minimum size of the EKS node group"
  type        = number
  default     = 1
}

variable "eks_node_max_size" {
  description = "Maximum size of the EKS node group"
  type        = number
  default     = 3
}

variable "eks_k8s_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.21"
}
