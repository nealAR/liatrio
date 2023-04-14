variable "project_id" {
  type = string
  description = "project id"
}

variable "region" {
  type = string
  description = "region"
}

variable "gke_nodes" {
  type = number
  description = "number of gke nodes"
}

variable "enable_apis" {
  type = list(string)
}