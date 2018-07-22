# Recipe 12-2 - Create Azure Assets
#
#

# 1. Set Key variables:
$Locname    = 'uksouth'     # location name
$RgName     = 'packt_rg'    # resource group we are using
$SAName     = 'packt100sa'  # Storage account name


# 2. Login to your Azure Account
Login-AzureRmAccount 

# 3. Create a resource Group and tag it
$RGTag  = [Ordered] @{Publisher='Packt'}
$RGTag +=           @{Author='Thomas Lee'}
$RGHT = @{
    Name     = $RgName
    Location = $Locname
    Tag      = $RGTag
}
$RG = New-AzureRmResourceGroup -@$RGHT
$RG

# 4 View RG with Tabs
Get-AzureRmResourceGroup -Name $RGName |
    Format-List -Property *

# 5. Create a new Storage Account
New-AzureRmStorageAccount -Name $SAName `
              -SkuName Standard_LRS `
              -ResourceGroupName $RgName -Tag $RGTag `
              -Location $Locname