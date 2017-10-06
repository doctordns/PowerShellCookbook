# Recipe 2-1 - Deploying a Nano Server in a VM

# 1. On the VM host, mount Server 2016 installation ISO:
$Server2016ISOPath = 'D:\iso\WinServer2016.iso'
$MountResult = Mount-DiskImage -ImagePath $Server2016ISOPath `
                               -PassThru
$MountResult | Select-Object -Property *


# 2. Determine the drive letter(s) of mounted ISO(s), including the colon (:):
$Server2016InstallationRoot = ($MountResult | 
     Get-Volume |
         Select-object -ExpandProperty Driveletter) + ':'
$Server2016InstallationRoot

# 3. Get the path of the NanoServerImageGenerator module within the server
#    installation disk:
$NanoServerFolder = Join-Path -Path $Server2016InstallationRoot `
                              -ChildPath 'NanoServer'
$NsigFolder = Join-Path -Path $NanoServerFolder `
                        -ChildPath 'NanoServerImageGenerator'
                        
# 4. Review the contents of the NanoServerImageGenerator module folder:
$NsigFolder
Get-ChildItem -Path $NsigFolder -Recurse

# 5. Import the NanoServerImageGenerator module and review the commands it
#    contains:
Import-Module -Name $NsigFolder
Get-Command -Module NanoServerImageGenerator

# 6. Designate the folder for the base Nano Server images:
$NanoBaseFolder = 'D:\NanoBase'

7. Designate the folder for the VM images:
$VMFolder = 'D:\VMs'

# 8. Define the Nano Server computer name and file paths for your Nano Server VM:
$NanoComputerName = 'NANO1'
$NanoVMFolder = Join-Path -Path $VMFolder `
                          -ChildPath $NanoComputerName
$NanoVMPath   = Join-Path -Path $NanoVMFolder `
                          -ChildPath "$NanoComputerName.vhdx"

# 9. Create a Nano Server VM image, as a guest VM within Hyper-V and prompt for
#    the administrator password:
New-NanoServerImage -DeploymentType Guest -Edition Datacenter `
                    -MediaPath    $Server2016InstallationRoot `
                    -BasePath     $NanoBaseFolder `
                    -TargetPath   $NanoVMPath `
                    -ComputerName $NanoComputerName

# 10. Define a VM switch for your Nano Server:
$SwitchName = Get-VMSwitch |
                 Select-Object -ExpandProperty Name -First 1

# 11. Create a new VM in Hyper-V using the Nano Server VM image:
New-VM -VHDPath $NanoVMPath `
       -Name $NanoComputerName `
       -Path $NanoVMFolder `
       -SwitchName $SwitchName `
       -Generation 2 `
       -Verbose

# 12. Start your new Nano Server VM:
Start-VM -Name $NanoComputerName -Verbose
