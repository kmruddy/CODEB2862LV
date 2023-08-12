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

data "vsphere_datastore" "ds" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "dev" {
  name          = "${var.vsphere_cluster}/Resources/${var.vsphere_rp}"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "net" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_host" "host" {
  name          = var.vsphere_host
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_folder" "vmfolder" {
  path          = var.folder_name
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_ovf_vm_template" "ovfRemoteEsxi" {
  name              = "esxi70ga"
  disk_provisioning = "thin"
  resource_pool_id  = data.vsphere_resource_pool.dev.id
  datastore_id      = data.vsphere_datastore.ds.id
  host_system_id    = data.vsphere_host.host.id
  remote_ovf_url    = var.ovf_url
  ovf_network_map = {
    "VM Network" : data.vsphere_network.net.id
  }
}

module "join-vmhost" {
  source = "./modules/join-vmhost"

  count = var.host_count

  name                 = "vesxi0${count.index}"
  ipaddress            = "192.168.1.9${count.index}"
  hostname             = "vesxi0${count.index}.${var.domain}"
  folder               = vsphere_folder.vmfolder.path
  resource_pool_id     = data.vsphere_resource_pool.dev.id
  datastore_id         = data.vsphere_datastore.ds.id
  datacenter_id        = data.vsphere_datacenter.dc.id
  host_system_id       = data.vsphere_host.host.id
  num_cpus             = data.vsphere_ovf_vm_template.ovfRemoteEsxi.num_cpus
  num_cores_per_socket = data.vsphere_ovf_vm_template.ovfRemoteEsxi.num_cores_per_socket
  memory               = data.vsphere_ovf_vm_template.ovfRemoteEsxi.memory
  guest_id             = data.vsphere_ovf_vm_template.ovfRemoteEsxi.guest_id
  scsi_type            = data.vsphere_ovf_vm_template.ovfRemoteEsxi.scsi_type
  nested_hv_enabled    = data.vsphere_ovf_vm_template.ovfRemoteEsxi.nested_hv_enabled
  ovf_network_map      = data.vsphere_ovf_vm_template.ovfRemoteEsxi.ovf_network_map
  remote_ovf_url       = data.vsphere_ovf_vm_template.ovfRemoteEsxi.remote_ovf_url
  disk_provisioning    = data.vsphere_ovf_vm_template.ovfRemoteEsxi.disk_provisioning
}

resource "vsphere_nas_datastore" "datastore" {
  name            = var.nfs_name
  host_system_ids = module.join-vmhost[*].esx_id

  type         = "NFS"
  remote_hosts = [var.nfs_host]
  remote_path  = var.nfs_path
}
