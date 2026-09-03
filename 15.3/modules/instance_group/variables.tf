variable "lb_type" {
  description = "Тип балансировщика, для которого Instance Group создаёт target group: 'network' (NLB) или 'application' (ALB). Взаимоисключающе на уровне Yandex Cloud API — см. пояснение в main.tf"
  type        = string
  default     = "network"

  validation {
    condition     = contains(["network", "application"], var.lb_type)
    error_message = "lb_type должен быть 'network' или 'application'."
  }
}

variable "name" {
  type = string
}

variable "folder_id" {
  type = string
}

variable "service_account_id" {
  description = "ID сервисного аккаунта, от имени которого Instance Group управляет ВМ (не путать с сервисным аккаунтом Object Storage — нужен отдельный, с ролью editor на каталог)"
  type        = string
}

variable "platform_id" {
  type    = string
  default = "standard-v3"
}

variable "cores" {
  type    = number
  default = 2
}

variable "memory" {
  type    = number
  default = 2
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "image_id" {
  description = "image_id LAMP-шаблона (по заданию — fd827b91d99psvq5fjit)"
  type        = string
}

variable "network_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "default_zone" {
  type = string
}

variable "instance_count" {
  description = "Фиксированное количество ВМ в группе (по заданию — 3)"
  type        = number
  default     = 3
}

variable "ssh_public_key" {
  type = string
}

variable "webserver_init_template" {
  description = "Путь к шаблону user_data (bootstrap-скрипт стартовой веб-страницы)"
  type        = string
}

variable "picture_url" {
  description = "Публичный URL картинки из бакета — подставляется в стартовую веб-страницу"
  type        = string
}

variable "hostname_prefix" {
  description = "Префикс для имени каждой ВМ в группе (к нему будет добавлен индекс)"
  type        = string
  default     = "vm-"
}