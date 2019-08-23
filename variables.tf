variable "project_name" {
  default = "gcpssproject-248009"
}

variable "gloud_creds_file" {
  default = "/home/ash/.gcloud/gcpssproject-248009-54dc60693c76.json"
}

variable "location" {
  default = "europe-west1"
}

// Database configuration
variable "database_instance_name_prefix" {
  default = "main-postgres"
}

resource "random_id" "db_prod_pass" {
  byte_length = 14
}

variable "db_test_user" {
  default = "postgres"
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}
