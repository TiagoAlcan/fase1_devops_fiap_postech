variable "aws_region" {
  description = "Região da AWS onde a infraestrutura será criada."
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Profile do AWS CLI usado pelo Terraform."
  type        = string
  default     = "personal"
}

variable "project_name" {
  description = "Prefixo usado no nome dos recursos."
  type        = string
  default     = "togglemaster"
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs das sub-redes públicas (uma por AZ)."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs das sub-redes privadas (uma por AZ)."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "ssh_allowed_cidrs" {
  description = "IPs autorizados a acessar a EC2 via SSH (um por integrante do grupo), no formato x.x.x.x/32."
  type        = list(string)

  validation {
    condition     = length(var.ssh_allowed_cidrs) > 0 && alltrue([for c in var.ssh_allowed_cidrs : can(cidrhost(c, 0)) && c != "0.0.0.0/0"])
    error_message = "Informe ao menos um CIDR válido e específico (ex.: 203.0.113.10/32). 0.0.0.0/0 não é permitido."
  }
}

variable "ssh_public_key" {
  description = "Conteúdo da chave pública SSH (ex.: saída de `cat ~/.ssh/id_ed25519.pub`)."
  type        = string
}

variable "ssh_extra_public_keys" {
  description = "Chaves públicas SSH dos demais integrantes do grupo."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for k in var.ssh_extra_public_keys : can(regex("^(ssh-(ed25519|rsa)|ecdsa-sha2-nistp(256|384|521)) [A-Za-z0-9+/=]+( [^']*)?$", k))])
    error_message = "Cada item deve ser uma chave pública SSH válida (ex.: \"ssh-ed25519 AAAA... nome\")."
  }
}

variable "instance_type" {
  description = "Tipo da instância EC2."
  type        = string
  default     = "t3.micro"
}

variable "instance_profile_name" {
  description = "Instance profile já existente (ex.: \"LabInstanceProfile\" no AWS Academy). Se nulo, um novo role é criado."
  type        = string
  default     = null
}

variable "db_instance_class" {
  description = "Classe da instância RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "Versão major do PostgreSQL."
  type        = string
  default     = "16"
}

variable "db_name" {
  description = "Nome do banco de dados da aplicação."
  type        = string
  default     = "togglemaster"
}

variable "db_username" {
  description = "Usuário administrador do RDS."
  type        = string
  default     = "togglemaster_admin"
}

variable "app_repo_url" {
  description = "Repositório Git com o código da aplicação."
  type        = string
  default     = "https://github.com/dougls/toggle-master-monolith.git"
}
