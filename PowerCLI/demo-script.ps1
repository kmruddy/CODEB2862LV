# Connect to a given vCenter server 
Connect-VIServer -Server "probvcsa01.prob.local" -User "svc_tf@prob.local" -Password "Terraform!23"

# Get information back about a given datacenter 
Get-Datacenter -Name "Prob-DC"