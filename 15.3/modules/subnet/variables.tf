variable "subnet_name" {
  description = "Имя подсети"
  type        = string
}

variable "default_zone" {
  description = "Зона доступности"
  type        = string
}

variable "network_id" {
  description = "ID VPC-сети (из модуля network)"
  type        = string
}

variable "v4_cidr_blocks" {
  description = "Список CIDR-блоков подсети (IPv4)"
  type        = list(string)
}

variable "route_table_id" {
  description = "ID кастомной route table для этой подсети. Оставьте null для связности по умолчанию (типично для public-подсети); задайте явно для private-подсети, чтобы направить исходящий трафик через NAT-инстанс"
  type        = string
  default     = null
}

variable "environment" {
  description = "Окружение — для лейблов ресурсов"
  type        = string
  default     = "dev"
}
