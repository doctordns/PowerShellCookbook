# Recipe 12 - Create an Azure Web App

# 1.  Define Variables
$Locname    = 'uksouth'     # location name
$RgName     = 'packt_rg'    # resource group we are using
$AppSrvName = 'packt100'
$AppName    = 'packt100'
$Locname    = 'uksouth'

# 2. Login to your Azure Account and ensure the RG and SA is created.
Login-AzureRmAccount
$RGHT1 = @{
      Name        = $RgName
      ErrorAction = 'Silentlycontinue'
}
$RG = Get-AzureRmResourceGroup @RGHT1
if (-not $RG) {
  $RGTag  = [Ordered] @{Publisher='Packt'}
  $RGTag +=           @{Author='Thomas Lee'}
  $RGHT2 = @{
    Name     = $RgName
    Location = $Locname
    Tag      = $RGTag
  }
  $RG = New-AzureRmResourceGroup @RGHT2
  Write-Host "RG $RgName created"
}
$SA = Get-AzureRmStorageAccount -Name $SAName -ResourceGroupName $RgName -ErrorAction SilentlyContinue
if (-not $SA) {
  $SATag  = [Ordered] @{Publisher='Packt'}
  $SATag +=           @{Author='Thomas Lee'}
  $SAHT = @{
    Name              = $SAName
    ResourceGroupName = $RgName
    Location          = $Locname
    Tag               = $SATag
    SkuName           = 'Standard_LRS'
  }
  $SA = New-AzureRmStorageAccount @SAHT
  "SA $SAName created"
}

# 3. Create app service plan
$SPHT = @{
     ResourceGroupName   = $RgName
     Name                = $AppSrvName
     Location            = $Locname
     Tier               =  'Free'
}

New-AzureRmAppServicePlan @SPHT |  Out-Null

# 4. View the service plan
Get-AzureRmAppServicePlan -ResourceGroupName $RGname -Name $AppSrvName

# 5. Create the new azure webapp
New-AzureRmWebApp -ResourceGroupName $RgName -Name $AppSrvName `
                  -AppServicePlan $AppSrvName -Location $Locname |
                      Out-Null

# 6. View application details
$WebApp = Get-AzureRmWebApp -ResourceGroupName $RgName -Name $AppSrvName
$WebApp

# 7 Now see the web site
$SiteUrl = "https://$($WebApp.DefaultHostName)"
$IE  = New-Object -ComObject InterNetExplorer.Application
$IE.Navigate2($SiteUrl)
$IE.Visible = $true

# 8.  Get publishing profile XML and extract FTP upload details
$x = [xml] (Get-AzureRmWebAppPublishingProfile `
                         -ResourceGroupName $RgName `
                         -Name $AppSrvName  `
                         -OutputFile c:\pdata.txt)
$x.publishData.publishProfile[1]

# 9. Extract crededentials and site details
$UserName = $x.publishData.publishProfile[1].userName
$UserPwd  = $x.publishData.publishProfile[1].userPWD
$Site     = $x.publishData.publishProfile[1].publishUrl

# 10. Create ftp client:
$Ftp             = [System.Net.FtpWebRequest]::Create("$Site/Index.Html")
$Ftp.Method      = [System.Net.WebRequestMethods+Ftp]::UploadFile
$FTPHT = @{
    ArgumentList = '$UserName, $UserPwd'
}
$Ftp.Credentials = New-Object System.Net.NetworkCredential -@FTPHT
$Ftp.UseBinary = $true
$Ftp.UsePassive = $true

# 11. Get the content of the file to upload as a byte array
$Filename = 'C:\Index.htm'
$Content = [System.IO.File]::ReadAllBytes($fileName)
$Ftp.ContentLength = $Content.Length

# 12. Get the ftp request stream and write the file to the web site
$Stream = $Ftp.GetRequestStream()
$Stream.Write($Content, 0, $Content.Length)

# 13. Close the connection and dispose of the stream object
$Stream.Close()
$Stream.Dispose()

# 14. NOW look at the site!
$SiteUrl = "https://$($WebApp.DefaultHostName)"
$IE = New-Object -ComObject InterNetExplorer.Application
$IE.Navigate2($SiteUrl)
$IE.Visible = $true
