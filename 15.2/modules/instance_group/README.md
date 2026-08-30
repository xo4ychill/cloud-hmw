# Terraform Module: instance_group

---

## 📌 Описание
Модуль инфраструктуры: **instance_group**

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
| [yandex_compute_instance_group.ig](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cores"></a> [cores](#input_cores) | n/a | `number` | `2` | no |
| <a name="input_default_zone"></a> [default_zone](#input_default_zone) | n/a | `string` | n/a | yes |
| <a name="input_disk_size"></a> [disk_size](#input_disk_size) | n/a | `number` | `20` | no |
| <a name="input_folder_id"></a> [folder_id](#input_folder_id) | n/a | `string` | n/a | yes |
| <a name="input_image_id"></a> [image_id](#input_image_id) | image_id LAMP-шаблона (по заданию — fd827b91d99psvq5fjit) | `string` | n/a | yes |
| <a name="input_instance_count"></a> [instance_count](#input_instance_count) | Фиксированное количество ВМ в группе (по заданию — 3) | `number` | `3` | no |
| <a name="input_lb_type"></a> [lb_type](#input_lb_type) | Тип балансировщика, для которого Instance Group создаёт target group: 'network' (NLB) или 'application' (ALB). Взаимоисключающе на уровне Yandex Cloud API — см. пояснение в main.tf | `string` | `"network"` | no |
| <a name="input_memory"></a> [memory](#input_memory) | n/a | `number` | `2` | no |
| <a name="input_name"></a> [name](#input_name) | n/a | `string` | n/a | yes |
| <a name="input_network_id"></a> [network_id](#input_network_id) | n/a | `string` | n/a | yes |
| <a name="input_picture_url"></a> [picture_url](#input_picture_url) | Публичный URL картинки из бакета — подставляется в стартовую веб-страницу | `string` | n/a | yes |
| <a name="input_platform_id"></a> [platform_id](#input_platform_id) | n/a | `string` | `"standard-v3"` | no |
| <a name="input_security_group_ids"></a> [security_group_ids](#input_security_group_ids) | n/a | `list(string)` | n/a | yes |
| <a name="input_service_account_id"></a> [service_account_id](#input_service_account_id) | ID сервисного аккаунта, от имени которого Instance Group управляет ВМ (не путать с сервисным аккаунтом Object Storage — нужен отдельный, с ролью editor на каталог) | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh_public_key](#input_ssh_public_key) | n/a | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet_id](#input_subnet_id) | n/a | `string` | n/a | yes |
| <a name="input_webserver_init_template"></a> [webserver_init_template](#input_webserver_init_template) | Путь к шаблону user_data (bootstrap-скрипт стартовой веб-страницы) | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output_id) | n/a |
| <a name="output_target_group_id"></a> [target_group_id](#output_target_group_id) | ID target group, автоматически созданной блоком load_balancer/application_load_balancer — используется соответствующим балансировщиком |
<!-- END_TF_DOCS -->
