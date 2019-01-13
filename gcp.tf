terraform {
  backend "gcs" {
    credentials = "credentials.json"
    bucket  = "finitemonkeys-tf-state"
    prefix  = "kerbal-maps"
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
  }
}

resource "google_sql_database" "kerbal_maps" {
  name      = "kerbal_maps"
  instance  = "${google_sql_database_instance.master.name}"

  charset   = "UTF8"
  collation = "en_US.UTF8"
}
