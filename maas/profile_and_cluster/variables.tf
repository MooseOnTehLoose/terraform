
variable "spectro_project_name" {
  type        = string
  description = "The Project on the Tenant"
  default     = "Default"
}

variable "spectro_api_endpoint" {
  type        = string
  description = "Palette API Endpoint"
  default     = "api.spectrocloud.com"
}

variable "spectro_api_key" {
  type        = string
  description = "API Key for your User"
  sensitive   = true 
}

variable "cluster_cloud_account_name" {
  type        = string
  description = "The Cloud Account for MaaS"
  default     = "default"
}

variable "cluster_name" {
  type        = string
  description = "Cluster Name, K8s Naming Convention Rules Apply"
  default     = "demo-cluster"
}

variable "maas_cp_resource_pool" {
  type        = string
  description = "Control Plane Pool Resource Group in MaaS"
  default     = "controlplane"
}
variable "maas_wk_resource_pool" {
  type        = string
  description = "Worker Pool Resource Group in MaaS"
  default     = "worker"
}
variable "maas_domain" {
  type        = string
  default     = "maas" 
}
variable "maas_azs" {
  type        = list(string)
  description = "Availability Zone in MaaS"
  default     = [ "default"]
}
variable "maas_tags" {
  type        = list(string)
  description = "Placement tags for kubernetes nodes on MaaS machines"
  default     = ["virtual"]
}
variable "metal_range" {
  type = string
  description = "List of Metal-LB addresses for this cluster"
  default = "10.4.8.200-10.4.8.205"
}