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
