#  Recipe 16-9 DSC Reporting
#  Bonus recipe - not tested - Caveat Emptor
# 


#    Recipe 16-8  Partial Configuration
#

# 1. Create a meta configuration to make SRV2 pull from SRV1 and use the report server

[DSCLocalConfigurationManager()]
Configuration SRV2WebPullPartialReport {
Node Srv2 {
  Settings
      {  RefreshMode          = 'Pull'
         ConfigurationModeFrequencyMins = 30
         ConfigurationMode    = 'ApplyandAutoCorrect'
         RefreshFrequencyMins = 30 
         RebootNodeIfNeeded   = $true 
         AllowModuleOverwrite = $true }
  ConfigurationRepositoryWeb DSCPullSrv
     {   ServerURL = 'https://SRV1:8080/PSDSCPullServer.svc'
         RegistrationKey = '5d79ee6e-0420-4c98-9cc3-9f696901a816'
         ConfigurationNames = @('TelnetConfig','TFTPConfig')  }
  PartialConfiguration TelnetConfig
     {  Description = 'Telnet Client Configuration'
        Configurationsource = @('[ConfigurationRepositoryWeb]DSCPullSrv')}
  PartialConfiguration TFTPConfig {
        Description = 'TFTP Client Configuration'
        Configurationsource = @('[ConfigurationRepositoryWeb]DSCPullSrv')
        DependsOn   = '[PartialConfiguration]TelnetConfig'}
  ReportServerWeb SRV2Report {
        ServerURL       = 'https://SRV1:8080/PSDSCPUllServer.svc'
        RegistrationKey = '5d79ee6e-0420-4c98-9cc3-9f696901a816'
  }
  } 
}

# 2. Create MOF to config DSC LCM on SRV2
Remove-Item '\\SRV2\C$\Windows\System32\Configuration\*.mof'
SRV2WebPullPartialReport -OutputPath C:\DSC | Out-Null

# 3.  Config LCM on SRV2:
$CSSrv2 = New-CimSession -ComputerName SRV2
Set-DscLocalConfigurationManager -CimSession $CSSrv2 `
                                 -Path C:\DSC `
                                 -Verbose

# 4.  Update it on SRV2
Test-DSCConfiguration -ComputerName SRV2

# 5. Induce configuration drift
Remove-WindowsFeature -Name tftp-client, telnet-client -ComputerName SRV2
Test-DscConfiguration -ComputerName SRV2

# 6. Fix
Start-DscConfiguration -UseExisting -Verbose -Wait -ComputerName SRV2

# 7. Test
Get-WindowsFeature -Name Telnet-Client, TFTP-Client -ComputerName SRV2

# 8. Define a reporting function
function Get-DSCReport {
param($AgentId = "$((Get-DscLocalConfigurationManager).AgentId)", 
      $ServiceURL = "https://SRV1:8080/PSDSCPullServer.svc",
      $RequestUri = "$ServiceURL/Nodes(AgentId= '$AgentId')/Reports")

$Request = Invoke-WebRequest -Uri $RequestUri  `
                             -ContentType 'application/json;odata=minimalmetadata;streaming=true;charset=utf-8' `
                             -UseBasicParsing `
                             -Headers @{Accept = 'application/json';ProtocolVersion = '2.0'} `
                             -ErrorAction SilentlyContinue                             
$Report = ConvertFrom-Json $Request.Content
return $Report.value
}
$AllProtocols = [System.Net.SecurityProtocolType]'Ssl3,Tls,Tls11,Tls12'
[System.Net.ServicePointManager]::SecurityProtocol = $AllProtocols


$CS = New-CimSession -ComputerName SRV2
$AgentId = (Get-DscLocalConfigurationManager -CimSession $CS).AgentId
Get-DSCReport -AgentId $AgentId
