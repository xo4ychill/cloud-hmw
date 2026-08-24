# Модуль vm — переиспользован из прошлого проекта (k8s-install/terraform/modules/vm),
# с двумя ОБОБЩЕНИЯМИ, необходимыми именно для этой задачи:
#
# 1. nat (публичный IP) — раньше было жёстко зашито "true" для любой ВМ.
#    Здесь это прямо нарушало бы условие задания: приватная ВМ должна иметь
#    ТОЛЬКО внутренний IP, без публичного. Вынесено в переменную var.assign_nat_ip.
#
# 2. cloud-init — раньше был ОБЯЗАТЕЛЕН (шаблон под kubeadm/containerd).
#    Здесь он не нужен вообще (это не k8s-кластер, ВМ используются просто для
#    проверки связности) — сделан опциональным через var.cloud_init_template
#    (null по умолчанию = metadata.user-data не передаётся совсем).
#
# Остальное — тот же принцип, что и раньше: for_each по карте var.instances
# (имя_ноды -> внутренний IP), а не count — тот же аргумент, что и в прошлом
# проекте (устойчивая идентификация по имени, а не по позиционному индексу).
resource "yandex_compute_instance" "vm" {
  for_each = var.instances

  name        = each.key
  # hostname гостевой ОС
  hostname    = lookup(var.hostnames, each.key, each.key)
  platform_id = var.platform_id
  zone        = var.default_zone
  allow_stopping_for_update = true

  resources {
    cores         = var.cores
    memory        = var.memory
    core_fraction = var.core_fraction
  }

  scheduling_policy {
    preemptible = var.preemptible
  }

  boot_disk {
    initialize_params {
      image_id = var.image_id
      size     = var.disk_size
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id          = var.subnet_id
    nat                = var.assign_nat_ip # false для private-ВМ — только внутренний IP, как требует задание
    ip_address         = each.value
    security_group_ids = var.security_group_ids
  }

  metadata = merge(
    { ssh-keys = "ubuntu:${var.ssh_public_key}" },
    var.cloud_init_template == null ? {} : {
      user-data = templatefile(var.cloud_init_template, var.cloud_init_vars)
    }
  )

  labels = {
    project     = var.project_label
    environment = var.environment_label
  }
}
