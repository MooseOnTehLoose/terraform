data "spectrocloud_cloudaccount_maas" "account" {
  name = var.cluster_cloud_account_name
}

resource "spectrocloud_cluster_maas" "cluster" {
  name = var.cluster_name 

  cluster_profile {
    id = spectrocloud_cluster_profile.profile.id
  }

  cloud_account_id = data.spectrocloud_cloudaccount_maas.account.id

  cloud_config {
    domain        = var.maas_domain
    enable_lxd_vm = false
  }

  machine_pool {
    control_plane           = true
    control_plane_as_worker = false
    name                    = "control-plane-pool"
    count                   = 3
    placement {
      resource_pool = var.maas_cp_resource_pool
    }
    instance_type {
      min_memory_mb = 4096
      min_cpu       = 2
    }
    azs = var.maas_azs
    node_tags = var.maas_tags

  }

  machine_pool {
    name  = "worker-pool"
    count = 4
    placement {
      resource_pool = var.maas_wk_resource_pool
    }
    instance_type {
      min_memory_mb = 4096
      min_cpu       = 8
    }

    azs =  var.maas_azs
    node_tags = var.maas_tags

  }

}
