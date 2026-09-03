# Terraform Module: application_load_balancer

---

## 📌 Описание
Модуль инфраструктуры: **application_load_balancer**

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
| [yandex_alb_backend_group.alb_bg](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/alb_backend_group) | resource |
| [yandex_alb_http_router.alb_router](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/alb_http_router) | resource |
| [yandex_alb_load_balancer.alb](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/alb_load_balancer) | resource |
| [yandex_alb_virtual_host.alb_vh](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/alb_virtual_host) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_default_zone"></a> [default_zone](#input_default_zone) | n/a | `string` | n/a | yes |
| <a name="input_healthcheck_interval"></a> [healthcheck_interval](#input_healthcheck_interval) | Интервал проверки здоровья | `string` | `"10s"` | no |
| <a name="input_healthcheck_timeout"></a> [healthcheck_timeout](#input_healthcheck_timeout) | Таймаут проверки здоровья | `string` | `"5s"` | no |
| <a name="input_name"></a> [name](#input_name) | n/a | `string` | n/a | yes |
| <a name="input_network_id"></a> [network_id](#input_network_id) | n/a | `string` | n/a | yes |
| <a name="input_security_group_ids"></a> [security_group_ids](#input_security_group_ids) | Security group для самого ресурса ALB (не для backend-ВМ — те получают security group отдельно, через модуль vm/instance_group). Нужны правила: порт 80 снаружи + порт 30080 от диапазонов 198.18.235.0/24 и 198.18.248.0/24 (health-check узлов ALB) — см. modules/security | `list(string)` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet_id](#input_subnet_id) | n/a | `string` | n/a | yes |
| <a name="input_target_group_id"></a> [target_group_id](#input_target_group_id) | ID target group из модуля instance_group (та же самая, что использует NLB) | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_external_ip"></a> [external_ip](#output_external_ip) | Публичный IP Application Load Balancer |
<!-- END_TF_DOCS -->
