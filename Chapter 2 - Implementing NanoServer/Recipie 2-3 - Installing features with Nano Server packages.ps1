#  Recipe 2-3 - INstalling featueswith Nano Server packages

# 0. Create Djoin package - Run from Hyper-V VM (HV1)
$DomainJoinBlobPath = 'C:\Nano2.djoin'            
djoin.exe /provision /domain RESKIT /machine NANO2 /savefile $DomainJoinBlobPath
Get-ChildItem -Path $DomainJoinBlobPath

# 1. From your Hyper-V host, view the currently installed package providers:
Get-PackageProvider

# 2. View the available package providers online, noting the NanoServerPackage
#    provider:
Find-PackageProvider | Select-Object -Property Name, Summary |
    Format-Table -AutoSize -Wrap

# 3. Install the NanoServerPackage provider:
Install-PackageProvider -Name NanoServerPackage -Verbose -Force

# 4. View the commands included with the provider:
Get-Command -Module NanoServerPackage

# 5. View the available Nano Server packages:
$NanoPackages = Find-NanoServerPackage |
    Select-Object -Property Name, Description
$NanoPackages | Format-Table -AutoSize -Wrap

# 6. Determine which of the available packages you wish to install, store them as an
#    array in the $Installpackages variable and then display that array:
$InstallPackages = @('Microsoft-NanoServer-Storage-Package',
                     'Microsoft-NanoServer-IIS-Package',
                     'Microsoft-NanoServer-DSC-Package')
$InstallPackages

# 7. Define the path to the Windows Server 2016 installation media:
$Server2016InstallationRoot = 'E:\'


# 8. Define the path of the NanoServerImageGenerator folder:
$NanoServerFolder = Join-Path -Path $Server2016InstallationRoot `
                              -ChildPath 'NanoServer'
$NsigFolder       = Join-Path -Path $NanoServerFolder `
                              -ChildPath 'NanoServerImageGenerator'
$NsigFolder

# 9. Import the NanoServerImageGenerator module and review the commands
#    contained in that module:
Import-Module -Name $NsigFolder
Get-Command -Module NanoServerImageGenerator

# 10. Define the folders for the base Nano Server images and the VM images:
$NanoBaseFolder = 'C:\NanoBase'
$VMFolder = 'C:\VMs'

# 11. Define paths for the Nano Server VM:
$NanoComputerName = 'NANO2'
$NanoVMFolder = Join-Path -Path $VMFolder `
                          -ChildPath $NanoComputerName
$NanoVMPath   = Join-Path -Path $NanoVMFolder `
                          -ChildPath "$NanoComputerName.vhdx"

# 12. Define the networking parameters:
$IPV4Address    = '10.10.10.132'
$IPV4DNS        = '10.10.10.10','10.10.10.11'
$IPV4Gateway    = '10.10.10.254'
$IPV4SubnetMask = '255.255.255.0'

# 13. Build a hash table $NanoServerImageParameters to hold parameters for the
#     New-NanoServerImage cmdlet:
$NanoServerImageParameters = @{
            DeploymentType = 'Guest'
            Edition = 'DataCenter'
            TargetPath = $NanoVMPath
            BasePath = $NanoBaseFolder
            DomainBlobPath = $DomainJoinBlobPath
            Ipv4Address = $IPV4Address
            Ipv4Dns = $IPV4DNS
            Ipv4Gateway = $IPV4Gateway
            IPV4SubnetMask = $IPV4SubnetMask
            Package = $InstallPackages
            InterfaceNameOrIndex = 'Ethernet'
            }

# 14. Create a new Nano Server image, passing in configuration parameters using
#     splatting:
New-NanoServerImage @NanoServerImageParameters

# 15. Once complete, review the VM switches available, and define the Hyper-V switch
#     to use:
Get-VMSwitch | Select-Object -ExpandProperty Name
$SwitchName = 'Internal'

# 16. Create the Nano virtual machine from the newly created VM disk, and start the
#     VM:
New-VM -VHDPath $NanoVMPath `
       -Name $NanoComputerName `
       -Path $NanoVMFolder `
       -SwitchName $SwitchName `
       -Generation 2 `
       -Verbose |
                   Start-VM

# 17. View the result - See IIS home page on Nano2
Start-Process -Filepath "http://$IPV4Address"
   
# 18. Get the services on the two nano servers created with this chapter.
$Cn1 = Get-Credential 'nano1\administrator'    
Invoke-Command -ComputerName 10.10.10.131 `
               -ScriptBlock {Get-Service} `
               -Credential $Cn1 | Measure-Object
$Cn2 = Get-Credential 'nano2\administrator'    
Invoke-Command -ComputerName $IPV4Address `
               -ScriptBlock {Get-Service} `
               -Credential $Cn2 | Measure-Object
