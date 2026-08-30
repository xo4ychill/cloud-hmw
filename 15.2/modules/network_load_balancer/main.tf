resource "yandex_lb_network_load_balancer" "nlb" {
  name = var.name
  type = "external" # публичный IP для входящего трафика — балансировщик должен быть доступен из интернета

  listener {
    name = "http-listener"
    port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = var.target_group_id

    healthcheck {
      name = "http-healthcheck"

      http_options {
        port = 80
        path = "/"
      }
    }
  }
}
