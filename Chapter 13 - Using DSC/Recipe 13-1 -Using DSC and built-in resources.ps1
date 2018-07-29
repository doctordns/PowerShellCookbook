#  Recipe 13-1 - Using DSC and built-in resources
#  Run on SRV1

# 0. Create initial documents for Reskit application
     Also share the application on DC1
 $p1 = @"
<!DOCTYPE html>
<html>
<head><title>Main Page - ReskitApp Application</title></head>
<body><p><center>
<b>HOME PAGE FOR RESKITAPP APPLICATION</b></p>
<hr></body></html>
"@
$p1 | out-file -FilePath \\dc1.reskit.org\c$\reskitapp\page1.htm
$p2 = @"
This is the root page of the RESKITAPP application<b>
Pushed via DSC</p><br><hr>
<a href="http://srv2/reskitapp/page2.htm">
Click to View Page 2</a>
</center>
<br><hr></body></html>
"@
$p2 | out-file -FilePath \\dc1.reskit.org\c$\reskitapp\page2.htm
# 
New-SmbShare -Name ReskitApp -Path C:\reskitapp -ComputerName DC1

###  Start of main script

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


# 7.  Run function to produce MOF file
PrepareSRV2 -OutputPath c:\dsc

# 8. View MOF File
Get-Content C:\DSC\SRV2.mof

# 9. Make it so Mr Riker
Start-DscConfiguration -Path C:\dsc\ -Wait -Verbose

# 10. Observe results
Invoke-Command -Computer SRV2 -ScriptBlock {Get-Childitem C:\reskitapp}

#  11. Induce configuration drift:

$SB = {  Remove-Item -Path C:\ReskitApp\Index.htm
         Get-Childitem -Path C:\ReskitApp }
Invoke-Command -Computer SRV2 -ScriptBlock $SB

# 12. Fix configuration drift
Start-DscConfiguration -Path C:\dsc\ -Wait -Verbose

# 13. What happens if NO config drift?
Start-DscConfiguration -Path C:\dsc\ -Wait -Verbose