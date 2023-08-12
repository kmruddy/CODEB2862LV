terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.4.1"
    }
  }
}

provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_dc
}

data "vsphere_host" "host" {
  count         = length(local.hosts)
  name          = local.hosts[count.index]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = "NFS_Datastore"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_compute_cluster" "compute_cluster" {
  name                 = "myAppCluster"
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  host_system_ids      = data.vsphere_host.host[*].id
  drs_enabled          = true
  drs_automation_level = "fullyAutomated"
}

resource "vsphere_virtual_machine" "myApp" {
  count            = 2
  name             = "myApp-${count.index}"
  datacenter_id    = data.vsphere_datacenter.datacenter.id
  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = vsphere_compute_cluster.compute_cluster.resource_pool_id
  host_system_id   = data.vsphere_host.host[0].id
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0
  ovf_deploy {
    allow_unverified_ssl_cert = false
    local_ovf_path            = "C:\\Users\\knikolov\\Downloads\\myApp.ova"
    disk_provisioning         = "thin"
    ip_protocol               = "IPV4"
    ip_allocation_policy      = "DHCP"
  }
}

resource "vsphere_compute_cluster_vm_anti_affinity_rule" "vm_anti_affinity_rule" {
  name                = "myAppAntiAffinityRule"
  enabled             = true
  compute_cluster_id  = vsphere_compute_cluster.compute_cluster.id
  virtual_machine_ids = vsphere_virtual_machine.myApp[*].id
}
