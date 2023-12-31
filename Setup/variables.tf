variable "vsphere_user" {
  default = "svc_tf@vsphere.local"
}

variable "vsphere_password" {
  default = "Terraform!23"
}

variable "vsphere_server" {
  default = "probvcsa01.prob.local"
}

variable "vsphere_dc" {
  default = "Prob-DC"
}

variable "vsphere_datastore" {
  default = "probsyn01"
}

variable "vsphere_rp" {
  default = "Home_Lab"
}

variable "vsphere_cluster" {
  default = "Prob-HL"
}

variable "vsphere_host" {
  default = "probesxip01.prob.local"
}

variable "vsphere_network" {
  default = "VM Network"
}

variable "folder_name" {
  default = "VMWExplore"
}

variable "host_count" {
  description = "Amount of intended virtual ESXi hosts."
  default     = 4
}

variable "ovf_url" {
  description = "ESXi OVF URL, defaults to ESXi 7.0 GA"
  default     = "https://download3.vmware.com/software/vmw-tools/nested-esxi/Nested_ESXi7.0_Appliance_Template_v1.ova"
}

variable "domain" {
  default = "prob.local"
}
