output "db_password_arn" {
  value = aws_ssm_parameter.db_password.arn
}

output "api_key_arn" {
  value = aws_ssm_parameter.api_key.arn
}