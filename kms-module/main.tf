terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

variable "create" {}
variable "description" {}
variable "tags" {}

resource "aws_kms_key" "eks" {
  count       = var.create ? 1 : 0
  description = var.description
  tags        = var.tags
}

output "key_arn" {
  value = try(aws_kms_key.eks[0].arn, "")
}
