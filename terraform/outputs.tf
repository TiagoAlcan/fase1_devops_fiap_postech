output "app_url" {
  description = "URL pública da aplicação."
  value       = "http://${aws_instance.app.public_dns}:5000"
}

output "health_check" {
  description = "Comando para validar a aplicação."
  value       = "curl http://${aws_instance.app.public_ip}:5000/health"
}

output "ssh_command" {
  description = "Comando para acessar a EC2 via SSH."
  value       = "ssh ec2-user@${aws_instance.app.public_ip}"
}

output "rds_endpoint" {
  description = "Endpoint privado do RDS (acessível apenas pela EC2)."
  value       = aws_db_instance.main.address
}

output "db_secret_arn" {
  description = "ARN do segredo no Secrets Manager com usuário e senha do banco."
  value       = aws_db_instance.main.master_user_secret[0].secret_arn
}
