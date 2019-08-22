provider "google" {
#  credentials = "${file(var.gloud_creds_file)}"
  project     = "${var.project_name}"
  region      = "${var.location}"
}

data "google_compute_network" "my-network" {
 name = "default"
}

resource "google_compute_global_address" "private_ip_address" {
  provider = "google-beta"

  project     = "${var.project_name}"
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type = "INTERNAL"
  prefix_length = 16
  network       = "${data.google_compute_network.my-network.self_link}"
}

resource "google_service_networking_connection" "service_connection" {
  provider                = "google-beta"
  network                 = "${data.google_compute_network.my-network.self_link}"
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = []
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = "google-beta"

  network       = "${data.google_compute_network.my-network.self_link}"
  service       = "servicenetworking.googleapis.com"
  reserved_peering_ranges = ["${google_compute_global_address.private_ip_address.name}"]
}

resource "google_sql_database_instance" "postgres" {
  name = "${var.database_instance_name}"
  provider = "google-beta"
  project     = "${var.project_name}"
  database_version = "POSTGRES_9_6"
  region = "${var.location}"
  settings {
    tier = "db-f1-micro"
    ip_configuration {
     ipv4_enabled = "false"
     private_network = "${data.google_compute_network.my-network.self_link}"
   }
  }
  depends_on = [
    "google_service_networking_connection.private_vpc_connection"
  ]
}


resource "google_sql_database" "database-prod" {
  name      = "prod-db"
  instance  = "${google_sql_database_instance.postgres.name}"
  project     = "${var.project_name}"
}

resource "google_sql_database" "database-test" {
  name      = "name"
  instance  = "${google_sql_database_instance.postgres.name}"
  project     = "${var.project_name}"
}

resource "google_sql_user" "users-prod" {
  name     = "users-prod"
  instance = "${google_sql_database_instance.postgres.name}"
  project     = "${var.project_name}"
  password = "${random_id.db_prod_pass.hex}"
}

resource "google_sql_user" "users-test" {
  name     = "postgres"
  instance = "${google_sql_database_instance.postgres.name}"
  password = "${var.db_test_user}"
  project     = "${var.project_name}"
}

