variable "region" {
  description = "AWS region where the project will be created"
  type        = string
  default     = "eu-west-2"
}

variable "project" {
  description = "Name of the project"
  type        = string
  default     = "ecs-assignment"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/20"
}

variable "public_subnet_a" {
  description = "CIDR block for public subnet A"
  type        = string
  default     = "10.0.0.0/22"
}

variable "public_subnet_b" {
  description = "CIDR block for public subnet B"
  type        = string
  default     = "10.0.4.0/22"
}

variable "az_a" {
  description = "Availability zone for subnet A"
  type        = string
  default     = "eu-west-2a"
}

variable "az_b" {
  description = "Availability zone for subnet B"
  type        = string
  default     = "eu-west-2b"
}

variable "domain_name" {
  description = "Root domain name"
  type        = string
  default     = "ecs.safiaaddow.uk"
}

variable "subdomain" {
  description = "Subdomain name for the application"
  type        = string
  default     = "tm"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "api_key" {
  description = "API key"
  type        = string
  sensitive   = true
}

variable "github_repo" {
  description = "GitHub repo in format user/repo"
  type        = string
  default     = "Safia-Addow/ecs-assignment"
}

variable "image_tag" {
  description = "Docker image tag from CI/CD"
  type        = string
}

/*variable "image_url" {
  description = "image url used for the tag"
  type        = string
}
*/