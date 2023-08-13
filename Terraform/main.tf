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

# Describe to Terraform an existing datastore
data "vsphere_datastore" "ds" {
  name          = var.ds_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Describe to Terraform an existing portgroup
data "vsphere_network" "network" {
  name          = var.pg_name
  datacenter_id = data.vsphere_datacenter.dc.id
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

# Create a VM from an existing OVA
resource "vsphere_virtual_machine" "myApp" {
  # count will create as many resources as specified by a loop
  count = 2

  name             = "myAppFromTerraform-0${count.index}"
  datacenter_id    = data.vsphere_datacenter.dc.id
  datastore_id     = data.vsphere_datastore.ds.id
  resource_pool_id = vsphere_compute_cluster.compute_cluster.resource_pool_id
  host_system_id   = data.vsphere_host.vmh_one.id
  network_interface {
    network_id = data.vsphere_network.network.id
  }

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "../OVA/Tiny_Linux_VM.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "DHCP"
  }
}

# Create a DRS rule to ensure the VMs from the prior step are separated 
resource "vsphere_compute_cluster_vm_anti_affinity_rule" "antirule_app" {
  name                = "Keep-those-app-VMs-apart-Terraform"
  compute_cluster_id  = vsphere_compute_cluster.compute_cluster.id
  virtual_machine_ids = vsphere_virtual_machine.myApp[*].id

  lifecycle {
    replace_triggered_by = [vsphere_virtual_machine.myApp]
  }
}

# Run the following command, which will result in an error, but still needs to be performed
# terraform destroy --auto-approve

# Manually set the VMHosts to maintenance mode and remove them from the cluster. 
# Once completed, re-run the terraform destroy command 
