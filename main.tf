terraform {
  backend "s3" {
    bucket         = "mikitabucket"
    key            = "eks-cluster/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "mikitadziubkoterraformlocktable"
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "./vpc-module"

  name             = "mikitavpc"
  cidr             = "10.0.0.0/16"
  azs              = ["us-east-2a", "us-east-2b"]
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Owner       = "MikitaDziubko"
    Environment = "dev"
  }
}

resource "aws_ecr_repository" "repo" {
  name = "mikitarepo"
}

module "kms" {
  source = "./kms-module"
  
  create = true
  description = "KMS key for EKS cluster"
  tags = {
    Environment = "dev"
    Owner       = "MikitaDziubko"
  }
}

module "eks" {
  source = "./eks-module"

  cluster_name    = "mikitacluster"
  cluster_version = "1.30"
  vpc_id          = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 2
      min_capacity     = 1

      instance_type = "t3.micro"
    }
  }
  cluster_role_arn = "arn:aws:iam::443370672158:role/AWSclusterrole" 
}