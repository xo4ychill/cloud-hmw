# Модуль security — переиспользован из прошлого проекта (k8s-install/terraform/
# modules/security), тот же принцип: широкое правило для трафика ВНУТРИ сети
# + явные точки входа снаружи (тут — только SSH и ICMP, никаких k8s-портов
# вроде NodePort/apiserver — они здесь просто не нужны, это не k8s-кластер).
resource "yandex_vpc_security_group" "sg" {
  name        = var.name
  description = var.description
  network_id  = var.network_id

  labels = {
    environment = var.environment
  }

  # --- Весь трафик внутри VPC (между public и private подсетями, включая NAT-инстанс) ---
  ingress {
    protocol       = "ANY"
    v4_cidr_blocks = var.internal_cidrs
    description    = "Весь трафик внутри VPC (public + private подсети)"
  }

  # --- SSH снаружи ---
  ingress {
    protocol       = "TCP"
    port           = 22
    v4_cidr_blocks = [var.allowed_ssh_cidr]
    description    = "SSH-доступ"
  }

  # --- ICMP снаружи (диагностика: ping до публичной ВМ/NAT-инстанса) ---
  ingress {
    protocol       = "ICMP"
    v4_cidr_blocks = [var.allowed_ssh_cidr]
    description    = "ping с админ-машины (диагностика)"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Весь исходящий трафик разрешён"
  }
}
