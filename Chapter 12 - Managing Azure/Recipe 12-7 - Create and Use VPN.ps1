# Recipe 12-7 - Create and use Azure VPN


# 1.  Define Variables
$Locname = 'uksouth'     # location name
$RgName  = 'packt_rg'    # resource group name
$SAName  = 'packt100_sa' # Storage account name
$NSGName = 'packt_nsg'   # NSG name
$FullNet = '10.10.0.0/16'
$CLNet   = '10.10.2.0/24'
$GWSubnetName = 'GatewaySubnet'
$GWNet   = '192.168.200.0/26'
$GWName    = 'pactvpngw'
$GWIPName = 'gwip'
$DNS     = '8.8.8.8'      # DNS Server to use
$NetworkName = 'PacktVnet'
$GWIPName = 'gwip'
$VPNClientAddressPool = "172.16.201.0/24"

# 2. If necessary
Login-AzureRmAccount

# 3. Create a self signed root ca cert and a user cert
$P2SRootCertFileName = 'C:\PacktCARootCert.cer'
$P2SRootCertName     = 'PacktRootCert'
$Mc = 'C:\Program Files\Microsoft SDKs\Windows\v7.1\Bin\x64\makecert.exe'
& $Mc -sky exchange -r -n "CN=PACKTCA" -pe -a sha1 -len 2048 -ss Root $P2SRootCertFileName
& $Mc -n "CN=VPNUserCert" -pe -sky exchange -m 12 -ss My -in "PACKTCA" -is root -a sha1
$Cert        = New-Object -Typename System.Security.Cryptography.X509Certificates.X509Certificate2 `
                         -ArgumentList $P2sRootCertName
$CertBase64  = [system.convert]::ToBase64String($Cert.RawData)
$P2SRootCert = New-AzureRmVpnClientRootCertificate -Name $P2SRootCertName -PublicCertData $CertBase64

# 4. Create the RMGateway objects
$Vnet   = Get-AzureRmVirtualNetwork -Name $NetworkName -ResourceGroupName $RgName 
$Subnet = Get-AzureRmVirtualNetworkSubnetConfig -Name $GWSubnetName -VirtualNetwork $Vnet
$Pip2   = New-AzureRmPublicIpAddress -Name $GWIPName -ResourceGroupName $RgName `
                                     -Location $Locname -AllocationMethod Dynamic `
                                     -Tag @{Owner='PACKT';Type='IP'}
$IpConf = New-AzureRmVirtualNetworkGatewayIpConfig -Name $GWIPName -Subnet $subnet -PublicIpAddress $Pip2

# 5. Create the Gateway
$Start = Get-Date
New-AzureRmVirtualNetworkGateway -Name $GWName -ResourceGroupName $RgName `
                                 -Location $Locname -IpConfigurations $ipconf `
                                 -GatewayType Vpn -VpnType RouteBased `
                                 -EnableBgp $false -GatewaySku Standard `
                                 -VpnClientAddressPool $VPNClientAddressPool `
                                 -VpnClientRootCertificates $p2srootcert `
                                 -Tag @{Owner='PACKT';Type='Gateway'}
$Finish = Get-Date
"Creating the gateway took $(($Finish-$Start).totalminutes) minutes"


# 6. Get the VPN client package URL
$Urls = Get-AzureRmVpnClientPackage -ResourceGroupName $RGName -VirtualNetworkGatewayName $GWName -ProcessorArchitecture Amd64
$Url  = $urls.SPLIT('"')[1]    

# 7. Get the VPN Package
$wc = New-Object System.Net.WebClient
$wc.DownloadFile($URL,'C:\PacktVPNClient.EXE')
LS C:\PacktVPNClient.EXE 

# 8. Install VPN Package
C:\PacktVPNClient.EXE
