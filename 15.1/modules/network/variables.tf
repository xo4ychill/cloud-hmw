variable "network_name" {
  description = "Имя VPC-сети"
  type        = string
}

variable "environment" {
  description = "Окружение — для лейблов ресурсов"
  type        = string
  default     = "dev"
}
