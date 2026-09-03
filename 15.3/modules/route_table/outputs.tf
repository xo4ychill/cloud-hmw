output "id" {
  description = "ID созданной route table — передаётся в модуль subnet (route_table_id) для private-подсети"
  value       = yandex_vpc_route_table.route_table.id
}
