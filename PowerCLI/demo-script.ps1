<# Retaining but commenting out prior steps

# Connect to a given vCenter server 
Connect-VIServer -Server "probvcsa01.prob.local" -User "svc_pcli@vsphere.local" -Password "VMware1!"

# Get information back about a given datacenter 
Get-Datacenter -Name "Prob-DC"

#>

# Get information back about a given ESXi host 
Get-VMHost -Name "vesxi02.prob.local"

# Get information back about a given ESXi host from a given datacenter
Get-VMHost -Name "vesxi02.prob.local" -Location "Prob-DC"

# Alternatively 
Get-Datacenter -Name "Prob-DC" | Get-VMHost -Name "vesxi02.prob.local"

# Get information back about a given datatore 
Get-Datastore -Name "datastore-vesxi02"

# Get information back about a given portgroup 
Get-VirtualPortGroup -Name "VM Network"
