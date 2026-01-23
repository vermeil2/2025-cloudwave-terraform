terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95"
    }
  }
  backend s3 {
    bucket         = "staging-prod-tfstate-s3" # S3 버킷 이름
    key            = "terraform.tfstate" # tfstate 저장 경로
    region         = "ap-northeast-2"
    use_lockfile = true
  }
}

