# Модуль network — создаёт ТОЛЬКО пустую VPC-сеть, без подсетей.

resource "yandex_vpc_network" "vpc_network" {
  name = var.network_name

  labels = {
    environment = var.environment
  }
}
