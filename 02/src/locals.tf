locals {
  lplatform    = "netology-develop-platform"
  ltest         = "test"
  ldb          = "db"
  vm_test_Uname = "${ local.lplatform }-${ local.lweb }"
  vm_db_Uname  = "${ local.lplatform }-${ local.ldb }"
}