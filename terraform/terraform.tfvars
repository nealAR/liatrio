################################
## GCP 
################################
project_id = "liatrio-takehome1"
region     = "us-east1"
zone       = "us-east1-b"

################################
## GKE 
################################
gke_cluster_name       = "liatrio-test-cluster"
gke_deployment_name    = "liatrio-deployment"
gke_service_name       = "liatrio-service"
gke_namespace_non_prod = "non-prod"
gke_namespace_prod     = "prod"
image_name             = "us-east1-docker.pkg.dev/liatrio-automation/node-repo/liatrio-takehome"
gke_nodes              = 1
