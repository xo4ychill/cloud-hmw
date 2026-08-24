# ======================================================================
# main.tf — Задание 1 (Yandex Cloud): VPC с public/private подсетями,
# NAT-инстанс, приватная связность через route table.
# ======================================================================
# Порядок вызова модулей отражает реальную цепочку
# зависимостей (Terraform построил бы её сам по ссылкам между модулями,
# но здесь она явная и линейная, поэтому и файл читается сверху вниз как
# пошаговая инструкция):
#   network -> public subnet -> NAT-инстанс (получает IP в public subnet)
#   -> route table (маршрут на IP NAT-инстанса) -> private subnet
#   (получает эту route table) -> security group -> public VM, private VM

# ----- Провайдер Yandex Cloud -----
provider "yandex" {
  # Аутентификация через ключ сервисного аккаунта (JSON-файл)
  service_account_key_file = pathexpand(var.service_account_key_file)

  cloud_id  = var.cloud_id     # ID облака
  folder_id = var.folder_id    # ID каталога
  zone      = var.default_zone # Зона доступности по умолчанию
}

# ==================== Сеть ====================
module "network" {
  source = "./modules/network"

  network_name = var.network_name
  environment  = var.environment
}

# ==================== Public-подсеть ====================
module "public_subnet" {
  source = "./modules/subnet"

  subnet_name    = "public"
  default_zone   = var.default_zone
  network_id     = module.network.id
  v4_cidr_blocks = [var.public_subnet_cidr]
  environment    = var.environment
  # route_table_id не передаём — у public-подсети связность по умолчанию
}

# ==================== Образ ОС для обычных (не-NAT) ВМ ====================
data "yandex_compute_image" "ubuntu" {
  family    = var.vm_image_family
  folder_id = "standard-images"
}

# ==================== NAT-инстанс ====================
# Готовый образ Yandex Cloud (fd80mrhj8fl2oe87o4e1) с уже настроенным
# forwarding/MASQUERADE
module "nat_instance" {
  source = "./modules/vm"

  instances = {
    "nat-instance" = var.nat_instance_ip
  }
  hostnames = {
    "nat-instance" = "nat-hw15-net"
  }
  project_label     = "hw15-networking"
  environment_label = var.environment

  default_zone = var.default_zone
  # готовый NAT-образ
  image_id = var.nat_instance_image_id

  subnet_id          = module.public_subnet.id
  security_group_ids = [module.security.id]
  assign_nat_ip      = true

  ssh_public_key = file(var.ssh_public_key_path)
}

# ==================== Route table для private-подсети ====================
module "private_route_table" {
  source = "./modules/route_table"

  route_table_name         = "private-rt"
  network_id               = module.network.id
  nat_instance_internal_ip = var.nat_instance_ip
  environment              = var.environment
}

# ==================== Private-подсеть ====================
module "private_subnet" {
  source = "./modules/subnet"

  subnet_name    = "private"
  default_zone   = var.default_zone
  network_id     = module.network.id
  v4_cidr_blocks = [var.private_subnet_cidr]
  route_table_id = module.private_route_table.id # ключевая строка: весь исходящий трафик -> NAT-инстанс
  environment    = var.environment
}

# ==================== Security Group ====================
module "security" {
  source = "./modules/security"

  name             = "${var.network_name}-sg"
  description      = "SSH + ICMP снаружи, весь трафик внутри VPC"
  network_id       = module.network.id
  environment      = var.environment
  allowed_ssh_cidr = var.allowed_ssh_cidr
  internal_cidrs   = [var.public_subnet_cidr, var.private_subnet_cidr]
}

# ==================== Публичная тестовая ВМ ====================
module "public_vm" {
  source = "./modules/vm"

  instances = {
    "public-vm" = var.public_vm_ip
  }
  hostnames = {
    "public-vm" = "public-hw15-net"
  }
  project_label     = "hw15-networking"
  environment_label = var.environment

  default_zone = var.default_zone
  image_id     = data.yandex_compute_image.ubuntu.id

  cores     = 2
  memory    = 2
  disk_size = 15

  subnet_id          = module.public_subnet.id
  security_group_ids = [module.security.id]
  # по заданию: "виртуалка с публичным IP"
  assign_nat_ip = true

  ssh_public_key = file(var.ssh_public_key_path)
}

# ==================== Приватная тестовая ВМ ====================
module "private_vm" {
  source = "./modules/vm"

  instances = {
    "private-vm" = var.private_vm_ip
  }
  hostnames = {
    "private-vm" = "private-hw15-net"
  }
  project_label     = "hw15-networking"
  environment_label = var.environment

  default_zone = var.default_zone
  image_id     = data.yandex_compute_image.ubuntu.id

  subnet_id          = module.private_subnet.id
  security_group_ids = [module.security.id]
  # по заданию: "виртуалка с внутренним IP"
  assign_nat_ip = false

  ssh_public_key = file(var.ssh_public_key_path)
}
