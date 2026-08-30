# Terraform Module: security

---

## 📌 Описание
Модуль инфраструктуры: **security**

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
| [yandex_vpc_security_group.sg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_allowed_ssh_cidr"></a> [allowed_ssh_cidr](#input_allowed_ssh_cidr) | CIDR, которому разрешён SSH/ICMP извне. В реальной инфраструктуре сузьте до своего IP/VPN | `string` | `"0.0.0.0/0"` | no |
| <a name="input_default_zone"></a> [default_zone](#input_default_zone) | Зона доступности | `string` | `"ru-central1-a"` | no |
| <a name="input_description"></a> [description](#input_description) | Описание security group | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input_environment) | Окружение — для лейблов ресурсов | `string` | `"dev"` | no |
| <a name="input_internal_cidrs"></a> [internal_cidrs](#input_internal_cidrs) | Список CIDR подсетей внутри VPC (public + private) — трафик между ними разрешён полностью | `list(string)` | n/a | yes |
| <a name="input_name"></a> [name](#input_name) | Имя security group | `string` | n/a | yes |
| <a name="input_network_id"></a> [network_id](#input_network_id) | ID VPC-сети (из модуля network) | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output_id) | ID созданной security group |
<!-- END_TF_DOCS -->
