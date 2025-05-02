variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "sungbin-eks"
}

variable "region" {
  type    = string
  default = "ap-northeast-2"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

