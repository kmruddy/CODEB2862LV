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
data "vsphere_host" "vmh_zero" {
  name          = var.vmh_zero
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Describe to Terraform an existing ESXi host
data "vsphere_host" "vmh_one" {
  name          = var.vmh_one
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Create a vSphere cluster and add 2 hosts via data block
resource "vsphere_compute_cluster" "compute_cluster" {
  name                 = var.cluster_name
  datacenter_id        = data.vsphere_datacenter.dc.id
  host_system_ids      = [data.vsphere_host.vmh_zero.id, data.vsphere_host.vmh_one.id]
  drs_enabled          = var.cluster_drs_status
  drs_automation_level = "fullyAutomated"
}

# Modify the cluster by disabling DRS with the following command:
# terraform apply -var="cluster_drs_status=false"
