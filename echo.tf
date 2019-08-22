output "database_ip" {
  value = "${google_sql_database_instance.postgres.private_ip_address}"
}

output "db_name_prod" {
  value = "${google_sql_database.database-prod.name}"
}

output "db_user_name_prod" {
  value = "${google_sql_user.users-prod.name}"
}

output "db_pass_prod" {
  value = "${random_id.db_prod_pass.hex}"
}

output "db_name_test" {
  value = "${google_sql_database.database-test.name}"
}

output "db_user_name_test" {
  value = "${google_sql_user.users-test.name}"
}

output "db_pass_test" {
  value = "${var.db_test_user}"
}
