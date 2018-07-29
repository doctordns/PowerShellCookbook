#  Recipe 16-2  -   Paramaterize DSC Configuratin




# 1. Check status of DNS on SRV2
Get-WindowsFeature DNS -ComputerName SRV2

# 2. Create configuration
Configuration ProvisionServices
{
 param (
  [Parameter(Mandatory=$true)]  $NodeName,
  [Parameter(Mandatory=$true)]  $FeatureName)
  Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
Node $NodeName
  {
  WindowsFeature $FeatureName
    {
       Name                  = $FeatureName
       Ensure                = 'Present'
       IncludeAllSubFeature  = $true
    }
  }
 }

# 3. Ensure an empty DSC folder exists, then create MOF file
New-Item -Path C:\DSC -ItemType Directory `
         -ErrorAction SilentlyContinue | Out-Null
Get-ChildItem -Path C:\DSC | Remove-Item -Force | Out-Null

# 4. Clear any existing Configuration documents on SRV2
Remove-Item '\\SRV2\c$\Windows\System32\configuration\*.mof' `
            -ErrorAction SilentlyContinue

# 5. Now provision DNS on SRV2
ProvisionServices -OutputPath  C:\DSC `
                  -NodeName    SRV2 `
                  -FeatureName DNS

# 6. View MOF File
Get-Content -Path C:\DSC\SRV2.mof

# 7. Do it...
Start-DscConfiguration -Path C:\DSC -Wait -Verbose

# 8. Check results
Get-Service -Name DNS -ComputerName SRV2
