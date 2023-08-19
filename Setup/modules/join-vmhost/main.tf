resource "vsphere_virtual_machine" "vesxi" {
  name             = var.name
  folder           = var.folder
  resource_pool_id = var.resource_pool_id
  datastore_id     = var.datastore_id
  datacenter_id    = var.datacenter_id
  host_system_id   = var.host_system_id
  annotation       = "Deployed for testing purposes only."

  num_cpus             = var.num_cpus
  num_cores_per_socket = var.num_cores_per_socket
  memory               = var.memory
  guest_id             = var.guest_id
  scsi_type            = var.scsi_type
  nested_hv_enabled    = var.nested_hv_enabled

  dynamic "network_interface" {
    for_each = var.ovf_network_map
    content {
      network_id = network_interface.value
    }
  }

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 6

  ovf_deploy {
    allow_unverified_ssl_cert = false
    remote_ovf_url            = var.remote_ovf_url
    disk_provisioning         = var.disk_provisioning
    ovf_network_map           = var.ovf_network_map
  }

  vapp {
    properties = {
      "guestinfo.hostname"   = var.hostname,
      "guestinfo.ipaddress"  = var.ipaddress,
      "guestinfo.netmask"    = "255.255.255.0",
      "guestinfo.gateway"    = "192.168.1.254",
      "guestinfo.dns"        = "192.168.1.22",
      "guestinfo.domain"     = "prob.local",
      "guestinfo.ntp"        = "us.pool.ntp.org",
      "guestinfo.password"   = var.host_password,
      "guestinfo.ssh"        = "True",
      "guestinfo.createvmfs" = "False"
    }
  }

  lifecycle {
    ignore_changes = [vapp[0].properties, ]
  }
}

resource "time_sleep" "wait_vESXi_boot" {
  depends_on = [vsphere_virtual_machine.vesxi]

  create_duration = "5m"
}

data "vsphere_host_thumbprint" "thumbprint" {
  depends_on = [time_sleep.wait_vESXi_boot]

  address  = var.ipaddress
  insecure = true
}

resource "vsphere_host" "vesxi" {
  depends_on = [data.vsphere_host_thumbprint.thumbprint]

  hostname   = var.hostname
  username   = "root"
  password   = var.host_password
  license    = "00000-00000-00000-00000-00000"
  thumbprint = data.vsphere_host_thumbprint.thumbprint.id
  datacenter = var.datacenter_id
}

resource "vsphere_vmfs_datastore" "datastore" {
  name           = "datastore-${var.name}"
  host_system_id = vsphere_host.vesxi.id

  disks = [
    "mpx.vmhba0:C0:T2:L0",
  ]
}
