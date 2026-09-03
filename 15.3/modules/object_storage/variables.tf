variable "service_account_name" {
  description = "Имя сервисного аккаунта для доступа к Object Storage"
  type        = string
}

variable "folder_id" {
  description = "ID каталога, в котором сервисному аккаунту выдаётся роль storage.editor"
  type        = string
}

variable "bucket_name" {
  description = "Имя бакета. ДОЛЖНО быть глобально уникальным во всём Yandex Object Storage (не только в вашем каталоге) — рекомендация задания: имя_студента-дата"
  type        = string
}

variable "object_key" {
  description = "Ключ (путь) объекта внутри бакета, например 'picture.png'"
  type        = string
}

variable "source_file_path" {
  description = "Путь к локальному файлу, который нужно загрузить в бакет"
  type        = string
}

# ==================== HW15.3: KMS-шифрование ====================

variable "kms_key_name" {
  description = "Имя KMS-ключа для шифрования содержимого бакета"
  type        = string
  default     = "hw15-3-storage-key"
}

variable "kms_default_algorithm" {
  description = "Алгоритм шифрования новой версии ключа (при ротации). AES_128 — значение по умолчанию Yandex Cloud"
  type        = string
  default     = "AES_128"
}

variable "kms_rotation_period" {
  description = "Период автоматической ротации ключа (в формате Go duration, напр. '8760h' = 1 год). Пустая строка — ротация отключена"
  type        = string
  default     = "8760h"
}
