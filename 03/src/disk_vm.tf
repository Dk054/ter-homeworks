# disk_vm.tf
# Задание 3: Создание дисков и ВМ storage

# ========== 3.1: Создание 3 одинаковых дисков с помощью count ==========
resource "yandex_compute_disk" "storage_disks" {
  count = var.storage_disk_count

  name        = "${var.storage_disk_name_prefix}-${count.index + 1}"
  description = var.storage_disk_description
  type        = var.storage_disk_type
  zone        = var.storage_vm_zone
  size        = var.storage_disk_size_gb
}

# ========== 3.2: Создание одиночной ВМ "storage" ==========
resource "yandex_compute_instance" "storage" {
  # ОДИНОЧНАЯ ВМ (count/for_each запрещены)
  name        = var.storage_vm_name
  hostname    = var.storage_vm_name
  platform_id = var.storage_vm_platform_id
  zone        = var.storage_vm_zone

  resources {
    cores         = var.storage_vm_cores
    memory        = var.storage_vm_memory_gb
    core_fraction = var.storage_vm_core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.storage_vm_image_id
      type     = var.storage_vm_boot_disk_type
      size     = var.storage_vm_boot_disk_size_gb
    }
  }

  network_interface {
    subnet_id          = var.subnet_id
    security_group_ids = [var.security_group_id]
    nat                = var.storage_vm_enable_nat
  }

  metadata = {
    ssh-keys = "${var.vm_ssh_user}:${local.vms_ssh_root_key}"
  }

  # ========== dynamic secondary_disk с for_each ==========
  dynamic "secondary_disk" {
    for_each = {
      for idx, disk in yandex_compute_disk.storage_disks : idx => disk.id
    }

    content {
      disk_id = secondary_disk.value
    }
  }

  scheduling_policy {
    preemptible = var.vm_preemptible
  }

  allow_stopping_for_update = var.allow_stopping_for_update
}

# ========== Outputs для проверки ==========
output "storage_vm_summary" {
  value = {
    vm_name        = yandex_compute_instance.storage.name
    vm_zone        = yandex_compute_instance.storage.zone
    vm_fqdn        = yandex_compute_instance.storage.fqdn
    boot_disk_size = "${var.storage_vm_boot_disk_size_gb} ГБ"
    attached_disks = length(yandex_compute_instance.storage.secondary_disk)
    disk_details = [
      for disk in yandex_compute_disk.storage_disks : {
        name = disk.name
        size = "${disk.size} ГБ"
        type = disk.type
      }
    ]
  }
  description = "Сводная информация о ВМ storage и подключенных дисках"
}
