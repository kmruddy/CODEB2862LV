<# Retaining but commenting out prior steps

# Connect to a given vCenter server 
# Using splatting to simplify the inputs for the cmdlet
$vcsaConnection = @{
    Server = "probvcsa01.prob.local"
    User = "svc_pcli@vsphere.local"
    Password = "VMware1!"
}
# Running the cmdlet with associated splatted parameters
Connect-VIServer @vcsaConnection

#>

# Store information back about a given datacenter in a variable
$dc = Get-Datacenter -Name "Prob-DC"

# Output the newly created dc variable
Write-Output -InputObject $dc 

# Alternatively, save some keystrokes
$dc

# Get information back about a given ESXi host 
$vmh02 = Get-VMHost -Name "vesxi02.prob.local"

# Get information back about a given datatore 
$ds = Get-Datastore -Name "datastore-vesxi02"

# Get information back about a given portgroup 
$vmNet = Get-VirtualPortGroup -Name "VM Network"
