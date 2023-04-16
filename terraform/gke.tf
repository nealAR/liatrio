locals {
  gke_namespaces = [var.gke_namespace_non_prod, var.gke_namespace_prod]
}

data "google_client_config" "current" {
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.zone

  remove_default_node_pool = false
  initial_node_count       = 3

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

resource "kubernetes_namespace" "gke_namespaces" {
  for_each = toset(local.gke_namespaces)
  metadata {
    name = each.value
  }

  depends_on = [
    google_container_cluster.primary
  ]
}

resource "kubernetes_service" "liatrio_service" {
  for_each = toset(local.gke_namespaces)
  metadata {
    namespace = each.value
    name      = "${var.gke_service_name}-${each.value}"
  }
  spec {
    selector = {
      app = "${var.gke_deployment_name}-${each.value}"
    }
    session_affinity = "ClientIP"
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 3000
    }
    type = "LoadBalancer"
    #load_balancer_ip = google_compute_address.default.address
  }

  depends_on = [
    kubernetes_namespace.gke_namespaces
  ]
}

resource "kubernetes_deployment" "liatrio_deployment" {
  for_each = toset(local.gke_namespaces)
  metadata {
    name      = "${var.gke_deployment_name}-${each.value}"
    namespace = each.value
    labels = {
      environment = each.value
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "${var.gke_deployment_name}-${each.value}"
      }
    }

    template {
      metadata {
        labels = {
          app = "${var.gke_deployment_name}-${each.value}"
        }
      }

      spec {
        container {
          image = var.image_name
          name  = "${var.gke_deployment_name}-${each.value}"

          resources {
            limits {
              cpu    = "128Mi"
              memory = "128Mi"
            }
            requests {
              cpu    = "250m"
              memory = "64Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/"
              port = 3000

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_namespace.gke_namespaces
  ]
}
