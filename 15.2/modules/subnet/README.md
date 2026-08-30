# Terraform Module: subnet

---

## 📌 Описание
Модуль инфраструктуры: **subnet**

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
| [yandex_vpc_subnet.vpc_subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_default_zone"></a> [default_zone](#input_default_zone) | Зона доступности | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input_environment) | Окружение — для лейблов ресурсов | `string` | `"dev"` | no |
| <a name="input_network_id"></a> [network_id](#input_network_id) | ID VPC-сети (из модуля network) | `string` | n/a | yes |
| <a name="input_route_table_id"></a> [route_table_id](#input_route_table_id) | ID кастомной route table для этой подсети. Оставьте null для связности по умолчанию (типично для public-подсети); задайте явно для private-подсети, чтобы направить исходящий трафик через NAT-инстанс | `string` | `null` | no |
| <a name="input_subnet_name"></a> [subnet_name](#input_subnet_name) | Имя подсети | `string` | n/a | yes |
| <a name="input_v4_cidr_blocks"></a> [v4_cidr_blocks](#input_v4_cidr_blocks) | Список CIDR-блоков подсети (IPv4) | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output_id) | ID созданной подсети |
| <a name="output_v4_cidr_blocks"></a> [v4_cidr_blocks](#output_v4_cidr_blocks) | CIDR-блоки подсети (проброшены наружу для удобства ссылки из route_table) |
<!-- END_TF_DOCS -->
