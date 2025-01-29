terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

variable "cluster_name" {}
variable "cluster_version" {}
variable "vpc_id" {}
variable "subnet_ids" {}
variable "eks_managed_node_groups" {}
variable "cluster_role_arn" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.subnet_ids

  eks_managed_node_groups = var.eks_managed_node_groups
  iam_role_arn            = var.cluster_role_arn

  cluster_endpoint_public_access = true
}

output "cluster_id" {
  value = module.eks.cluster_id
}