terraform {
  /*backend "gcs" {
    bucket = "<gcs-bucket-name"
    prefix = "state"
  }*/
  required_version = ">= 0.12"
}


provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  version = "~> 1.10.0"
  host    = google_container_cluster.primary.endpoint
  token   = data.google_client_config.current.access_token
  client_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].client_certificate,
  )
  client_key = base64decode(google_container_cluster.primary.master_auth[0].client_key)
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}