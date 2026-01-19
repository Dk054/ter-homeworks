locals {
  lplatform    = "netology-develop-platform"
  ltest         = "test"
  ldb          = "db"
  vm_test_Uname = "${ local.lplatform }-${ local.ltest }"
  vm_db_Uname  = "${ local.lplatform }-${ local.ldb }"
}