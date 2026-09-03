# Terraform Module: object_storage

---

## 📌 Описание
Модуль инфраструктуры: **object_storage**

---

## 📚 Документация
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.6.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement_yandex) | >= 0.120.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_yandex"></a> [yandex](#provider_yandex) | >= 0.120.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [yandex_iam_service_account.storage_sa](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_iam_service_account_static_access_key.storage_key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account_static_access_key) | resource |
| [yandex_kms_symmetric_key.kms_key](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kms_symmetric_key) | resource |
| [yandex_resourcemanager_folder_iam_member.storage_editor](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_resourcemanager_folder_iam_member.storage_kms_encrypter](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |
| [yandex_storage_bucket.sb](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_bucket) | resource |
| [yandex_storage_object.picture](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/storage_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_bucket_name"></a> [bucket_name](#input_bucket_name) | Имя бакета. ДОЛЖНО быть глобально уникальным во всём Yandex Object Storage (не только в вашем каталоге) — рекомендация задания: имя_студента-дата | `string` | n/a | yes |
| <a name="input_folder_id"></a> [folder_id](#input_folder_id) | ID каталога, в котором сервисному аккаунту выдаётся роль storage.editor | `string` | n/a | yes |
| <a name="input_kms_default_algorithm"></a> [kms_default_algorithm](#input_kms_default_algorithm) | Алгоритм шифрования новой версии ключа (при ротации). AES_128 — значение по умолчанию Yandex Cloud | `string` | `"AES_128"` | no |
| <a name="input_kms_key_name"></a> [kms_key_name](#input_kms_key_name) | Имя KMS-ключа для шифрования содержимого бакета | `string` | `"hw15-3-storage-key"` | no |
| <a name="input_kms_rotation_period"></a> [kms_rotation_period](#input_kms_rotation_period) | Период автоматической ротации ключа (в формате Go duration, напр. '8760h' = 1 год). Пустая строка — ротация отключена | `string` | `"8760h"` | no |
| <a name="input_object_key"></a> [object_key](#input_object_key) | Ключ (путь) объекта внутри бакета, например 'picture.png' | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service_account_name](#input_service_account_name) | Имя сервисного аккаунта для доступа к Object Storage | `string` | n/a | yes |
| <a name="input_source_file_path"></a> [source_file_path](#input_source_file_path) | Путь к локальному файлу, который нужно загрузить в бакет | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_bucket_name"></a> [bucket_name](#output_bucket_name) | n/a |
| <a name="output_kms_key_id"></a> [kms_key_id](#output_kms_key_id) | ID KMS-ключа, которым зашифровано содержимое бакета |
| <a name="output_public_url"></a> [public_url](#output_public_url) | Публичный (path-style) URL загруженного объекта — работает без дополнительной настройки DNS, в отличие от virtual-hosted style |
<!-- END_TF_DOCS -->
