provider "google" {
  credentials = "${file(var.gloud_creds_file)}"
  project     = "${var.project_name}"
  region      = "${var.location}"
}

resource "google_sql_database_instance" "postgres" {
  name = "${var.database_instance_name_prefix}-${random_id.db_name_suffix.hex}"
  database_version = "POSTGRES_9_6"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
    ipv4_enabled = true
    authorized_networks {
      name = "pubilc_access"
      value = "0.0.0.0/0"
    }
   }
  }
}


resource "google_sql_database" "database-prod" {
  name      = "prod-db"
  instance  = "${google_sql_database_instance.postgres.name}"
  depends_on = ["google_sql_database_instance.postgres"]
}

resource "google_sql_database" "database-test" {
  name      = "name"
  instance  = "${google_sql_database_instance.postgres.name}"
  depends_on = ["google_sql_database_instance.postgres"]
}

resource "google_sql_user" "users-prod" {
  name     = "user-prod"
  instance = "${google_sql_database_instance.postgres.name}"
  password = "${random_id.db_prod_pass.hex}"
  depends_on = ["google_sql_database_instance.postgres"]
}

resource "google_sql_user" "users-test" {
  name     = "postgres"
  instance = "${google_sql_database_instance.postgres.name}"
  password = "${var.db_test_user}"
  depends_on = ["google_sql_database_instance.postgres"]
}

