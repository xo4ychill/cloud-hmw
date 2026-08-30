variable "service_account_key_file" {
  description = "Путь к файлу ключа сервисного аккаунта (JSON) для Terraform"
  type        = string
  sensitive   = true
  validation {
    condition     = endswith(var.service_account_key_file, ".json")
    error_message = "Файл ключа должен иметь расширение .json"
  }
}

variable "cloud_id" {
  description = "ID облака (yc config list)"
  type        = string
}

variable "folder_id" {
  description = "ID каталога (yc config list)"
  type        = string
}

variable "default_zone" {
  description = "Зона доступности"
  type        = string
  default     = "ru-central1-a"
}

variable "environment" {
  description = "Окружение — для лейблов ресурсов"
  type        = string
  default     = "dev"
}

variable "network_name" {
  description = "Имя VPC-сети"
  type        = string
  default     = "hw15-network"
}

variable "public_subnet_cidr" {
  description = "CIDR public-подсети (по заданию — 192.168.10.0/24)"
  type        = string
  default     = "192.168.10.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR private-подсети (по заданию — 192.168.20.0/24)"
  type        = string
  default     = "192.168.20.0/24"
}

variable "nat_instance_ip" {
  description = "Внутренний IP NAT-инстанса в public-подсети (по заданию — 192.168.10.254)"
  type        = string
  default     = "192.168.10.254"
}

variable "nat_instance_image_id" {
  description = "image_id NAT-инстанса (готовый образ Yandex Cloud с настроенным NAT/forwarding — задан явно в задании)"
  type        = string
  default     = "fd80mrhj8fl2oe87o4e1"
}

variable "vm_image_family" {
  description = "family обычного образа ОС для public/private тестовых ВМ (не NAT-инстанс)"
  type        = string
  default     = "ubuntu-2004-lts"
}

variable "public_vm_ip" {
  description = "Внутренний IP публичной тестовой ВМ (в пределах public_subnet_cidr, отличный от nat_instance_ip)"
  type        = string
  default     = "192.168.10.10"
}

variable "private_vm_ip" {
  description = "Внутренний IP приватной тестовой ВМ (в пределах private_subnet_cidr)"
  type        = string
  default     = "192.168.20.10"
}

variable "allowed_ssh_cidr" {
  description = "CIDR, которому разрешён SSH/ICMP извне. В реальной инфраструктуре сузьте до своего IP/VPN"
  type        = string
  default     = "0.0.0.0/0"
}

variable "ssh_public_key_path" {
  description = "Путь к публичному SSH-ключу для доступа на ВМ"
  type        = string
  default     = "~/.ssh/id_ed25519.pub"
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

# ==================== HW15.2: Object Storage + Instance Group + LB ====================

variable "bucket_name_prefix" {
  description = "Префикс имени бакета Object Storage — к нему добавляется случайный суффикс (random_id), т.к. имена бакетов уникальны ГЛОБАЛЬНО во всём Yandex Object Storage, а не только в вашем каталоге. Рекомендация задания — имя_студента-дата; такой префикс и стоит сюда подставить"
  type        = string
  default     = "hw15-2-lb-demo"
}

variable "picture_object_key" {
  description = "Ключ (имя файла) картинки внутри бакета"
  type        = string
  default     = "picture.png"
}

variable "picture_source_path" {
  description = "Путь к локальному файлу картинки для загрузки в бакет"
  type        = string
  default     = "./assets/picture.png"
}

variable "webserver_init_template_path" {
  description = "Путь к шаблону user_data стартовой веб-страницы"
  type        = string
  default     = "./templates/webserver-init.sh.tpl"
}

variable "lamp_image_id" {
  description = "image_id LAMP-шаблона (по заданию — fd827b91d99psvq5fjit)"
  type        = string
  default     = "fd827b91d99psvq5fjit"
}

variable "instance_group_size" {
  description = "Фиксированное количество ВМ в Instance Group (по заданию — 3)"
  type        = number
  default     = 3
}


variable "alb_instance_group_size" {
  description = "Количество инстансов в группе ALB"
  type        = number
  default     = 2
}