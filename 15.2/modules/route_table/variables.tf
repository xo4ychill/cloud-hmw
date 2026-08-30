variable "route_table_name" {
  description = "Имя route table"
  type        = string
}

variable "network_id" {
  description = "ID VPC-сети (из модуля network)"
  type        = string
}

variable "nat_instance_internal_ip" {
  description = "Внутренний IP NAT-инстанса (next hop для статического маршрута 0.0.0.0/0)"
  type        = string
}

variable "environment" {
  description = "Окружение — для лейблов ресурсов"
  type        = string
  default     = "dev"
}
