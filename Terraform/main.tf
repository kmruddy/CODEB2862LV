terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.4.1"
    }
  }
}

provider "vsphere" {
  user                 = "svc_tf@prob.local"
  password             = "Terraform!23"
  vsphere_server       = "probvcsa01.prob.local"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Prob-DC"
}

data "vsphere_host" "host" {
  name          = "vesxi00.prob.local"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = "nfs-terraform"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}

output "dc_info" {
  value = data.vsphere_datacenter.dc
}

output "vpg_info" {
  value = data.vsphere_network.network
}
