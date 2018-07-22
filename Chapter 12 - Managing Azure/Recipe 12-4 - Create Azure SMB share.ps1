# Recipe 12-4 -  Create an Azure SMB Share

# 1.  Define Variables
$Locname    = 'uksouth'      # location name
$RgName     = 'packt_rg'     # resource group we are using
$SAName     = 'packt100sa'   # Storage account name
$ShareName  = 'packtshare'   # must be lower case!

# 2. Login to your Azure Account and ensure the RG and SA is created.
Login-AzureRmAccount 
$RG = Get-AzureRmResourceGroup -Name $rgname `
                               -ErrorAction SilentlyContinue
if (-not $RG) {
    $RGTag = [Ordered] @{Publisher = 'Packt'}
    $RGTag += @{Author = 'Thomas Lee'}
    $RG = New-AzureRmResourceGroup -Name $RgName `
        -Location $Locname -Tag $RGTag
    "RG $RgName created"
}
$SAHT = @{
    Name              = $SAName
    ResourceGroupName = $RgName
    ErrorAction       = 'SilentlyContinue'

}
$SA = Get-AzureRmStorageAccount @SAHT
if (-not $SA) {
  $SATag  = [Ordered] @{Publisher='Packt'}
  $SATag +=           @{Author='Thomas Lee'}
  $SAHT2 = {
    Name              = $SAName
    ResourceGroupName = $RgName `
    Location          = $Locname
    Tag               = $SATag
    SkuName           = 'Standard_LRS'
  }
  $SA = New-AzureRmStorageAccount @SAHT2
  "SA $SAName created"
}

# 3. Get Storage key and context:
$SAKHT = @{
  Name              = $SAName
  ResourceGroupName = $RgName
}
$Sak = Get-AzureRmStorageAccountKey @SAKHT
$Key = ($Sak | Select-Object -First 1).Value
$SCHT = @{
   StorageAccountName = $SAName
   StorageAccountKey  = $Key
}
$SACon = New-AzureStorageContext @SCHT

# 4. Add credentials to local store:
cmdkey /add:$SAName.file.core.windows.net /user:$SAName /pass:$Key

# 5. Create a share:
New-AzureStorageShare -Name $ShareName -Context $SACon

# 6. Ensure Z: is not in use then mount the share as Z:
$Mount = 'Z:'
Get-Smbmapping -LocalPath $Mount -ErrorAction SilentlyContinue |
     Remove-Smbmapping -Force -ErrorAction SilentlyContinue
$Rshare = "\\$SaName.file.core.windows.net\$ShareName"
New-SmbMapping -LocalPath $Mount -RemotePath $Rshare `
               -UserName $SAName -Password $Key

# 7. View the share:
Get-AzureStorageShare -Context $SACon  |
    Format-List -Property *

# 8. View local SMB mappings:
Get-SmbMapping

# 9. Now use the new share - create a file in the share:
New-Item -Path z:\foo -ItemType Directory
'Recipe 12-4' | Out-File -FilePath z:\foo\recipe.txt

# 10. Retrievie details about the share contents:
Get-ChildItem -Path z:\ -Recurse |
    Format-Table -Property FullName, Mode, Length

# 11. Get the content from the file:
Get-Content -Path z:\foo\recipe.txt