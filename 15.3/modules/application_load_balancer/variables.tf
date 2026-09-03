variable "name" {
  type = string
}

variable "target_group_id" {
  description = "ID target group из модуля instance_group (та же самая, что использует NLB)"
  type        = string
}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "default_zone" {
  type = string
}


variable "healthcheck_timeout" {
  description = "Таймаут проверки здоровья"
  type        = string
  default     = "5s"
}

variable "healthcheck_interval" {
  description = "Интервал проверки здоровья"
  type        = string
  default     = "10s"
}

variable "security_group_ids" {
  description = "Security group для самого ресурса ALB (не для backend-ВМ — те получают security group отдельно, через модуль vm/instance_group). Нужны правила: порт 80 снаружи + порт 30080 от диапазонов 198.18.235.0/24 и 198.18.248.0/24 (health-check узлов ALB) — см. modules/security"
  type        = list(string)
}