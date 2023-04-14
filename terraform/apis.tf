# Compute

resource "google_project_service" "project" {
  project = var.project_id
  for_each = toset(var.enable_apis)

  service = each.value

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}