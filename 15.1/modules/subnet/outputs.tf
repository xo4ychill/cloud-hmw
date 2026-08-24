output "id" {
  description = "ID созданной подсети"
  value       = yandex_vpc_subnet.vpc_subnet.id
}

output "v4_cidr_blocks" {
  description = "CIDR-блоки подсети (проброшены наружу для удобства ссылки из route_table)"
  value       = yandex_vpc_subnet.vpc_subnet.v4_cidr_blocks
}
