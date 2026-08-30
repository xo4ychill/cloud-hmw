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
