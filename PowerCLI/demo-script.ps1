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

# Store information back about a given datacenter in a variable
$dc = Get-Datacenter -Name "Prob-DC"

# Get information back about a given ESXi host 
$vmh02 = Get-VMHost -Name "vesxi02.prob.local"
$vmh03 = Get-VMHost -Name "vesxi03.prob.local"

# Create the vSphere cluster
$clusterSettings = @{
    Name = "PowerCLIDemoCluster"
    Location = $dc
    DRSEnabled = $true
    DRSAutomationLevel = "FullyAutomated"
}
$compute_cluster = New-Cluster @clusterSettings

# Add 2 hosts from prior steps to the new cluster
Move-VMHost –Destination $compute_cluster –VMHost $vmh02, $vmh03

# Modify the cluster by disabling DRS
$compute_cluster | Set-Cluster -DrsEnabled:$false

# Restore DRS configuration to enabled
$compute_cluster | Set-Cluster -DrsEnabled:$true -Confirm:$false

#>

# Deploy a new VM from a provided OVA
$vmParams = @{
    Name = "myAppFromPowerCLI"   
    Source = "../OVA/Tiny_Linux_VM.ova"
    Location = $compute_cluster
    VMhost = $vmh02
    Datastore = $vmh02 | Get-Datastore
}
Import-VApp @vmParams

# Start the newly provisioned VM
Start-VM -VM "myAppFromPowerCLI"
