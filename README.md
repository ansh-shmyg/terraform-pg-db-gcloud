# Description
Terrafrom Postgres DB installation
## Requirements 
* Use terrafrom v0.12.6 version minimum
* Configuration variables can be changed in files:
  ```shell
  variables.tf
  ```
## How to run
* Create Google service accout for terraform
* Set variables in variables.tf :
  ```
  project_name - GCP project name
  gloud_creds_file - GCP json service account path
  database_instance_name - database instance name. Change DB name at each new deploy !
  ```
* Run:
  ```
  terraform init
  terraform apply
  ```
