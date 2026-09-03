# Модуль security
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

  # --- HTTP через NLB/ALB ---
  ingress {
    protocol       = "TCP"
    port           = 80
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "HTTP через балансировщик (HW15.2)"
  }

  # --- Health-check УЗЛОВ ALB инфраструктурой Yandex Cloud ---
  ingress {
    protocol          = "TCP"
    port              = 30080
    predefined_target = "loadbalancer_healthchecks"
    description       = "Health-check узлов ALB инфраструктурой Yandex Cloud (HW15.2)"
  }

  egress {
    protocol       = "ANY"
    v4_cidr_blocks = ["0.0.0.0/0"]
    description    = "Весь исходящий трафик разрешён"
  }
}
