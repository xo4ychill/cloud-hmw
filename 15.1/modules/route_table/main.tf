# Модуль route_table — таблица маршрутизации со статическим маршрутом,
# направляющим ВЕСЬ исходящий трафик (0.0.0.0/0) на внутренний IP NAT-инстанса.
# Применяется к private-подсети через её поле route_table_id (см. modules/subnet
# и корневой main.tf) — именно так private-подсеть "узнаёт", что для выхода
# в интернет нужно идти через NAT, а не напрямую (у private-подсети нет
# собственного публичного IP ни у одной из её ВМ).
resource "yandex_vpc_route_table" "route_table" {
  name       = var.route_table_name
  network_id = var.network_id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.nat_instance_internal_ip
  }

  labels = {
    environment = var.environment
  }
}
