###cloud vars
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
  description = "VPC network & subnet name"
}

variable "vpc_name2" {
  type        = string
  default     = "develop2"
  description = "VPC network & subnet name"
}
variable "default_zone2" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr2" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGEQZ8pevzJD10tx+OCAVMiM1YZqURmvsEOcO3885Zg root@test"
  description = "ssh-keygen -t ed25519"
}

### yandex_compute_image vars

variable "vm_test_image_name" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Имя образа ОС"
}

### yandex_compute_instance vars

variable "vm_test_name" {
  type        = string
  default     = "netology-develop-platform"
  description = "Имя виртуальной машины"
}
variable "vm_test_platform_id" {
  type = string
  default = "standard-v3"
  description = "ID виртуальной платформы"
}
variable "vm_test_resources" {
  type = map(number)
  default = {
    cores          = 2
    memory         = 1
    core_fraction  = 20
 }
}

variable "vms_resources" {
  type = map(map(number))
  description = "Общие ресурсы"
  default = {
    vm_test_resources = {
      cores = 2
      memory = 1
      core_fraction = 20
    }
    vm_db_resources = {
      cores = 2
      memory = 2
      core_fraction = 20
    }
  }
}


variable "common_metadata" {
  description = "Общая переменная для метадаты"
  type        = map(string)
  default = {
    serial-port-enable = "1"
    ssh-keys           = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGEQZ8pevzJD10tx+OCAVMiM1YZqURmvsEOcO3885Zg root@test"
  }
}
