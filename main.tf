provider "vra" {
  url           = var.url
  refresh_token = var.refresh_token
  insecure      = var.insecure
}

data "vra_project" "this" {
  name = var.project_name
}

data "vra_catalog_item" "this" {
  name            = var.catalog_item_name
  expand_versions = true
}

resource "vra_deployment" "this" {
  name        = var.deployment_name
  description = "terraform test deployment"

  catalog_item_id      = data.vra_catalog_item.this.id
  catalog_item_version = var.catalog_item_version
  project_id           = data.vra_project.this.id

  inputs = {
    flavor = "Small"
    image  = "RHEL7_CI"
    count  = 1
    flag   = false
    DCLocation = "do"
    ServerType = "ap"
    environment = "dv"
  }

  timeouts {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}
