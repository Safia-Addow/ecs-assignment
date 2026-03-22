
############

variable "project" {
  type = string
}

variable "region" {
  type = string
}

variable "image_url" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "target_group_arn" {
  type = string
}

variable "alb_security_group" {
  type = string
}

variable "container_port" {
  type    = number
  default = 80
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "db_password_arn" {
  type = string
}

variable "api_key_arn" {
  type = string
}

variable "image_tag" {
  description = "Docker image tag"
  type        = string
}