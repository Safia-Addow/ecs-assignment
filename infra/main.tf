
# -------------------------
# VPC
# -------------------------

module "vpc" {
  source = "./modules/vpc"

  project          = var.project
  vpc_cidr         = var.vpc_cidr
  public_subnet_a  = var.public_subnet_a
  public_subnet_b  = var.public_subnet_b
  az_a             = var.az_a
  az_b             = var.az_b
}
# -------------------------
# ECR Repository
# -------------------------
module "ecr" {
  source  = "./modules/ecr"
  project = var.project
}

# -------------------------
# Route53 Hosted Zone Lookup
# -------------------------
data "aws_route53_zone" "zone" {
  name = var.domain_name
}

# -------------------------
# ACM Certificate
# -------------------------
module "acm" {
  source = "./modules/acm"

  domain_name = var.domain_name
  subdomain   = var.subdomain
  zone_id     = data.aws_route53_zone.zone.zone_id
}

# -------------------------
# Application Load Balancer
# -------------------------
module "alb" {
  source = "./modules/alb"

  project         = var.project
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  certificate_arn = module.acm.certificate_arn

  container_port = var.container_port
}

# -------------------------
# ECS Service
# -------------------------
module "ecs" {
  source = "./modules/ecs"

  project            = var.project
  region             = var.region
  image_url          = module.ecr.repository_url
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnets
  target_group_arn   = module.alb.target_group_arn
  alb_security_group = module.alb.alb_security_group
  container_port     = var.container_port
  desired_count      = 1
  db_password_arn = module.parameter_store.db_password_arn
  api_key_arn     = module.parameter_store.api_key_arn
}

# -------------------------
# -------------------------
# Route53 DNS Record → ALB
# -------------------------
resource "aws_route53_record" "app" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}

module "parameter_store" {
  source = "./modules/parameter-store"

  project = var.project

  db_password = var.db_password
  api_key     = var.api_key

}