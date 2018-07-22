# Recipe 12-3 Explore Storage Account

# 1. Define key variables
$Locname    = 'uksouth'         # location name
$RgName     = 'packt_rg'        # resource group we are using
$SAName     = 'packt100sa'      # Storage account name
$CName      = 'packtcontainer' 
$CName2     = 'packtcontainer2' 

# 2. Login to your Azure Account and ensure the RG and SA is created.
Login-AzureRmAccount
$RGHT = @{
    Name  = $RgName
    ErrorAction =  'SilentlyContinue'
}
$RG = Get-AzureRmResourceGroup  @RGHT
if (-not $RG) {
  $RGTag  = [Ordered] @{Publisher='Packt'}
  $RGTag +=           @{Author='Thomas Lee'}
  $RGHT2 = @{
    Name     = $RgName
    Location = $Locname
    Tag      = $RGTag
}
  $RG = New-AzureRmResourceGroup @RGHT2
  "RG $RgName created"
}
$SA = Get-AzureRmStorageAccount -Name $SAName -ResourceGroupName $RgName -ErrorAction SilentlyContinue
if (-not $SA) {
  $SATag  = [Ordered] @{Publisher='Packt'}
  $SATag +=           @{Author='Thomas Lee'}
  $SAHT = @{
    Name               = $SAName
    ResourceGroupName  = $RgName
    Location           = $Locname
    Tag                = $SATag
    SkuName            = 'Standard_LRS'
  }
  $SA = New-AzureRmStorageAccount  @SAHT
  "SA $SAName created"
}


# 3. Get and display the storage account key
$SAKHT = @{
    Name              = $SAName
    ResourceGroupName = $RgName
}
$Sak = Get-AzureRmStorageAccountKey  @SAKHT
$Sak

# 4. Extract the first key's 'password'
$Key = ($Sak | Select-Object -First 1).Value

# 5. Get the Storage Account context (encapsulates credentials for the storage account)
$SCHT = @{
  StorageAccountName = $SAName
  StorageAccountKey  = $Key
}
$SACon = New-AzureStorageContext @SCHT
$SACon

# 6. Create 2 blob containers
New-AzureStorageContainer -Name $CName  -Context $SACon -Permission Blob
New-AzureStorageContainer -Name $CName2 -Context $SACon -Permission Blob


# 7. View blob container
Get-AzureStorageContainer -Context $SACon | 
    Select-Object -ExpandProperty CloudBlobContainer


# 8. Create a blob
'This is a small blob!!' | Out-File .\azurefile.txt
$BHT = @{
  Context   = $SACon
  File      = '.\azurefile.txt'
  Container = $CName}
$Blob = Set-AzureStorageBlobContent  @BHT
$Blob

# 9. Construct and display the blob name
$BlobUrl = "$($Blob.Context.BlobEndPoint)$CName/$($Blob.name)"
$BlobUrl

# 10. view the URL via IE
$IE  = New-Object -ComObject InterNetExplorer.Application
$IE.Navigate2($BlobUrl)
$IE.Visible = $true