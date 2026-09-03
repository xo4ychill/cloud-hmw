# Terraform Module: network_load_balancer

---

## 📌 Описание
Модуль инфраструктуры: **network_load_balancer**

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
| [yandex_lb_network_load_balancer.nlb](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_name"></a> [name](#input_name) | n/a | `string` | n/a | yes |
| <a name="input_target_group_id"></a> [target_group_id](#input_target_group_id) | ID target group из модуля instance_group | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_external_ip"></a> [external_ip](#output_external_ip) | Публичный IP сетевого балансировщика — по нему проверяется работоспособность (curl/браузер) |
<!-- END_TF_DOCS -->
