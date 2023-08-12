output "vm_count" {
  value       = length(vsphere_virtual_machine.myApp)
  description = "Number of virutal machines deployed"
}

output "vm_name" {
  value = [
    for vm in vsphere_virtual_machine.myApp : vm.name
  ]
  description = "Virtual machine names."
}

output "cluster_drs_status" {
  value       = vsphere_compute_cluster.compute_cluster.drs_enabled
  description = "Check to see if DRS is enabled."
}
