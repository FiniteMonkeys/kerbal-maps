terraform {
  backend "gcs" {
    credentials = "credentials.json"
    bucket  = "finitemonkeys-tf-state"
    prefix  = "kerbal-maps"
  }
}

data "null_data_source" "auth_network_whitelist" {
  count = 1

  inputs = {
    name  = "onprem-${count.index + 1}"
    value = "${element(list("136.63.238.101"), count.index)}"
  }
}

provider "google" {
  credentials = "${file("credentials.json")}"
  project     = "kerbal-maps"
  region      = "us-central1"
  zone        = "us-central1-c"
}

resource "google_sql_database_instance" "master" {
  region           = "us-central1"
  # name             = "master-instance"
  database_version = "POSTGRES_9_6"

  settings {
    tier      = "db-f1-micro"
    # disk_size = "1"

    ip_configuration {
      authorized_networks = [
        "${data.null_data_source.auth_network_whitelist.*.outputs}"
      ]
    }
  }

  timeouts {
    create = "15m"
    delete = "2h"
  }
}

resource "google_sql_user" "postgres" {
  instance = "${google_sql_database_instance.master.name}"
  name     = "postgres"
  password = "changeme"
}

resource "google_sql_database" "kerbal_maps" {
  name      = "kerbal_maps"
  instance  = "${google_sql_database_instance.master.name}"

  charset   = "UTF8"
  collation = "en_US.UTF8"
}
