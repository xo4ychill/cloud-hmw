# Object Storage в Yandex Cloud — S3-совместимый API, работает НЕ через обычный
# OAuth-токен , а через отдельную пару
# access_key/secret_key (как классический AWS S3) — поэтому здесь заводится
# отдельный сервисный аккаунт со статическим ключом ИМЕННО под доступ к бакету.
resource "yandex_iam_service_account" "storage_sa" {
  name        = var.service_account_name
  description = "Сервисный аккаунт для доступа к Object Storage (HW15.2)"
}

resource "yandex_resourcemanager_folder_iam_member" "storage_editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.storage_sa.id}"
}


# ======================================================================
# HW15.3 — «Безопасность в облачных провайдерах», Задание 1: шифрование бакета KMS-ключом
# ======================================================================
# Симметричный ключ для шифрования содержимого бакета (SSE-KMS).
#
# ⚠️ Про lifecycle.prevent_destroy: официальная документация Yandex Cloud
# настоятельно рекомендует добавлять prevent_destroy = true для KMS-ключей
# в продакшене — удаление ключа делает НЕВОССТАНОВИМЫМИ все данные,
# зашифрованные им. Здесь prevent_destroy СОЗНАТЕЛЬНО НЕ включён — это
# учебный стенд, который предполагается свободно поднимать и разрушать
# через terraform destroy; с prevent_destroy = true эта же команда
# отказалась бы удалять ключ, и потребовалось бы сначала вручную снять
# lifecycle-блок. Для реального прод-окружения — раскомментируйте блок ниже.
resource "yandex_kms_symmetric_key" "kms_key" {
  name               = var.kms_key_name
  description        = "Ключ шифрования содержимого бакета Object Storage (HW15.3)"
  default_algorithm  = var.kms_default_algorithm
  rotation_period    = var.kms_rotation_period

  # lifecycle {
  #   prevent_destroy = true
  # }
}

# Право на использование ключа выдаётся ТОМУ ЖЕ сервисному аккаунту, что уже
# работает с бакетом (storage_sa) — именно от его имени Object Storage
# фактически выполняет шифрование/расшифровку при обращении к объектам,
# не какого-то отдельного скрытого системного аккаунта. Выдаётся на уровне
# каталога (а не точечно на сам ключ через yandex_kms_symmetric_key_iam_binding) —
# это способ, прямо рекомендованный официальной документацией Yandex Cloud
# для управления доступом к KMS-ключам через Terraform.
resource "yandex_resourcemanager_folder_iam_member" "storage_kms_encrypter" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.storage_sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "storage_key" {
  service_account_id = yandex_iam_service_account.storage_sa.id
  description        = "Статический ключ для yandex_storage_bucket/yandex_storage_object"

  depends_on = [yandex_resourcemanager_folder_iam_member.storage_editor]
}

resource "yandex_storage_bucket" "sb" {
  bucket     = var.bucket_name
  access_key = yandex_iam_service_account_static_access_key.storage_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.storage_key.secret_key

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.kms_key.id
        sse_algorithm       = "aws:kms"
      }
    }
  }

  # Явная depends_on (сверх implicit-зависимости через kms_master_key_id):
  # включение шифрования на бакете может требовать уже действующего права
  # storage_kms_encrypter на момент СОЗДАНИЯ бакета, а не только на момент
  # загрузки объектов в него — та же гонка состояния, что уже была учтена
  # для storage_editor выше (см. depends_on у static_access_key).
  depends_on = [yandex_resourcemanager_folder_iam_member.storage_kms_encrypter]
}

# Публичный доступ выставлен НА УРОВНЕ ОБЪЕКТА (acl = "public-read"), а не на
# уровне всего бакета — по заданию нужно "сделать файл доступным из интернета",
# а не открыть листинг всего бакета целиком. Это сознательно более узкая,
# менее рискованная настройка, чем публичный бакет целиком.
resource "yandex_storage_object" "picture" {
  bucket     = yandex_storage_bucket.sb.bucket
  key        = var.object_key
  source     = var.source_file_path
  access_key = yandex_iam_service_account_static_access_key.storage_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.storage_key.secret_key
  acl        = "public-read"

  depends_on = [yandex_resourcemanager_folder_iam_member.storage_kms_encrypter]
}
