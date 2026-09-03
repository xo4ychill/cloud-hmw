# Модуль subnet — одна подсеть внутри уже существующей сети. Вызывается ДВАЖДЫ
# из корневого main.tf: один раз для public (192.168.10.0/24), один раз для
# private (192.168.20.0/24). route_table_id — опциональный (нужен только
# private-подсети, чтобы направить исходящий трафик через NAT-инстанс;
# у public-подсети своя стандартная связность, отдельная route table не нужна).
resource "yandex_vpc_subnet" "vpc_subnet" {
  name           = var.subnet_name
  zone           = var.default_zone
  network_id     = var.network_id
  v4_cidr_blocks = var.v4_cidr_blocks
  route_table_id = var.route_table_id # null, если не передан — подсеть использует связность по умолчанию

  labels = {
    environment = var.environment
  }
}
