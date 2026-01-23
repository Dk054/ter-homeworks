###cloud vars
#variable "token" {
#  type        = string
#  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
#}

variable "cloud_id" {
  type        = string
  default     = "b1gsjth4p4d9mq314dsk"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1gsugenqt9rfairour5"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network&subnet name"
}



# ========== ОБЩИЕ ПЕРЕМЕННЫЕ (для всех ВМ) ==========

variable "vm_ssh_user" {
  description = "Имя пользователя для SSH доступа к ВМ"
  type        = string
  default     = "ubuntu"
}


variable "ssh_public_key_path" {
  description = "Путь к файлу с публичным SSH-ключом"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

# Локальная переменная для чтения SSH-ключа
locals {
  vms_ssh_root_key = file(var.ssh_public_key_path)
}

# ========== ОБЯЗАТЕЛЬНЫЕ ПЕРЕМЕННЫЕ ИЗ ЗАДАНИЯ 1 ==========

variable "security_group_id" {
  description = "ID группы безопасности, созданной в задании 1"
  type        = string
  default     = "enpffp3sop0a8nc2hhst"
  # ПРИМЕЧАНИЕ: Это значение ДОЛЖНО быть указано в terraform.tfvars
  # Пример: security_group_id = "enp5n7maju7oexampleid"
}

variable "subnet_id" {
  description = "ID подсети, созданной в задании 1"
  type        = string
  default     = "e9b47uqahublrm45bugb"
  # ПРИМЕЧАНИЕ: Это значение ДОЛЖНО быть указано в terraform.tfvars
  # Пример: subnet_id = "e9b0le401619exampleid"
}

# ========== ПЕРЕМЕННЫЕ ДЛЯ WEB ВМ (count-vm.tf) ==========

variable "web_vm_count" {
  description = "Количество создаваемых web ВМ"
  type        = number
  default     = 2  # Задание: две одинаковых ВМ
}

variable "web_vm_name_prefix" {
  description = "Префикс имени для web ВМ"
  type        = string
  default     = "web"  # Будет: web-1, web-2
}

variable "web_vm_platform_id" {
  description = "Платформа для web ВМ"
  type        = string
  default     = "standard-v3"
}

variable "web_vm_zone" {
  description = "Зона доступности для web ВМ"
  type        = string
  default     = "ru-central1-a"
}


variable "web_vm_cores" {
  description = "Количество ядер CPU для web ВМ (минимальное)"
  type        = number
  default     = 2
}

variable "web_vm_memory" {
  description = "Объем памяти для web ВМ в ГБ (минимальное)"
  type        = number
  default     = 1
}

variable "web_vm_core_fraction" {
  description = "Гарантированная доля ядра для web ВМ"
  type        = number
  default     = 20
}

variable "web_vm_image_id" {
  description = "ID образа ОС для web ВМ"
  type        = string
  default     = "fd8vmcue7aajpmeo39kk"  # Ubuntu 22.04 LTS
}

variable "web_vm_disk_type" {
  description = "Тип загрузочного диска для web ВМ"
  type        = string
  default     = "network-hdd"
}

variable "web_vm_boot_disk_size" {
  description = "Размер загрузочного диска для web ВМ в ГБ"
  type        = number
  default     = 10  # Минимальный разумный размер
}

variable "web_vm_enable_nat" {
  description = "Включить NAT (внешний IP) для web ВМ"
  type        = bool
  default     = true
}
# ========== ПЕРЕМЕННЫЕ ДЛЯ DB ВМ (for_each-vm.tf) ==========
variable "each_vm" {
  description = "Конфигурация ВМ баз данных (main и replica)"
  type = list(object({
    vm_name       = string           # "main" и "replica"
    cpu           = number           # разные значения
    ram           = number           # разные значения
    disk_volume   = number           # разные значения

    # Дополнительные параметры
    platform_id   = optional(string, "standard-v3")
    zone          = optional(string, "ru-central1-a")
    disk_type     = optional(string, "network-hdd")
    image_id      = optional(string, "fd8vmcue7aajpmeo39kk")
    enable_nat    = optional(bool, true)
    core_fraction = optional(number, 20)
  }))

  default = [
    # ВМ "main"
    {
      vm_name     = "main"
      cpu         = 4      # разные
      ram         = 8      # разные
      disk_volume = 20     # разные
      core_fraction = 50   # высокая доля ядра для основной БД
    },
    # ВМ "replica"
    {
      vm_name     = "replica"
      cpu         = 2      # разные
      ram         = 4      # разные
      disk_volume = 15     # разные
      core_fraction = 20   # средняя доля ядра для реплики
    }
  ]
}

# ========== ВЫХОДНЫЕ ПЕРЕМЕННЫЕ ==========

output "web_vm_ips" {
  description = "Внешние IP-адреса web ВМ"
  value = {
    for instance in yandex_compute_instance.web :
    instance.name => instance.network_interface[0].nat_ip_address
  }
}

output "db_vm_ips" {
  description = "Внешние IP-адреса DB ВМ"
  value = {
    for name, instance in yandex_compute_instance.db :
    name => instance.network_interface[0].nat_ip_address
  }
}

output "all_vm_fqdns" {
  description = "Внутренние FQDN всех ВМ"
  value = concat(
    [for vm in yandex_compute_instance.web : vm.fqdn],
    [for name, vm in yandex_compute_instance.db : vm.fqdn]
  )
}