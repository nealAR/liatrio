resource "google_artifact_registry_repository" "liatrio_artifact_registry" {
  location      = var.region
  repository_id = "node-repo"
  description   = "Container registry for node app"
  format        = "DOCKER"
}