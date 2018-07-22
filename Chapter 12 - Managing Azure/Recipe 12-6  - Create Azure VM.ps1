#  Recipe 12-5 Create new VM

# 1. Define key variables
$Locname  = 'uksouth'          # location name
$RgName   = 'packt_rg'         # resource group name
$SAName   = 'packt100sa'       # Storage account name
$NSGName  = 'packt_nsg'        # NSG name
$FullNet  = '10.10.0.0/16'     # Overall networkrange
$CLNet    = '10.10.2.0/24'     # Our cloud subnet
$GWNet    = '192.168.200.0/26' # Gateway subnet
$DNS      = '8.8.8.8'          # DNS Server to use
$IPName   = 'Packt_IP1'        # Private IP Address name
$VMName   = "Packt100"         # the name of the VM
$CompName = "Packt100"         # the name of the VM's host

#  2. This should not be necessary, but just in case
Login-AzureRmAccount 
$RG = Get-AzureRmResourceGroup -Name $RgName -ErrorAction SilentlyContinue
if (-not $rg) {
    $RGTag  = @{Publisher='Packt'}
    $RGTag += @{Author='Thomas Lee'}
    $RG = New-AzureRmResourceGroup -Name $RgName -Location $Locname -Tag $RGTag
    "RG $RgName created"
}
$SA = Get-AzureRmStorageAccount -Name $SAName -ResourceGroupName $RgName -ErrorAction SilentlyContinue
if (-not $SA) {
    $SATag  = [Ordered] @{Publisher='Packt'}
    $SATag +=           @{Author='Thomas Lee'}
    $SA = New-AzureRmStorageAccount -Name $SAName -ResourceGroupName $RgName -Location $Locname -Tag $SATag -skuname 'Standard_LRS'
    "SA $SAName created"
}
    
# CREATING THE VNET

# 3. Create subnet network config objects
$SubnetName   = 'CloudSubnet1'
$CloudSubnet  = New-AzureRmVirtualNetworkSubnetConfig -Name $SubnetName -AddressPrefix $CLNet
$GWSubnetName = 'GatewaySubnet'
$GWSubnet     = New-AzureRmVirtualNetworkSubnetConfig -Name $GWSubnetName -AddressPrefix $GWNet

# 4. Create the virtual network, and tag it - this can take a while
$VnetName = "PacKtvnet"
$PackVnet = New-AzureRmVirtualNetwork -Name $VnetName -ResourceGroupName $RgName -Location $Locname `
            -AddressPrefix $fullnet,'192.168.0.0/16' -Subnet $CloudSubnet,$GWSubnet -DnsServer $DNS `
            -Tag @{Owner='PACKT';Type='VNET'}

# 5. Create a public IP address and NIC for our VM to use
$PublicIp = New-AzureRmPublicIpAddress -Name $IPName `
                -ResourceGroupName $RgName `
                -Location $Locname -AllocationMethod Dynamic `
                -Tag @{Owner='PACKT';Type='IP'}
$PublicIp | Format-Table `
     -Property Name, IPAddress,ResourceGroup*, Location, *State

# 6. Create the NIC
$NicName = "VMNic1"
$Nic = New-AzureRmNetworkInterface -Name $NicName -ResourceGroupName $RgName `
                                   -Location $Locname `
                                   -SubnetId $Packvnet.Subnets[0].Id `
                                   -PublicIpAddressId $pip.Id `
                                   -Tag @{Owner='PACKT';Type='NIC'}

# 7. Create NSG rule
$NSGRule1 = New-AzureRmNetworkSecurityRuleConfig `
               -Name RDP-In  -Protocol Tcp `
               -Direction Inbound -Priority 1000 `
               -SourceAddressPrefix *  -SourcePortRange * `
               -DestinationAddressPrefix * -DestinationPortRange 3389 `
               -Access Allow

# 8. Create an NSG
$PacktNSG = New-AzureRmNetworkSecurityGroup `
               -ResourceGroupName $RgName `
               -Location $Locname `
               -Name $NSGName `
               -SecurityRules $NSGRule1

# 9. Configure subnet
Set-AzureRmVirtualNetworkSubnetConfig `
    -Name $SubnetName `
    -VirtualNetwork $PackVnet `
    -NetworkSecurityGroup $PacktNSG `
    -AddressPrefix $CLNet | Out-Null

# 10 Set the Azure virtual netowrk based on prior configuration steps:
Set-AzureRmVirtualNetwork -VirtualNetwork $PackVnet | Out-Null

# 11. create VM Configuration object 
$VM = New-AzureRmVMConfig -VMName $VMName -VMSize 'Standard_A1'
$VM 

# 12. Create credential for VM Admin
$VMUser = 'tfl'
$VMPass = ConvertTo-SecureString 'J3rryisG0d!!'-AsPlainText -Force 
$VMCred = New-Object System.Management.automation.PSCredential `
                -ArgumentList $VMUser, $VMPass

# 13. Set OS information for the VM
$VM = Set-AzureRmVMOperatingSystem -VM $VM `
                     -Windows -ComputerName $CompName `
                     -Credential $VMCred `
                     -ProvisionVMAgent -EnableAutoUpdate
$VM

# 14. Determine which image to use and get the offer
$Publisher = 'MicrosoftWindowsServer'
$OfferName = 'WindowsServer'
$Offer  = Get-AzureRmVMImageoffer -Location $Locname -PublisherName $Publisher | 
              Where-Object Offer -eq $Offername

# 15. Then get the SKU/Image
$SkuName = '2016-Datacenter'
$SKU    = Get-AzureRMVMImageSku -Location $Locname `
                                -Publisher $Publisher `
                                -Offer $Offer.Offer |
              Where-Object Skus -eq $SkuName
$VM     = Set-AzureRmVMSourceImage -VM $VM -PublisherName $publisher `
                                   -Offer $Offer.offer `
                                   -Skus $sku.Skus  -Version "latest"
$VM

# 16. Add the nic to the vm config object
$VM = Add-AzureRmVMNetworkInterface -VM $VM -Id $Nic.Id

# 17. Identify the page blob to hold the VMDisk
$StorageAcc = Get-AzureRmStorageAccount -ResourceGroupName $RgName -Name $SAName
$BlobPath  = "vhds/Packt100.vhd"
$OsDiskUri = $storageAcc.PrimaryEndpoints.Blob.ToString() + $BlobPath
$DiskName  = 'PacktOsDisk'
$VM        = Set-AzureRmVMOSDisk -VM $VM -Name $DiskName -VhdUri $OsDiskUri -CreateOption FromImage
$VM

# 18. And finally Create the VM - this can take some time to provision
$s = Get-Date
$VM     = New-AzureRmVM -ResourceGroupName $RgName -Location $Locname `
                        -VM $VM -Tag @{Owner='Packt'}
$e = Get-Date
"VM creation too [{0}] seconds" -f $(($e-$s).totalseconds)

# 19. Now get the Public IP address...
$VMPublicIP = Get-AzureRmPublicIpAddress -Name $IPName -ResourceGroupName $RgName

# 20. Open a RDP session on our new VM:
$IPAddress = $VMPublicIP.IpAddress
mstsc /v:$ipaddress /w:1024 /h:768

# 21. Once the RDP client opens, logon using
#  Userid:   pact100\tfl
#  Password: J3rryisG0d!!




#  If you want to use WSMAN by IP...

# 20. Set trusted path to allow connections by IP to our new host
Set-Item WSMan:\localhost\Client\TrustedHosts  "$($ip.IpAddress)" -Force




