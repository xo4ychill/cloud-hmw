# Terraform Module: route_table

---

## 📌 Описание
Модуль инфраструктуры: **route_table**

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
| [yandex_vpc_route_table.route_table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_environment"></a> [environment](#input_environment) | Окружение — для лейблов ресурсов | `string` | `"dev"` | no |
| <a name="input_nat_instance_internal_ip"></a> [nat_instance_internal_ip](#input_nat_instance_internal_ip) | Внутренний IP NAT-инстанса (next hop для статического маршрута 0.0.0.0/0) | `string` | n/a | yes |
| <a name="input_network_id"></a> [network_id](#input_network_id) | ID VPC-сети (из модуля network) | `string` | n/a | yes |
| <a name="input_route_table_name"></a> [route_table_name](#input_route_table_name) | Имя route table | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output_id) | ID созданной route table — передаётся в модуль subnet (route_table_id) для private-подсети |
<!-- END_TF_DOCS -->
