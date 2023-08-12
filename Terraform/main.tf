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
  user                 = "svc_tf@prob.local"
  password             = "Terraform!23"
  vsphere_server       = "probvcsa01.prob.local"
  allow_unverified_ssl = true
}

# Describe to Terraform an existing vSphere datacenter
data "vsphere_datacenter" "dc" {
  name = "Prob-DC"
}

# Describe to Terraform an existing ESXi host
data "vsphere_host" "host" {
  name          = "vesxi00.prob.local"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Describe to Terraform an existing datastore
data "vsphere_datastore" "datastore" {
  name          = "nfs-terraform"
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Describe to Terraform an existing portgroup
data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.dc.id
}
