# Errata - Chapter 2
##### As of :  10/7/2017 11:30:36 AM  
##### Author: <tfl@psp.co.uk> 
##

10/7/2017 11:30:29 AM 
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

### Page 66 - Method 2, Step 3 

This step should read
    
    Invoke-Command -VMName $NanoComputerName `
                   -Credential $Credential `
                   -ScriptBlock { Get-Process }

### Page 66 - Method 2, Step 6 

This step should read:

    Get-ComputerInfo -Property CsName, WindowsEditionId, OSServerLevel, 
                               OSType, OSVersion, WindowsBuildLabEx, 
                               BiosBIOSVersion


### Page 66 - Method 3, Step 2

This step should read:

    Test-WSMan -ComputerName $NanoServerIP

    

    




        