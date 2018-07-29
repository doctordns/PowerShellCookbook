#    RECIPE 15-5  
# Install IIS and more 
# Installs some files, adds asp.net and IIS,
# Run on Srv1

# Define configuration block
   
Configuration  IISSRV1
{
  Import-DscResource -Module xWebAdministration
  Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
   Node SRV1
    {
        Windowsfeature IISSrv1
            { Ensure='Present' 
              Name = 'Web-Server'
            }
            
            Windowsfeature IISSrvtools
            { Ensure='Present' 
              Name = 'Web-Mgmt-Tools'
              DependsOn       = "[WindowsFeature]IISSrv1"
            } 
            
            Windowsfeature Scripttools
            { Ensure='Present' 
              Name = 'Web-Scripting-Tools'
              DependsOn       = "[WindowsFeature]IISSrv1"
            }
  
            File   IISFIles
            { Ensure          = 'Present'
              Sourcepath      = '\\dc1\reskitapp\'
              Type            = 'Directory'
              Recurse         = $true
              DestinationPath = 'c:\inetpub\wwwroot\ReskitApp\'    
              DependsOn       = "[WindowsFeature]Scripttools"
            }

# Application pool
           xWebAppPool ReskitApp
           {
            Name    = 'RKAppPool'
            Ensure  = 'Present'
            State   = 'Started'
            DependsOn = '[File]IisFiles'
          }
            
# Web application
           xWebApplication ReskitApp
            {
             Website      = 'Default Web Site'
             WebAppPool   = 'RKAppPool'
             Name         = 'ReskitApp '
             PhysicalPath = 'c:\inetpub\wwwroot\reskitapp'
             Ensure       = 'Present'
             DependsOn    = '[xWebAppPool]ReskitApp'
            } 
            
            
       Log Completed 
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = 'Finished running the DSC2b.ps1 DSC Configuration on DC1'
        }         
 
}
}


# Run the configuration block
IISSRV1 -OutputPath C:\foo\IISSRV1 -VERBOSE

# Now Make it so


Start-DscConfiguration -Path c:\foo\IISSRV1  -Verbose -Wait
