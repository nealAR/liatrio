locals {
  gke_namespaces = [var.gke_namespace_non_prod, var.gke_namespace_prod]
}

data "google_client_config" "current" {
}

resource "kubernetes_cluster_role_binding" "user_role_binding" {
  metadata {
    name = "user-role-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind = "User"
    name = "neal.rodruck@gmail.com"
  }
}

resource "google_container_cluster" "primary" {
  name     = var.gke_cluster_name
  location = var.zone

  remove_default_node_pool = false
  initial_node_count       = 2

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/trace.append"
    ]

    labels = {
      env = var.project_id
    }

    # preemptible  = true
    machine_type = "e2-medium"
    tags         = ["gke-node", "${var.project_id}-gke"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

resource "kubernetes_namespace" "gke_namespaces" {
  for_each = toset(local.gke_namespaces)
  metadata {
    name = each.value
  }

  depends_on = [
    google_container_cluster.primary
  ]
}