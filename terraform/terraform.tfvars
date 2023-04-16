################################
## GCP 
################################
project_id = "liatrio-takehome1"
region     = "us-east1"
zone       = "us-east1-b"
enable_apis = [
  "compute.googleapis.com",
  "container.googleapis.com",
  "artifactregistry.googleapis.com"
]

################################
## GKE 
################################
gke_deployment_name    = "liatrio-deployment"
gke_service_name       = "liatrio-service"
gke_namespace_non_prod = "non-prod"
gke_namespace_prod     = "prod"
image_name             = "us-east1-docker.pkg.dev/liatrio-takehome1/node-repo/liatrio-takehome"
gke_nodes              = 1
