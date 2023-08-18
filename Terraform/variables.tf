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
  default = "vsanDatastore"
}
