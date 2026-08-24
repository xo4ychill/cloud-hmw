output "internal_ips" {
  description = "Карта имя_ноды => внутренний IP"
  value       = { for name, inst in yandex_compute_instance.vm : name => inst.network_interface.0.ip_address }
}

output "external_ips" {
  description = "Карта имя_ноды => публичный IP (пусто/null для ВМ с assign_nat_ip = false)"
  value       = { for name, inst in yandex_compute_instance.vm : name => inst.network_interface.0.nat_ip_address }
}
