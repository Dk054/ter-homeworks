# Локальная переменная для преобразования list в map
locals {
  db_vms_map = {
    for vm in var.each_vm : vm.vm_name => vm
  }
}

resource "yandex_compute_instance" "db" {
  # for_each с преобразованным map
  for_each = local.db_vms_map

  name        = each.value.vm_name  # "main" или "replica"
  hostname    = each.value.vm_name
  platform_id = each.value.platform_id
  zone        = each.value.zone

  # Разные параметры cpu/ram
  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = each.value.image_id
      type     = each.value.disk_type
      size     = each.value.disk_volume  # Разный disk_volume
    }
  }

  network_interface {
    subnet_id = var.subnet_id  # ID подсети из задания 1


    security_group_ids = [var.security_group_id]  # ID группы безопасности

    nat       = each.value.enable_nat
  }

  # file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub
  metadata = {
    ssh-keys = "${var.vm_ssh_user}:${local.vms_ssh_root_key}"
  }
}