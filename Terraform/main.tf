terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.4.1"
    }
  }
}

# Connect to a given vCenter server 
provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

# Describe to Terraform an existing vSphere datacenter
data "vsphere_datacenter" "dc" {
  name = var.dc_name
}

# Describe to Terraform an existing ESXi host
data "vsphere_host" "host" {
  name          = var.vmh_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Describe to Terraform an existing datastore
data "vsphere_datastore" "datastore" {
  name          = var.ds_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Describe to Terraform an existing portgroup
data "vsphere_network" "network" {
  name          = var.pg_name
  datacenter_id = data.vsphere_datacenter.dc.id
}
