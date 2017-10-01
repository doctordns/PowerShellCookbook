# Recipe 10-4 Install Domain Controllers.
# This recipe requires first DC1 (as a workgroup system), then DC2, a domain joined
# computer.

#  ON DC1

# 1. Install the AD Domain Services
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

# 2. Instal This system as the first DC in a new forest.
$PasswordSS = ConvertTo-SecureString  -String 'Pa$$w0rd' -AsPlainText -Force
Install-ADDSForest -DomainName Reskit.Org `
                   -SafeModeAdministratorPassword $PasswordSS `
                   -InstallDNS `
                   -DomainMode Win2012R2 -ForestMode Win2012R2 `
                   -Force -NoRebootOnCompletion
Restart-Computer -Force

# After installation the system reboots.

# 3. After the roboot, Logon to the DC and then do the following
Get-ADDomain 
Get-DNSServer -Computer DC1 
Get-DNsServerZone -Computer DC1

# 4. Install a second DC - Logon to DC2, a domain joined sytstem as administrator



#  removal 
Uninstall-ADDSDomainController -LocalAdministratorPassword $PasswordSS -LastDomainControllerInDomain -NoRebootOnCompletion -force -RemoveApplicationPartitions



-LastDomainControllerInDomain