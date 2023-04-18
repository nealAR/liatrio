# Liatrio Containerization, Orchestration, and Automation Demo Repository

Included in this repository are Terraform scripts for the automated build and deployment of a containerized node.js application hosted on GKE. 

## Why GKE?

Google Kubernetes Engine is GCP's native container orchestration framework automating the deployment, scaling, networking, and monitoring of applications. 

## Why Artifact Registry?

Artifact Registry is the next generation evolution of Google Cloud Platform's Container Registry. Both services provide managed conatainer image repositories for easy storage and management, however with imporved security features, such as enforced controls over which container images are allowed to run in your environment, and tighter integration with GCP services such as Cloud Run, Cloud Build, and GKE, as well as overall better network performance and cost-effective pricing model, Artifact Registry is the preferred image repository. 

## Pre-requisites

1. A Google Cloud Platform Project linked to an associated Billing Account
2. For local development: 
   - Installation of the 'gcloud' CLI: https://cloud.google.com/sdk/docs/install
   - Installation of the Terraform CLI: https://cloud.google.com/sdk/docs/install
   - Installation of ```make```: https://www.gnu.org/software/make/#download
3. Using either 'gcloud' or your GCP Project's Console enable following APIs:
   - Artifact Registry: artifactregistry.googleapis.com
   - Cloud Resource Manager: cloudresourcemanager.googleapis.com
   - Compute Engine: compute.googleapis.com
   - Kubernetes Engine: container.googleapis.com

## Deploying from the CLI 
Command line deployments have been abstracted into ```make``` commands and **must be run synchronously.** 

1. Deploy infrastructure: ```make infra project_id=<gcp-project-id> region=<region> zone=<zone>```

2. Docker build, push, and GKE manifest deployments: ```make app cluster-name=<gke-cluster-name> project_id=<gcp-project-id> region=<region> zone=<zone>```

Please [this](https://cloud.google.com/compute/docs/regions-zones#identifying_a_region_or_zone) link for more GCP region/zone infromation 

## Remote State Managment
Terraform remote state management is required for Cloud Build CI/CD runs. The simplest approach is use Cloud Storage Buckets in order to leverage Cloud Build's streamlined integration with GCP native products. In order to do so we must create a simple Storage Bucket and configure usage in our 'provider.tf' file. 

1. In the Google Cloud Console nagviate to Cloud Storage and select the Buckets tab.
2. Click "Create Bucket".
3. Select a name.
4. Select the desired Region, Storage Class (Standard recommended), Access Control, Protection Tools, and Encryption Key options.
5. In the local repository navigate to 'terraform/provider.tf' and update the ```terraform``` block with the backend con
   ```
   terraform {
      backend "gcs" {
         bucket = "<gcs-bucket-name-from-step-2>"
         prefix = "state"
      }
      required_version = ">= 0.12"
   }
   ```

## Enable CI/CD: Cloud Build
If you wish to deploy the applcation using Google's Cloud Build CI/CD tool a pipeline is provided in the root directory of this repository (cloudbuild-app.yaml & cloudbuild-infra.yaml). Once set up is complete this pipeline will provide faster, more reliable deployments increasing overall code quality and team agility through automated builds and infrastructure management. 

Please follow the steps below to enable automated deployment of the Cloud Run application!

1. Using either 'gcloud' or your GCP Project's Console enable the Cloud Build API: 
   - cloudbuild.googleapis.com
2. Navigate to your project's Cloud Build Dashboard and click on the Settings tab. Enable the following roles for the Cloud Build service account:
   - Cloud Run Admin
   - Compute Engine Admin
   - Service Accounts User
3. From the Cloud Build Dashboard navigate to the Trigger tab and click "Connect Repository". From there follow the steps to enable authentication from your GCP Project to your SCM of choice. 
4. In order to create a Cloud Trigger navigate back to the Trigger tab and click the "Create Trigger" button. In the form provided select your desired Trigger Name, Region, Description (optional), Repository and Branch. Under Configuration make sure the following options are selected:
   - Type: Cloud Build configuration file (yaml or json)
   - Location: Repository
   - For Terraform infrastructure build:
     - Cloud Build configuration file location: cloudbuild/cloudbuild-infra.yaml
     - Included files filter (glob): terraform/**
     - Ignored files filter (glob): src/**  
   - For docker image build:
     - Cloud Build configuration file location: cloudbuild/cloudbuild-app.yaml
     - Included files filter (glob): src/**
     - Ignored files filter (glob): terraform/**
5. Hit Create


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| image_name | Tag provided for creation, push, and pull of Docker image | `string` | `null` | yes |
| region | GCP Project region | `string` | `null` | yes |
| zone | GCP Project zone | `string` | `null` | yes |
| project_id | GCP Project ID | `string` | `null` | yes |
| gke_cluster_name | Name of GKE cluster | `string` | `null` | yes |
| gke_deployment_name | Name of Deployment Kubernetes resource | `string` | `null` | yes |
| gke_service_name | Name of Service Kubernetes resoource | `string` | `null` | yes |
| gke_namespace_non_prod | Name of non-production Kubernetes namespace | `string` | `null` | yes |
| gke_namespace_prod | Name of production Kubernetes namespace | `string` | `null` | yes |
| gke_nodes | Number of nodes to deploy within Kubernetes cluster | `string` | `null` | yes |
