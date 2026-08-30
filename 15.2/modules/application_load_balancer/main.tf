# Application Load Balancer переиспользует ТУ ЖЕ target_group_id, что и сетевой
# балансировщик (см. модуль instance_group — target group создаётся ОДИН раз
# блоком load_balancer внутри Instance Group и годится для обоих типов
# балансировщиков, NLB и ALB, — это общий механизм Yandex Cloud).
#
# ⚠️ ВАЖНО: ALB проверяет здоровье backend'ов СО СВОИХ СЛУЖЕБНЫХ IP-адресов
# См. добавленное правило в modules/security/main.tf.
resource "yandex_alb_backend_group" "alb" {
  name = "${var.name}-backend-group"

  http_backend {
    name             = "${var.name}-backend"
    port             = 80
    target_group_ids = [var.target_group_id]
    weight           = 1

    healthcheck {
      timeout             = var.healthcheck_timeout
      interval            = var.healthcheck_interval
      healthy_threshold   = 2
      unhealthy_threshold = 2

      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "alb" {
  name = "${var.name}-router"
}

resource "yandex_alb_virtual_host" "alb" {
  name           = "${var.name}-vhost"
  http_router_id = yandex_alb_http_router.alb.id

  route {
    name = "default-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.alb.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "alb" {
  name               = var.name
  network_id         = var.network_id
  security_group_ids = var.security_group_ids

  allocation_policy {
    location {
      zone_id   = var.default_zone
      subnet_id = var.subnet_id
    }
  }

  listener {
    name = "http-listener"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }
    http {
      handler {
        http_router_id = yandex_alb_http_router.alb.id
      }
    }
  }
}
