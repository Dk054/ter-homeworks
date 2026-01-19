output "VMs_output" {
  value = {
    VM_test_name   = yandex_compute_instance.platform.name
    VM_test_FQDN   = yandex_compute_instance.platform.fqdn
    VM_test_ext_ip = yandex_compute_instance.platform.network_interface[0].nat_ip_address
    VM_db_name    = yandex_compute_instance.platform_db.name
    VM_db_FQDN   = yandex_compute_instance.platform_db.fqdn
    VM_db_ext_ip = yandex_compute_instance.platform_db.network_interface[0].nat_ip_address
  }
}