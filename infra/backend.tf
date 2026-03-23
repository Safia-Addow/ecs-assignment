terraform {
  required_version = ">= 1.7.0"

  backend "s3" {

    bucket         = "ecs-assignment-tf-state-769278709379"
    key            = "ecs-assignment/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true

  }
}