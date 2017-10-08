# Errata - Chapter 2
##### As of :  10/7/2017 11:30:36 AM  
##### Author: <tfl@psp.co.uk> 
##


## General 
When this chapter was written, Microsoft had positioned Nano Server as a sub-set of Server Core, capable of supporting
various infrastructure roles (IIS, DNS, DHCP, etc). But after this chapter went to press, Microsoft re-focused the
approach to Nano Server. This chapter focuses on how Nano Server used to work (and still does for Windows Server 2016), 
although this changes going forward. 

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



### Page 82 - Step 8

This step should read:

    $NanoServerFolder = Join-Path -Path $Server2016InstallationRoot `
                                  -ChildPath 'NanoServer'
    $NsigFolder       = Join-Path -Path $NanoServerFolder `
                                  -ChildPath 'NanoServerImageGenerator'
    $NsigFolder
    
### Page 82 - Step 11

This step should read:

    $NanoComputerName = 'NANO2'
    $NanoVMFolder = Join-Path -Path $VMFolder `
                              -ChildPath $NanoComputerName
    $NanoVMPath   = Join-Path -Path $NanoVMFolder `
                              -ChildPath "$NanoComputerName.vhdx"

### Page 83 - Step 13

This step should read: 

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
        
### Page 83 - Step 16

This step should read:

    New-VM -VHDPath $NanoVMPath `
       -Name $NanoComputerName `
       -Path $NanoVMFolder `
       -SwitchName $SwitchName `
       -Generation 2 `
       -Verbose |
                  Start-VM 

### Page 83 - Additional Steps

Add the following steps at the end of the printed recipe to view the results of adding
IIS to Nano2:

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
