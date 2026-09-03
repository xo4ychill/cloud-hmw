variable "name" {
  description = "Имя security group"
  type        = string
}

variable "description" {
  description = "Описание security group"
  type        = string
  default     = ""
}

variable "network_id" {
  description = "ID VPC-сети (из модуля network)"
  type        = string
}

variable "environment" {
  description = "Окружение — для лейблов ресурсов"
  type        = string
  default     = "dev"
}

variable "allowed_ssh_cidr" {
  description = "CIDR, которому разрешён SSH/ICMP извне. В реальной инфраструктуре сузьте до своего IP/VPN"
  type        = string
  default     = "0.0.0.0/0"
}

variable "internal_cidrs" {
  description = "Список CIDR подсетей внутри VPC (public + private) — трафик между ними разрешён полностью"
  type        = list(string)
}

variable "default_zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}
