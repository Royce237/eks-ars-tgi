provider "aws" {
  region = "us-east-1"
}

# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       # version = "~> 3.21"
#     }
#   }
# }

terraform {
  required_version = "> 0.14"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
  }
}
