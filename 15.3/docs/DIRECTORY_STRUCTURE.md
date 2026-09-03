# 📦 Terraform Infrastructure

---

## 📚 Автоматически сгенерированная документация

---

## 🌳 Структура проекта

```
.
├── main.tf                            # оркестрация: network -> public subnet -> NAT -> route table -> private subnet -> security -> VM'ы (дополнен) блок HW15.2 в конце файла
├── providers.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.exampl
├── modules/
│   ├── network/            # пустая VPC-сеть
│   ├── subnet/             # одна подсеть (вызывается дважды: public, private)
│   ├── route_table/        # статический маршрут 0.0.0.0/0 -> NAT-инстанс
│   ├── security/           # SSH + ICMP снаружи, всё — внутри VPC
│   ├── vm/                 # универсальная ВМ (публичный IP и cloud-init — опциональны)
│   ├── object_storage/                   # сервисный аккаунт + статический ключ + бакет + объект (публичный)
│   │   ├── main.tf                       # (дополнен) yandex_kms_symmetric_key + право на ключ + server_side_encryption_configuration на бакете
│   │   ├── variables.tf                  # (дополнен) kms_key_name / kms_default_algorithm / kms_rotation_period
│   │   └── outputs.tf                    # (дополнен) kms_key_id
│   ├── instance_group/                   # Instance Group (LAMP, фиксированный размер, health check)
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── network_load_balancer/            # NLB, подключён к target group Instance Group
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── application_load_balancer/        # ALB
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── templates/
│   └── webserver-init.sh.tpl             # user_data: стартовая страница со ссылкой на картинку
└── assets/
    └── picture.png                       # картинка для загрузки в бакет
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
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.6.0 |
| <a name="requirement_yandex"></a> [yandex](#requirement_yandex) | >= 0.120.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_random"></a> [random](#provider_random) | 3.9.0 |
| <a name="provider_yandex"></a> [yandex](#provider_yandex) | 0.224.0 |

## Resources

| Name | Type |
| ---- | ---- |
| [random_id.bucket_suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [yandex_iam_service_account.instance_group_sa](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/iam_service_account) | resource |
| [yandex_resourcemanager_folder_iam_member.instance_group_editor](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/resourcemanager_folder_iam_member) | resource |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="application_load_balancer"></a>  [ application_load_balancer](../modules/application_load_balancer/README.md) | ./modules/application_load_balancer | n/a |
| <a name="instance_group"></a>  [ instance_group](../modules/instance_group/README.md) | ./modules/instance_group | n/a |
| <a name="module_network"></a>  [ network](../modules/network/README.md) | ./modules/network | n/a |
| <a name="network_load_balancer"></a>  [ network_load_balancer](../modules/network_load_balancer/README.md) | ./modules/network_load_balancer | n/a |
| <a name="object_storage"></a>  [ object_storage](../modules/object_storage/README.md) | ./modules/object_storage | n/a |
| <a name="module_route_table"></a> [route_table](../modules/route_table/README.md) | ./modules/route_table | n/a |
| <a name="module_security"></a> [security](../modules/security/README.md) | ./modules/security | n/a |
| <a name="module_subnet"></a> [subnet](../modules/subnet/README.md) | ./modules/subnet | n/a |
| <a name="module_vm"></a> [vm](../modules/vm/README.md) | ./modules/vm | n/a |


## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_alb_instance_group_size"></a> [alb_instance_group_size](#input_alb_instance_group_size) | Количество инстансов в группе ALB | `number` | `2` | no |
| <a name="input_allowed_ssh_cidr"></a> [allowed_ssh_cidr](#input_allowed_ssh_cidr) | CIDR, которому разрешён SSH/ICMP извне. В реальной инфраструктуре сузьте до своего IP/VPN | `string` | `"0.0.0.0/0"` | no |
| <a name="input_bucket_name_prefix"></a> [bucket_name_prefix](#input_bucket_name_prefix) | Префикс имени бакета Object Storage — к нему добавляется случайный суффикс (random_id), т.к. имена бакетов уникальны ГЛОБАЛЬНО во всём Yandex Object Storage, а не только в вашем каталоге. Рекомендация задания — имя_студента-дата; такой префикс и стоит сюда подставить | `string` | `"hw15-2-lb-demo"` | no |
| <a name="input_cloud_id"></a> [cloud_id](#input_cloud_id) | ID облака (yc config list) | `string` | n/a | yes |
| <a name="input_core_fraction"></a> [core_fraction](#input_core_fraction) | Гарантированную долю vCPU | `string` | `"20"` | no |
| <a name="input_default_zone"></a> [default_zone](#input_default_zone) | Зона доступности | `string` | `"ru-central1-a"` | no |
| <a name="input_environment"></a> [environment](#input_environment) | Окружение — для лейблов ресурсов | `string` | `"dev"` | no |
| <a name="input_folder_id"></a> [folder_id](#input_folder_id) | ID каталога (yc config list) | `string` | n/a | yes |
| <a name="input_instance_group_size"></a> [instance_group_size](#input_instance_group_size) | Фиксированное количество ВМ в Instance Group (по заданию — 3) | `number` | `3` | no |
| <a name="input_lamp_image_id"></a> [lamp_image_id](#input_lamp_image_id) | image_id LAMP-шаблона (по заданию — fd827b91d99psvq5fjit) | `string` | `"fd827b91d99psvq5fjit"` | no |
| <a name="input_nat_instance_image_id"></a> [nat_instance_image_id](#input_nat_instance_image_id) | image_id NAT-инстанса (готовый образ Yandex Cloud с настроенным NAT/forwarding — задан явно в задании) | `string` | `"fd80mrhj8fl2oe87o4e1"` | no |
| <a name="input_nat_instance_ip"></a> [nat_instance_ip](#input_nat_instance_ip) | Внутренний IP NAT-инстанса в public-подсети (по заданию — 192.168.10.254) | `string` | `"192.168.10.254"` | no |
| <a name="input_network_name"></a> [network_name](#input_network_name) | Имя VPC-сети | `string` | `"hw15-network"` | no |
| <a name="input_picture_object_key"></a> [picture_object_key](#input_picture_object_key) | Ключ (имя файла) картинки внутри бакета | `string` | `"picture.png"` | no |
| <a name="input_picture_source_path"></a> [picture_source_path](#input_picture_source_path) | Путь к локальному файлу картинки для загрузки в бакет | `string` | `"./assets/picture.png"` | no |
| <a name="input_preemptible"></a> [preemptible](#input_preemptible) | Использовать прерываемую ВМ | `bool` | `true` | no |
| <a name="input_private_subnet_cidr"></a> [private_subnet_cidr](#input_private_subnet_cidr) | CIDR private-подсети (по заданию — 192.168.20.0/24) | `string` | `"192.168.20.0/24"` | no |
| <a name="input_private_vm_ip"></a> [private_vm_ip](#input_private_vm_ip) | Внутренний IP приватной тестовой ВМ (в пределах private_subnet_cidr) | `string` | `"192.168.20.10"` | no |
| <a name="input_public_subnet_cidr"></a> [public_subnet_cidr](#input_public_subnet_cidr) | CIDR public-подсети (по заданию — 192.168.10.0/24) | `string` | `"192.168.10.0/24"` | no |
| <a name="input_public_vm_ip"></a> [public_vm_ip](#input_public_vm_ip) | Внутренний IP публичной тестовой ВМ (в пределах public_subnet_cidr, отличный от nat_instance_ip) | `string` | `"192.168.10.10"` | no |
| <a name="input_service_account_key_file"></a> [service_account_key_file](#input_service_account_key_file) | Путь к файлу ключа сервисного аккаунта (JSON) для Terraform | `string` | n/a | yes |
| <a name="input_ssh_public_key_path"></a> [ssh_public_key_path](#input_ssh_public_key_path) | Путь к публичному SSH-ключу для доступа на ВМ | `string` | `"~/.ssh/id_ed25519.pub"` | no |
| <a name="input_vm_image_family"></a> [vm_image_family](#input_vm_image_family) | family обычного образа ОС для public/private тестовых ВМ (не NAT-инстанс) | `string` | `"ubuntu-2004-lts"` | no |
| <a name="input_webserver_init_template_path"></a> [webserver_init_template_path](#input_webserver_init_template_path) | Путь к шаблону user_data стартовой веб-страницы | `string` | `"./templates/webserver-init.sh.tpl"` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_application_load_balancer_ip"></a> [application_load_balancer_ip](#output_application_load_balancer_ip) | Публичный IP Application Load Balancer |
| <a name="output_bucket_picture_url"></a> [bucket_picture_url](#output_bucket_picture_url) | Публичный URL картинки в Object Storage |
| <a name="output_kms_key_id"></a> [kms_key_id](#output_kms_key_id) | ID KMS-ключа, которым зашифровано содержимое бакета — проверить: yc kms symmetric-key get <id> |
| <a name="output_nat_instance_external_ip"></a> [nat_instance_external_ip](#output_nat_instance_external_ip) | Публичный IP NAT-инстанса — для SSH |
| <a name="output_nat_instance_internal_ip"></a> [nat_instance_internal_ip](#output_nat_instance_internal_ip) | Внутренний IP NAT-инстанса (должен совпадать с var.nat_instance_ip) |
| <a name="output_network_load_balancer_ip"></a> [network_load_balancer_ip](#output_network_load_balancer_ip) | Публичный IP сетевого балансировщика — открыть в браузере/curl для проверки |
| <a name="output_private_vm_internal_ip"></a> [private_vm_internal_ip](#output_private_vm_internal_ip) | Внутренний IP приватной тестовой ВМ (публичного IP у неё нет — заходить через public_vm) |
| <a name="output_public_vm_external_ip"></a> [public_vm_external_ip](#output_public_vm_external_ip) | Публичный IP публичной тестовой ВМ — для SSH |
| <a name="output_public_vm_internal_ip"></a> [public_vm_internal_ip](#output_public_vm_internal_ip) | Внутренний IP публичной тестовой ВМ |
| <a name="output_ssh_hint_private_via_public"></a> [ssh_hint_private_via_public](#output_ssh_hint_private_via_public) | Подсказка для подключения к приватной ВМ ЧЕРЕЗ публичную (jump host) |
| <a name="output_ssh_hint_public"></a> [ssh_hint_public](#output_ssh_hint_public) | Подсказка для подключения к публичной ВМ |
<!-- END_TF_DOCS -->
