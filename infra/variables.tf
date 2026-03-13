variable "region" {
  description = "AWS region where the project will be created"
  type        = string
}

variable "project" {
  description = "Name of the project"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_a" {
  description = "CIDR block for public subnet A"
  type        = string
}

variable "public_subnet_b" {
  description = "CIDR block for public subnet B"
  type        = string
}

variable "az_a" {
  description = "Availability zone for subnet A"
  type        = string
}

variable "az_b" {
  description = "Availability zone for subnet B"
  type        = string
}

variable "domain_name" {
  description = "Root domain name"
  type        = string
}

variable "subdomain" {
  description = "Subdomain name for the application"
  type        = string
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
}