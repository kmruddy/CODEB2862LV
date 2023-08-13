# Connect to a given vCenter server 
Connect-VIServer -Server "probvcsa01.prob.local" -User "svc_pcli@prob.local" -Password "VMware1!"

# Get information back about a given datacenter 
Get-Datacenter -Name "Prob-DC"
