terraform {
  required_providers {
    spectrocloud = {
      version = ">= 0.1"
      source  = "spectrocloud/spectrocloud"
    }
  }
}

provider "spectrocloud" {
  host         = var.spectro_api_endpoint
  api_key      = var.spectro_api_key
  project_name = var.spectro_project_name
}
