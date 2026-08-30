output "id" {
  value = yandex_compute_instance_group.ig.id
}

output "target_group_id" {
  description = "ID target group, автоматически созданной блоком load_balancer/application_load_balancer — используется соответствующим балансировщиком"
  # Источник ЗАВИСИТ от var.lb_type — см. пояснение в main.tf про взаимоисключающие
  # блоки load_balancer/application_load_balancer.
  value = var.lb_type == "network" ? tolist(yandex_compute_instance_group.ig.load_balancer)[0].target_group_id : tolist(yandex_compute_instance_group.ig.application_load_balancer)[0].target_group_id
}
