#  Recipe 13-1 - Using DSC and built-in resources
#  Run on SRV1

# 1. Discover resources on SRV1
Get-DscResource

# 2. Look at File Resource
Get-DscResource -Name File | Format-List -property *

# 3 Get DSC Resource Syntax
Get-DscResource -Name File -Syntax


 # 4. Create/compile a configuration block
 #    FOR: SRV2
 #    WHAT:  Windows Feature - Web-Server present
 #           File \\srv1\reskitapp moves to \\srv2\c$\reskitapp

 Configuration PrepareSRV2
 {
   Import-DscResource –ModuleName 'PSDesiredStateConfiguration'
   Node SRV2
  {
    File  BaseFiles
    {
       DestinationPath = 'C:\ReskitApp\'
       SourcePath      = '\\DC1\ReskitApp\'
       Ensure          = 'Present'
       Recurse         = $True
    }
  }
 }

# 5. View configuration
Get-Item Function:\PrepareSRV2

#    STEP 6 - Create output folder for MOF file
$Conf = {
          New-Item -Path C:\ReskitApp -ItemType Directory `
                  -ErrorAction SilentlyContinue
        }
Invoke-command -ComputerName SRV2 -ScriptBlock $Conf


# STEP 7.  Run function to produce MOF file
PrepareSRV2 -OutputPath c:\dsc

#    STEP 8 - VIEW MOF File
Get-Content C:\DSC\SRV2.mof

#    STEP 9 - Make it so
Start-DscConfiguration -Path C:\dsc\ -Wait -Verbose

#    Step 10 - observe results
Invoke-Command -Computer SRV2 -ScriptBlock {Get-Childitem C:\reskitapp}

#    STEP 11 - Induce configuration drift:

$SB = {  Remove-Item -Path C:\ReskitApp\Index.htm
         Get-Childitem -Path C:\ReskitApp }
Invoke-Command -Computer SRV2 -ScriptBlock $SB

#    step 12 - Fix configuration drift
Start-DscConfiguration -Path C:\dsc\ -Wait -Verbose

#    Step 13 - What happens if NO config drift?
Start-DscConfiguration -Path C:\dsc\ -Wait -Verbose