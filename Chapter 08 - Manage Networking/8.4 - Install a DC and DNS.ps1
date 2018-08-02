# Recipe 8.4 - Installing Domain Controllers

# This recipe requires first DC1 (as a workgroup system),
# then DC2, a domain joined computer.

#  ON DC1

# 1. Install the AD Domain Services
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# 2. Install This system as the first DC in a new forest.
$PSS = ConvertTo-SecureString  -String 'Pa$$w0rd' -AsPlainText -Force
$ADHT = @{
  DomainName                    = 'Reskit.Org'
  SafeModeAdministratorPassword = $PSS
  InstallDNS                    = $true
  DomainMode                    = 'Win2012R2'
  ForestMode                    = 'Win2012R2'
  Force                         = $true
  NoRebootOnCompletion          = $true
}
Install-ADDSForest @ADHT
Restart-Computer -Force

### Second party of this script - run on DC2

# 1. Check DC1 can be reached oer 556, 389 from DC2
Resolve-DnsName -Name dc1.reskit.org -Server DC1.Reskit.Org -Type A
Test-NetConnection -ComputerName DC1.Reskit.Org -Port 445
Test-NetConnection -ComputerName DC1.Reskit.Org -Port 389

# 2. Add the AD DS features on DC2
$Features = 'AD-Domain-Services, DNS,RSAT-DHCP, Web-Mgmt-Tools'
Install-WindowsFeature -Feature @Features
# Promote DC2 to be a DC in the Reskit.Org domain:
$PSS = ConvertTo-SecureString -String 'Pa$$w0rd' -AsPlainText -Force
$IHT =@{
  DomainName                    = 'Reskit.org'
  SafeModeAdministratorPassword = $PSS
  SiteName                      = 'Default-First-Site-Name'
  NoRebootOnCompletion          = $true
  Force                         =  $true
}
Install-ADDSDomainController @IHT