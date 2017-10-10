# Recipe 3-1 - Installing WIndows Server Update Services

# 1. Install the Windows Update feature and tools, with -Verbose for additional
#     feedback:
Install-WindowsFeature -Name 'UpdateServices' `
                       -IncludeManagementTools -Verbose

# 2. Review the features that are installed on your server, noting that not only has
#    Windows Software Update Services been installed, but Web Server (IIS),
#    ASP.Net 4.6, and Windows Internal Database have as well:

Get-WindowsFeature |
    Where-Object Installed

# 3. Create a folder for WSUS update content:
$WSUSContentDir = 'C:\WSUS'
If (-Not (Get-ChildItem -Path $WSUSContentDir -ErrorAction SilentlyContinue))
    {New-Item -Path $WSUSContentDir -ItemType Directory}

# 4. Perform post-installation configuration using WsusUtil.exe:
& "$env:ProgramFiles\Update Services\Tools\WsusUtil.exe"  `
    Postinstall CONTENT_DIR=$WSUSContentDir

# 5. Once configuration completes, the output includes a line stating Log file is
#    located at, followed by a path to a .tmp file in the user's temp directory.
#    Review this log file to see what was done in the configuration (adjust the file
#    name as necessary):
#  Note: you must update the path in the following line of code as per the output
#        from step 4.
Get-Content -Path "$env:TEMP\tmp4479.tmp"

# 6. View some websites on this machine, noting the WSUS website:
Get-Website

# 7. View the cmdlets in the UpdateServices module:
Get-Command -Module UpdateServices

# 8. Inspect the TypeName and properties of the object created with GetWsusServer:
$WSUSServer = Get-WsusServer
$WSUSServer.GetType().Fullname
$WSUSServer | Select-Object -Property *

# 9. The object is of type UpdateServer in the
#    Microsoft.UpdateServices.Internal.BaseApi namespace, and is the main
#    object you interact with to manage WSUS from PowerShell. Inspect the methods
#    of the object:
$WSUSServer | Get-Member -MemberType Method


# 10. Inspect some of the configuration values of the UpdateServer object:
$WSUSServer.GetConfiguration() |
    Select-Object -Property SyncFromMicrosoftUpdate,LogFilePath

# 11. Product categories are the various operating systems and programs for which
#     updates are available. See what product categories are included by WSUS after
#     the initial install:
$WSUSProducts = Get-WsusProduct -UpdateServer $WSUSServer
$WSUSProducts.Count
$WSUSProducts

# 12. Your $WSUSServer object contains a subscription object with properties and
#     methods useful for managing the synchronization of updates. Access the
#     Subscription object in the $WSUSServer object and inspect it, noting that it is
#     also in the Microsoft.UpdateServices.Internal.BaseApi namespace:
$WSUSSubscription = $WSUSServer.GetSubscription()
$WSUSSubscription.GetType().Fullname
$WSUSSubscription | Select-Object -Property *
$WSUSSubscription | Get-Member -MemberType Method

# 13. Before you choose which product updates you want, you need to know what
#     product categories are available. Get the latest categories of products available
#     from Microsoft Update servers, and use a while loop to wait for completion and also
#     Synchronize updates
$WSUSSubscription.StartSynchronization()
Do {
     Write-Output $WSUSSubscription.GetSynchronizationProgress()
     Start-Sleep -Seconds 5
   }  
While ($WSUSSubscription.GetSynchronizationStatus() -ne `
                       'NotProcessing')

# 14. Once synchronization is complete, check the results of the synchronization:
$WSUSSubscription.GetLastSynchronizationInfo()

# 15. Again, review the categories of the products available:
$WSUSProducts = Get-WsusProduct -UpdateServer $WSUSServer
$WSUSProducts.Count
$WSUSProducts