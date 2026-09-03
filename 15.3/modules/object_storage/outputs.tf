output "bucket_name" {
  value = yandex_storage_bucket.sb.bucket
}

output "public_url" {
  description = "Публичный (path-style) URL загруженного объекта — работает без дополнительной настройки DNS, в отличие от virtual-hosted style"
  value       = "https://storage.yandexcloud.net/${yandex_storage_bucket.sb.bucket}/${yandex_storage_object.picture.key}"
}

output "kms_key_id" {
  description = "ID KMS-ключа, которым зашифровано содержимое бакета"
  value       = yandex_kms_symmetric_key.kms_key.id
}
