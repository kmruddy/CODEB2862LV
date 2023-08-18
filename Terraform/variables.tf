variable "vsphere_user" {
  default = "svc_tf@vsphere.local"
  type    = string
}

variable "vsphere_password" {
  default = "Terraform!23"
  type    = string
}

variable "vsphere_server" {
  default = "probvcsa01.prob.local"
  type    = string
}

variable "dc_name" {
  default = "Prob-DC"
  type    = string
}

variable "vmh_name" {
  default = "vesxi00.prob.local"
  type    = string
}

variable "ds_name" {
  default = "nfs-terraform"
  type    = string
}

variable "pg_name" {
  default = "VM Network"
  type    = string
}
