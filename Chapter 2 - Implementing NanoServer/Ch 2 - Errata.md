# Errata - Chapter 2

### Page 60 - Step 5

This step should read:

    Import-Module -Name $NsigFolder
    Get-Command -Module NanoServerImageGenerator

### Page 60 - Step 8

This step should read

    $NanoComputerName = 'NANO1'
    $NanoVMFolder = Join-Path -Path $VMFolder `
                              -ChildPath $NanoComputerName
    $NanoVMPath   = Join-Path -Path $NanoVMFolder `
                              -ChildPath "$NanoComputerName.vhdx"

### Page 60 - Step 9

This step should read
    
    New-NanoServerImage -DeploymentType Guest -Edition Datacenter `
                        -MediaPath $Server2016InstallationRoot `
                        -BasePath $NanoBaseFolder `
                        -TargetPath $NanoVMPath `
                        -ComputerName $NanoComputerName

### Page 61 - Step 11 

This step should read

    New-VM -VHDPath $NanoVMPath `
           -Name $NanoComputerName `
           -Path $NanoVMFolder `
           -SwitchName $SwitchName `
           -Generation 2 `
           -Verbose
    




        