Param(
	[string]$identifiercert,
	[string]$AGResourceGroupName,
	[string]$AGName
)

$datedeletecert=((Get-Date).AddMonths(-2)).ToString("yyyyMMdd")
$id=[System.String]::Concat($identifiercert,".",$datedeletecert)
echo $id

# Ensures that no login info is saved after the runbook is done
Disable-AzContextAutosave 

# Log in as the service principal from the Runbook
$connection = Get-AutomationConnection -Name AzureRunAsConnection
Login-AzAccount -ServicePrincipal -Tenant $connection.TenantID -ApplicationId $connection.ApplicationID -CertificateThumbprint $connection.CertificateThumbprint
### APPLICATION GATEWAY DELETE CERTIFICATE ###
$appgw = Get-AzApplicationGateway -ResourceGroupName $AGResourceGroupName -Name $AGName
Remove-AzApplicationGatewaySslCertificate -ApplicationGateway $AppGW -Name "$id"
Set-AzApplicationGateway -ApplicationGateway $appgw
