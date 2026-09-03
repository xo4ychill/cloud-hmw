output "external_ip" {
  description = "Публичный IP сетевого балансировщика — по нему проверяется работоспособность (curl/браузер)"
  value       = tolist(tolist(yandex_lb_network_load_balancer.nlb.listener)[0].external_address_spec)[0].address
}
