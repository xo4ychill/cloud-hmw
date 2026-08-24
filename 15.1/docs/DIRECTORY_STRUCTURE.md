# 📦 Terraform Infrastructure

---

## 📚 Автоматически сгенерированная документация

---

## 🌳 Структура проекта

```
.
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
└── modules/
    ├── network/
    ├── subnet/
    ├── route_table/
    ├── security/
    └── vm/
```

---

## 📘 Манифесты

| Source | Description |
|------|----------|
| [`main.tf`](../main.tf)| Точка входа: объединяет все модули |
| [`providers.tf`](../providers.tf) | Настройка провайдеров и backend |
| [`variables.tf`](../variables.tf) | Входные переменные |
| [`terraform.tfvars`](../terraform.tfvars.example) | Значения переменных |
| [`output.tf`](../outputs.tf) | Выходные значения |
| [`modules/`](../modules) | Каталог всех Terraform модулей |


---

## 📖 Документация Terraform

<!-- BEGIN_TF_DOCS -->
## Требования

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.6.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement_yandex) | >= 0.120.0 |

## Провайдеры

| Name | Version |
| ---- | ------- |
| <a name="provider_yandex"></a> [yandex](#provider_yandex) | 0.222.0 |

### Описание Модулей

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network"></a>  [ network](../modules/network/README.md) | ./modules/network | n/a |
| <a name="module_route_table"></a> [route_table](../modules/route_table/README.md) | ./modules/route_table | n/a |
| <a name="module_security"></a> [security](../modules/security/README.md) | ./modules/security | n/a |
| <a name="module_subnet"></a> [subnet](../modules/subnet/README.md) | ./modules/subnet | n/a |
| <a name="module_vm"></a> [vm](../modules/vm/README.md) | ./modules/vm | n/a |



## Вводные данные

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allowed_ssh_cidr"></a> [allowed_ssh_cidr](#input_allowed_ssh_cidr) | CIDR, которому разрешён SSH/ICMP извне. В реальной инфраструктуре сузьте до своего IP/VPN | `string` | `"0.0.0.0/0"` | no |
| <a name="input_cloud_id"></a> [cloud_id](#input_cloud_id) | ID облака (yc config list) | `string` | n/a | yes |
| <a name="input_core_fraction"></a> [core_fraction](#input_core_fraction) | Гарантированная доля vCPU | `string` | `"20"` | no |
| <a name="input_default_zone"></a> [default_zone](#input_default_zone) | Зона доступности | `string` | `"ru-central1-a"` | no |
| <a name="input_environment"></a> [environment](#input_environment) | Окружение — для лейблов ресурсов | `string` | `"dev"` | no |
| <a name="input_folder_id"></a> [folder_id](#input_folder_id) | ID каталога (yc config list) | `string` | n/a | yes |
| <a name="input_nat_instance_image_id"></a> [nat_instance_image_id](#input_nat_instance_image_id) | image_id NAT-инстанса (готовый образ Yandex Cloud с настроенным NAT/forwarding) | `string` | `"fd80mrhj8fl2oe87o4e1"` | no |
| <a name="input_nat_instance_ip"></a> [nat_instance_ip](#input_nat_instance_ip) | Внутренний IP NAT-инстанса в public-подсети (по заданию — 192.168.10.254) | `string` | `"192.168.10.254"` | no |
| <a name="input_network_name"></a> [network_name](#input_network_name) | Имя VPC-сети | `string` | `"hw15-network"` | no |
| <a name="input_preemptible"></a> [preemptible](#input_preemptible) | Использовать прерываемую ВМ | `bool` | `true` | no |
| <a name="input_private_subnet_cidr"></a> [private_subnet_cidr](#input_private_subnet_cidr) | CIDR private-подсети (по заданию — 192.168.20.0/24) | `string` | `"192.168.20.0/24"` | no |
| <a name="input_private_vm_ip"></a> [private_vm_ip](#input_private_vm_ip) | Внутренний IP приватной тестовой ВМ (в пределах private_subnet_cidr) | `string` | `"192.168.20.10"` | no |
| <a name="input_public_subnet_cidr"></a> [public_subnet_cidr](#input_public_subnet_cidr) | CIDR public-подсети (по заданию — 192.168.10.0/24) | `string` | `"192.168.10.0/24"` | no |
| <a name="input_public_vm_ip"></a> [public_vm_ip](#input_public_vm_ip) | Внутренний IP публичной тестовой ВМ (в пределах public_subnet_cidr, отличный от nat_instance_ip) | `string` | `"192.168.10.10"` | no |
| <a name="input_service_account_key_file"></a> [service_account_key_file](#input_service_account_key_file) | Путь к файлу ключа сервисного аккаунта (JSON) для Terraform | `string` | n/a | yes |
| <a name="input_ssh_public_key_path"></a> [ssh_public_key_path](#input_ssh_public_key_path) | Путь к публичному SSH-ключу для доступа на ВМ | `string` | `"~/.ssh/id_ed25519.pub"` | no |
| <a name="input_vm_image_family"></a> [vm_image_family](#input_vm_image_family) | family обычного образа ОС для public/private тестовых ВМ (не NAT-инстанс) | `string` | `"ubuntu-2004-lts"` | no |

## Вывод данных

| Name | Description |
| ---- | ----------- |
| <a name="output_nat_instance_external_ip"></a> [nat_instance_external_ip](#output_nat_instance_external_ip) | Публичный IP NAT-инстанса — для SSH |
| <a name="output_nat_instance_internal_ip"></a> [nat_instance_internal_ip](#output_nat_instance_internal_ip) | Внутренний IP NAT-инстанса (должен совпадать с var.nat_instance_ip) |
| <a name="output_private_vm_internal_ip"></a> [private_vm_internal_ip](#output_private_vm_internal_ip) | Внутренний IP приватной тестовой ВМ (публичного IP у неё нет — заходить через public_vm) |
| <a name="output_public_vm_external_ip"></a> [public_vm_external_ip](#output_public_vm_external_ip) | Публичный IP публичной тестовой ВМ — для SSH |
| <a name="output_public_vm_internal_ip"></a> [public_vm_internal_ip](#output_public_vm_internal_ip) | Внутренний IP публичной тестовой ВМ |
| <a name="output_ssh_hint_private_via_public"></a> [ssh_hint_private_via_public](#output_ssh_hint_private_via_public) | Подсказка для подключения к приватной ВМ ЧЕРЕЗ публичную (jump host) |
| <a name="output_ssh_hint_public"></a> [ssh_hint_public](#output_ssh_hint_public) | Подсказка для подключения к публичной ВМ |
<!-- END_TF_DOCS -->
