provider "google" {
  credentials = "${file(var.gloud_creds_file)}"
  project     = "${var.project_name}"
  region      = "${var.location}"
}

resource "google_sql_database_instance" "postgres" {
  name = "${var.database_instance_name}"
  database_version = "POSTGRES_9_6"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
     ipv4_enabled = "false"
     private_network = "projects/${var.project_name}/global/networks/default"
   }
  }
}


resource "google_sql_database" "database-prod" {
  name      = "prod-db"
  instance  = "${google_sql_database_instance.postgres.name}"
}

resource "google_sql_database" "database-test" {
  name      = "test-db"
  instance  = "${google_sql_database_instance.postgres.name}"
}

resource "google_sql_user" "users-prod" {
  name     = "postgres"
  instance = "${google_sql_database_instance.postgres.name}"
  password = "${random_id.db_prod_pass.hex}"
}

resource "google_sql_user" "users-test" {
  name     = "postgres-test"
  instance = "${google_sql_database_instance.postgres.name}"
  password = "${random_id.db_test_pass.hex}"
}

