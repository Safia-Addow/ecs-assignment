variable "project" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "certificate_arn" {
  type = string
}

variable "container_port" {
  type    = number
  default = 80
}