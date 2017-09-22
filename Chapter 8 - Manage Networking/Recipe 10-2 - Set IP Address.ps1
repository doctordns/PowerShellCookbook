# Recipe 10-2 - ConfigureIP addressing

# 1 Get existing IP address information
$IPType = "IPv4"
$Adapter = Get-NetAdapter | ? {$_.Status -eq "up"}
$Interface = $Adapter | Get-NetIPInterface -AddressFamily $IPType
$IfIndex = $Interface.ifIndex
$IfAlias = $Interface.Interfacealias
Get-NetIPAddress -InterfaceIndex $Ifindex -AddressFamily $IPType

# 2. Set the IP address for DC2
New-NetIPAddress -InterfaceAlias $IfAlias `
     -PrefixLength    24 `
     -IPAddress      '10.10.10.11' `
     -DefaultGateway '10.10.10.254' `
     -AddressFamily   $IPType

# 3. Set DNS Server details
Set-DnsClientServerAddress -InterfaceIndex 3 `
     ServerAddresses 10.10.10.10

# 4. Test new configuration
Get-NetIPAddress -InterfaceIndex $IfIndex
Test-NetConnection -ComputerName DC1 
Resolve-DnsName -Name dc2.reskit.org -Server DC1 | 
    Where Type -eq 'A'