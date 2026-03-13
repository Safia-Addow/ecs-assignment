resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.project}/DB_PASSWORD"
  type  = "SecureString"
  value = var.db_password
}

resource "aws_ssm_parameter" "api_key" {
  name  = "/${var.project}/API_KEY"
  type  = "SecureString"
  value = var.api_key
}