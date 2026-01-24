resource "yandex_compute_instance" "web" {
  count = var.web_vm_count # Создаем 2 ВМ

  name        = "${var.web_vm_name_prefix}-${count.index + 1}"
  hostname    = "${var.web_vm_name_prefix}-${count.index + 1}"
  platform_id = var.web_vm_platform_id
  zone        = var.web_vm_zone

  # Минимальные параметры
  resources {
    cores         = var.web_vm_cores
    memory        = var.web_vm_memory
    core_fraction = var.web_vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.web_vm_image_id
      type     = var.web_vm_disk_type
      size     = var.web_vm_boot_disk_size
    }
  }

  network_interface {
    subnet_id = var.subnet_id # ID подсети из задания 1

    # назначение ВМ созданную в первом задании группу безопасности
    security_group_ids = [var.security_group_id] # ID группы безопасности из задания 1

    nat = var.web_vm_enable_nat # Включаем внешний IP
  }

  # Использую функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub
  metadata = {
    ssh-keys = "${var.vm_ssh_user}:${local.vms_ssh_root_key}"
  }

  # ВМ из пункта 2.1 должны создаться после создания ВМ из пункта 2.2
  depends_on = [
    yandex_compute_instance.db
  ]
}