#Создание динамического Ansible inventory

# Проверяем, что ВМ созданы прежде чем генерировать inventory
locals {
  # Проверка существования ВМ (защита от ошибок)
  webservers_exist = try(length(yandex_compute_instance.web) > 0, false)
  databases_exist  = try(length(yandex_compute_instance.db) > 0, false)
  storage_exists   = try(yandex_compute_instance.storage != null, false)
}

resource "local_file" "ansible_inventory" {
  filename = "hosts.ini"

  #templatefile с данными из созданных ВМ
  content = templatefile("${path.module}/templates/hosts.tftpl", {
    # Группа webservers (из задания 2.1)
    webservers = local.webservers_exist ? [
      for vm in yandex_compute_instance.web : {
        name           = vm.name
        fqdn           = vm.fqdn
        nat_ip_address = vm.network_interface[0].nat_ip_address
      }
    ] : []

    # Группа databases (из задания 2.2)
    databases = local.databases_exist ? [
      for name, vm in yandex_compute_instance.db : {
        name           = vm.name
        fqdn           = vm.fqdn
        nat_ip_address = vm.network_interface[0].nat_ip_address
      }
    ] : []

    # Группа storage (из задания 3.2)
    storage = local.storage_exists ? [{
      name           = yandex_compute_instance.storage.name
      fqdn           = yandex_compute_instance.storage.fqdn
      nat_ip_address = yandex_compute_instance.storage.network_interface[0].nat_ip_address
    }] : []
  })

  file_permission = "0644"

  # зависимость от всех ВМ
  depends_on = [
    yandex_compute_instance.web,
    yandex_compute_instance.db,
    yandex_compute_instance.storage
  ]
}

# Output для проверки
output "inventory_status" {
  value = <<-EOT
    Ansible inventory создан: ${local_file.ansible_inventory.filename}

    Содержит группы:
    - webservers: ${local.webservers_exist ? join(", ", [for vm in yandex_compute_instance.web : vm.name]) : "НЕТ ВМ"}
    - databases: ${local.databases_exist ? join(", ", [for name, vm in yandex_compute_instance.db : vm.name]) : "НЕТ ВМ"}
    - storage: ${local.storage_exists ? yandex_compute_instance.storage.name : "НЕТ ВМ"}

    Файл: ${abspath(local_file.ansible_inventory.filename)}
  EOT
}

output "inventory_preview" {
  value = local_file.ansible_inventory.content
  sensitive = false
}