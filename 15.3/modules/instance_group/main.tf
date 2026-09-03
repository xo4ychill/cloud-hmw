# Instance Group фиксированного размера (scale_policy.fixed_scale) — по заданию
# "группу ВМ ... фиксированного размера", не автомасштабируемая.
resource "yandex_compute_instance_group" "ig" {
  name               = var.name
  folder_id          = var.folder_id
  service_account_id = var.service_account_id

  instance_template {
    name        = "${var.hostname_prefix}{instance.index}"
    platform_id = var.platform_id

    resources {
      cores  = var.cores
      memory = var.memory
    }

    boot_disk {
      initialize_params {
        image_id = var.image_id # LAMP-образ (fd827b91d99psvq5fjit по заданию)
        size     = var.disk_size
      }
    }

    network_interface {
      network_id         = var.network_id
      subnet_ids         = [var.subnet_id]
      security_group_ids = var.security_group_ids
      nat                = false
    }

    metadata = {
      ssh-keys = "ubuntu:${var.ssh_public_key}"
      hostname = "${var.hostname_prefix}{instance.index}"
      user-data = templatefile(var.webserver_init_template, {
        picture_url = var.picture_url
      })
    }
  }

  scale_policy {
    fixed_scale {
      size = var.instance_count
    }
  }

  allocation_policy {
    zones = [var.default_zone]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }

  # Health check
  # http-проверка на 80-й порт корня "/"
  health_check {
    interval            = 5
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2

    http_options {
      port = 80
      path = "/"
    }
  }

  # ВАЖНО: Yandex Cloud НЕ позволяет одной Instance Group быть одновременно
  # источником target group и для NLB, и для ALB — это жёсткое ограничение
  # платформы (см. официальную документацию). Терраформ-блоки для этого
  # тоже РАЗНЫЕ: "load_balancer" — под NLB, "application_load_balancer" —
  # под ALB, взаимоисключающие. Поэтому модуль параметризован var.lb_type,
  # и в main.tf вызывается ДВАЖДЫ — один раз с lb_type="network" (NLB), 
  # другой раз с lb_type="application" (ALB) —
  dynamic "load_balancer" {
    for_each = var.lb_type == "network" ? [1] : []
    content {
      target_group_name = "${var.name}-tg"
    }
  }

  dynamic "application_load_balancer" {
    for_each = var.lb_type == "application" ? [1] : []
    content {
      target_group_name = "${var.name}-tg"
    }
  }
}