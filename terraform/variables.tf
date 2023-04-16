variable "project_id" {
  type        = string
  description = "project id"
}

variable "region" {
  type        = string
  description = "region"
}

variable "zone" {
  type        = string
  description = "zone"
}

variable "gke_nodes" {
  type        = number
  description = "number of gke nodes"
}

variable "enable_apis" {
  type = list(string)
}

variable "gke_deployment_name" {
  type = string
}

variable "gke_service_name" {
  type = string
}

variable "image_name" {
  type = string
}

variable "gke_namespace_non_prod" {
  type = string
}

variable "gke_namespace_prod" {
  type = string
}
