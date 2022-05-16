Param(
	[string]$Aciinstancename,
	[string]$ResourceGroupName,
	[string]$Recordname,
	[string]$dnsZonename
	
)

# Ensures that no login info is saved after the runbook is done
Disable-AzContextAutosave 

# Log in as the service principal from the Runbook
$connection = Get-AutomationConnection -Name AzureRunAsConnection
Login-AzAccount -ServicePrincipal -Tenant $connection.TenantID -ApplicationId $connection.ApplicationID -CertificateThumbprint $connection.CertificateThumbprint

$ip=(Get-AzContainerGroup -Name $Aciinstancename  -ResourceGroupName $ResourceGroupName ).IPAddressIP 

$RecordSet = New-AzPrivateDnsRecordSet -Overwrite -Name "$Recordname" -RecordType A -ResourceGroupName "$ResourceGroupName" -TTL 10 -ZoneName "$dnsZonename" -PrivateDnsRecords (New-AzPrivateDnsRecordConfig -IPv4Address $ip)



 
