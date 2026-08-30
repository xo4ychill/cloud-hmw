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
  route_table_id = module.private_route_table.id # весь исходящий трафик -> NAT-инстанс
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


# ======================================================================
# HW15.2 — «Вычислительные мощности. Балансировщики нагрузки»
# ======================================================================
# Переиспользует уже существующую сеть/подсети/security group из HW15.1
# (модули network/subnet/security выше) — Instance Group размещается в ТОЙ ЖЕ
# public-подсети, что и public-vm/nat-instance.

# ==================== Уникальный суффикс имени бакета ====================
# Имена бакетов Object Storage уникальны ГЛОБАЛЬНО
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# ==================== Object Storage: бакет + картинка ====================
module "object_storage" {
  source = "./modules/object_storage"

  service_account_name = "hw15-2-storage-sa"
  folder_id            = var.folder_id
  bucket_name          = "${var.bucket_name_prefix}-${random_id.bucket_suffix.hex}"
  object_key           = var.picture_object_key
  source_file_path     = var.picture_source_path
}

# ==================== Сервисный аккаунт для Instance Group ====================
# ОТДЕЛЬНЫЙ от сервисного аккаунта Object Storage выше — Instance Group нужны
# права editor НА КАТАЛОГ (управлять своими ВМ), а не storage.editor.
resource "yandex_iam_service_account" "instance_group_sa" {
  name        = "hw15-2-ig-sa"
  description = "Сервисный аккаунт для управления Instance Group (HW15.2)"
}

resource "yandex_resourcemanager_folder_iam_member" "instance_group_editor" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.instance_group_sa.id}"
}

# ==================== Instance Group для NLB (LAMP, фиксированный размер 3) ====================
# lb_type = "network" (по умолчанию) — создаёт target group для Network Load Balancer.
module "instance_group" {
  source = "./modules/instance_group"

  name               = "hw15-2-lamp-ig"
  hostname_prefix    = "hw15-2-nlb-vm-"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.instance_group_sa.id
  lb_type            = "network"

  image_id       = var.lamp_image_id
  instance_count = var.instance_group_size
  default_zone   = var.default_zone

  network_id         = module.network.id
  subnet_id          = module.public_subnet.id
  security_group_ids = [module.security.id]

  ssh_public_key          = file(var.ssh_public_key_path)
  webserver_init_template = var.webserver_init_template_path
  picture_url             = module.object_storage.public_url

  depends_on = [yandex_resourcemanager_folder_iam_member.instance_group_editor]
}

# ==================== Instance Group для ALB ====================
# ОТДЕЛЬНАЯ Instance Group, не переиспользует module.instance_group выше — Yandex Cloud
# не позволяет одной Instance Group одновременно быть источником target group и для
# NLB, и для ALB. Поэтому для ALB заводится вторая, самостоятельная группа с lb_type = "application".
# Размер МЕНЬШЕ основной (var.alb_instance_group_size, а не var.instance_group_size) 
# — опциональный бонус, есть смысл не удваивать расходы на демонстрацию.
module "instance_group_alb" {
  source = "./modules/instance_group"

  name               = "hw15-2-lamp-ig-alb"
  hostname_prefix    = "hw15-2-alb-vm-"
  folder_id          = var.folder_id
  service_account_id = yandex_iam_service_account.instance_group_sa.id
  lb_type            = "application"

  image_id       = var.lamp_image_id
  instance_count = var.alb_instance_group_size
  default_zone   = var.default_zone

  network_id         = module.network.id
  subnet_id          = module.public_subnet.id
  security_group_ids = [module.security.id]

  ssh_public_key          = file(var.ssh_public_key_path)
  webserver_init_template = var.webserver_init_template_path
  picture_url             = module.object_storage.public_url

  depends_on = [yandex_resourcemanager_folder_iam_member.instance_group_editor]
}

# ==================== Network Load Balancer ====================
module "network_load_balancer" {
  source = "./modules/network_load_balancer"

  name            = "hw15-2-nlb"
  target_group_id = module.instance_group.target_group_id
}

# ==================== Application Load Balancer ====================
module "application_load_balancer" {
  source = "./modules/application_load_balancer"

  name               = "hw15-2-alb"
  target_group_id    = module.instance_group_alb.target_group_id
  network_id         = module.network.id
  subnet_id          = module.public_subnet.id
  default_zone       = var.default_zone
  security_group_ids = [module.security.id]
}
