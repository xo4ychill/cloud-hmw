variable "instances" {
  description = "Карта имя_ноды => внутренний IP-адрес"
  type        = map(string)
}

variable "platform_id" {
  description = "Платформа Yandex Cloud"
  type        = string
  default     = "standard-v3"
}


variable "default_zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "hostnames" {
  description = "Карта имя_ноды => hostname внутри гостевой ОС (поле Yandex Cloud 'hostname', ОТДЕЛЬНОЕ от 'name' — имени инстанса, видимого в консоли/`yc compute instance list`). Если для конкретной ноды значение не задано — используется имя ноды (ключ instances) как есть"
  type        = map(string)
  default     = {}
}


variable "cores" {
  description = "Количество vCPU на ноду"
  type        = number
  default     = 2
}

variable "memory" {
  description = "ОЗУ (ГБ) на ноду"
  type        = number
  default     = 2
}

variable "disk_size" {
  description = "Размер загрузочного диска (ГБ)"
  type        = number
  default     = 20
}

variable "image_id" {
  description = "ID образа ОС"
  type        = string
}

variable "subnet_id" {
  description = "ID подсети (из модуля subnet)"
  type        = string
}

variable "security_group_ids" {
  description = "Список ID security group (из модуля security)"
  type        = list(string)
}

variable "assign_nat_ip" {
  description = "Присвоить ли публичный (NAT) IP. false — только внутренний IP (обязательно для private-ВМ по условию задания)"
  type        = bool
  default     = true
}

variable "ssh_public_key" {
  description = "Содержимое публичного SSH-ключа"
  type        = string
}

variable "cloud_init_template" {
  description = "Путь к шаблону cloud-init (.tpl). null (по умолчанию) — metadata.user-data не передаётся вообще"
  type        = string
  default     = null
}

variable "cloud_init_vars" {
  description = "Переменные, подставляемые в cloud_init_template (игнорируется, если cloud_init_template == null)"
  type        = map(any)
  default     = {}
}

variable "project_label" {
  description = "Значение лейбла project"
  type        = string
}

variable "environment_label" {
  description = "Значение лейбла environment"
  type        = string
}

variable "preemptible" {
  description = "Использовать прерываемую ВМ"
  type        = bool
  default     = true
}

variable "core_fraction" {
  description = "Гарантированную долю vCPU"
  type        = string
  default     = "20"
}