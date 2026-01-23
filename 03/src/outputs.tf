output "web_vm_security_groups" {
  value = {
    for instance in yandex_compute_instance.web :
    instance.name => instance.network_interface[0].security_group_ids
  }
  description = "Группы безопасности web ВМ"
}

output "db_vm_security_groups" {
  value = {
    for name, instance in yandex_compute_instance.db :
    name => instance.network_interface[0].security_group_ids
  }
  description = "Группы безопасности DB ВМ"
}