# Terraform Module: vm

---

## 📌 Описание
Модуль инфраструктуры: **vm**

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
| [yandex_compute_instance.vm](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_assign_nat_ip"></a> [assign_nat_ip](#input_assign_nat_ip) | Присвоить ли публичный (NAT) IP. false — только внутренний IP (обязательно для private-ВМ по условию задания) | `bool` | `true` | no |
| <a name="input_cloud_init_template"></a> [cloud_init_template](#input_cloud_init_template) | Путь к шаблону cloud-init (.tpl). null (по умолчанию) — metadata.user-data не передаётся вообще | `string` | `null` | no |
| <a name="input_cloud_init_vars"></a> [cloud_init_vars](#input_cloud_init_vars) | Переменные, подставляемые в cloud_init_template (игнорируется, если cloud_init_template == null) | `map(any)` | `{}` | no |
| <a name="input_core_fraction"></a> [core_fraction](#input_core_fraction) | Гарантированную долю vCPU | `string` | `"20"` | no |
| <a name="input_cores"></a> [cores](#input_cores) | Количество vCPU на ноду | `number` | `2` | no |
| <a name="input_default_zone"></a> [default_zone](#input_default_zone) | Зона доступности | `string` | `"ru-central1-a"` | no |
| <a name="input_disk_size"></a> [disk_size](#input_disk_size) | Размер загрузочного диска (ГБ) | `number` | `15` | no |
| <a name="input_environment_label"></a> [environment_label](#input_environment_label) | Значение лейбла environment | `string` | n/a | yes |
| <a name="input_hostnames"></a> [hostnames](#input_hostnames) | Карта имя_ноды => hostname внутри гостевой ОС (поле Yandex Cloud 'hostname', ОТДЕЛЬНОЕ от 'name' — имени инстанса, видимого в консоли/`yc compute instance list`). Если для конкретной ноды значение не задано — используется имя ноды (ключ instances) как есть | `map(string)` | `{}` | no |
| <a name="input_image_id"></a> [image_id](#input_image_id) | ID образа ОС | `string` | n/a | yes |
| <a name="input_instances"></a> [instances](#input_instances) | Карта имя_ноды => внутренний IP-адрес | `map(string)` | n/a | yes |
| <a name="input_memory"></a> [memory](#input_memory) | ОЗУ (ГБ) на ноду | `number` | `1` | no |
| <a name="input_platform_id"></a> [platform_id](#input_platform_id) | Платформа Yandex Cloud | `string` | `"standard-v3"` | no |
| <a name="input_preemptible"></a> [preemptible](#input_preemptible) | Использовать прерываемую ВМ | `bool` | `true` | no |
| <a name="input_project_label"></a> [project_label](#input_project_label) | Значение лейбла project | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security_group_ids](#input_security_group_ids) | Список ID security group (из модуля security) | `list(string)` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh_public_key](#input_ssh_public_key) | Содержимое публичного SSH-ключа | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet_id](#input_subnet_id) | ID подсети (из модуля subnet) | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_external_ips"></a> [external_ips](#output_external_ips) | Карта имя_ноды => публичный IP (пусто/null для ВМ с assign_nat_ip = false) |
| <a name="output_internal_ips"></a> [internal_ips](#output_internal_ips) | Карта имя_ноды => внутренний IP |
<!-- END_TF_DOCS -->
