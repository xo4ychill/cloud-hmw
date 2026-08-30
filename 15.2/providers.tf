# ======================================================================
# providers.tf — Настройка провайдера Yandex Cloud и удалённого бэкенда
# ======================================================================

terraform {
  # Минимальная версия Terraform (нужна для use_lockfile)
  required_version = ">= 1.6.0"

  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = ">= 0.120.0" # Актуальная версия провайдера
    }
  }
}

# ----- Провайдер Yandex Cloud -----
provider "yandex" {
  # Аутентификация через ключ сервисного аккаунта (JSON-файл)
  service_account_key_file = pathexpand(var.service_account_key_file)

  cloud_id  = var.cloud_id     # ID облака
  folder_id = var.folder_id    # ID каталога
  zone      = var.default_zone # Зона доступности по умолчанию
}
