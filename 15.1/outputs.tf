output "nat_instance_external_ip" {
  description = "Публичный IP NAT-инстанса — для SSH"
  value       = values(module.nat_instance.external_ips)[0]
}

output "nat_instance_internal_ip" {
  description = "Внутренний IP NAT-инстанса (должен совпадать с var.nat_instance_ip)"
  value       = values(module.nat_instance.internal_ips)[0]
}

output "public_vm_external_ip" {
  description = "Публичный IP публичной тестовой ВМ — для SSH"
  value       = values(module.public_vm.external_ips)[0]
}

output "public_vm_internal_ip" {
  description = "Внутренний IP публичной тестовой ВМ"
  value       = values(module.public_vm.internal_ips)[0]
}

output "private_vm_internal_ip" {
  description = "Внутренний IP приватной тестовой ВМ (публичного IP у неё нет — заходить через public_vm)"
  value       = values(module.private_vm.internal_ips)[0]
}

output "ssh_hint_public" {
  description = "Подсказка для подключения к публичной ВМ"
  value       = "ssh ubuntu@${values(module.public_vm.external_ips)[0]}"
}

output "ssh_hint_private_via_public" {
  description = "Подсказка для подключения к приватной ВМ ЧЕРЕЗ публичную (jump host)"
  value       = "ssh -J ubuntu@${values(module.public_vm.external_ips)[0]} ubuntu@${values(module.private_vm.internal_ips)[0]}"
}
