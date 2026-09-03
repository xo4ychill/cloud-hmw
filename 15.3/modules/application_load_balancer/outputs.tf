output "external_ip" {
  description = "Публичный IP Application Load Balancer"
  value = tolist(
    tolist(
      tolist(
        tolist(yandex_alb_load_balancer.alb.listener)[0].endpoint
      )[0].address
    )[0].external_ipv4_address
  )[0].address
}
