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

resource "yandex_iam_service_account_static_access_key" "storage_key" {
  service_account_id = yandex_iam_service_account.storage_sa.id
  description        = "Статический ключ для yandex_storage_bucket/yandex_storage_object"

  depends_on = [yandex_resourcemanager_folder_iam_member.storage_editor]
}

resource "yandex_storage_bucket" "sb" {
  bucket     = var.bucket_name
  access_key = yandex_iam_service_account_static_access_key.storage_key.access_key
  secret_key = yandex_iam_service_account_static_access_key.storage_key.secret_key
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
}
