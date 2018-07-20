#  Recipe 10-1  Install/configure IIS
#  Run from SRV1


# 1. Add Web Server feature
$FHT = @{
    Name                  = 'Web-Server'
    IncludeAllSubFeature   = $true
    IncludeManagementTools = $true
}
Install-WindowsFeature  @FHT

# 2. See what actual features are installed
Get-WindowsFeature -Name Web*  | Where-Object Installed

# 3. Check the WebAdministration module
Get-Module -Name WebAdministration -ListAvailable
Get-Command -Module webadministration |
    Measure-Object |
        Select-Object -Property Count

# 4. Check the IIS Administration module
Get-Module -Name IISAdministration
Get-Command -Module IISAdministration |
    Measure-Object |
        Select-Object -Property Count

# 5. Look at the newly added provider
Import-Module -Name WebAdministration

# 6.
Get-PSProvider -PSProvider WebAdministration

# 7. What is in the IIS:
Get-ChildItem -Path IIS:\

# 8. What is in sites folder?
Get-Childitem -Path IIS:\Sites

# 9. Look at the default web site:
$IE  = New-Object -ComObject InterNetExplorer.Application
$URL = 'http://srv1'
$IE.Navigate2($URL)
$IE.Visible = $true
