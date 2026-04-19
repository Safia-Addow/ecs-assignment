provider "aws" {
  region = "eu-west-2"
}

# -------------------------
# S3 Bucket (Terraform State)
# -------------------------
resource "aws_s3_bucket" "terraform_state" {
  bucket = "safia-ecs-terraform-state-2026"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# -------------------------
# ECR Repository
# -------------------------
resource "aws_ecr_repository" "app_repo" {
  name = "ecs-assignment-repo"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "ECR Repo"
    Environment = "dev"
  }
}