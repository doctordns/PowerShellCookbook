# Recipe 10-3

# 1. Get existing IP address information
$IPType    = "IPv4"
$Adapter   = Get-NetAdapter | ? {$_.Status -eq "up"}
$Interface = $Adapter | Get-NetIPInterface -AddressFamily $IPType
$IfIndex   = $Interface.ifIndex
$IfAlias   = $Interface.Interfacealias
Get-NetIPAddress -InterfaceIndex $Ifindex -AddressFamily $IPType

#  2. Set the IP address for DC2
New-NetIPAddress -InterfaceAlias $IfAlias `
                 -PrefixLength   24 `
                 -IPAddress      '10.10.10.11' `
                 -AddressFamily  $IPType 

# 3. Set DNS Server details
Set-DnsClientServerAddress -InterfaceIndex 3 `
            -ServerAddresses 10.10.10.10

#4.  Test new configuration
Get-NetIPAddress -InterfaceIndex $IfIndex
Remove-NetIPaddress -InterfaceIndex 3 -confirm:$false
Test-NetConnection  -ComputerName  DC1 
Resolve-DnsName -Name dc2.reskit.org -Server DC1 | 
    Where Type -eq 'A'



# Remove and set back to start
Remove-NetIPaddress  -InterfaceIndex 3 -Confirm:$false
# and 
$NIC = Get-WMIObject Win32_NetworkAdapterConfiguration `
         | where IPEnabled -eq “TRUE”
$NIC.EnableDHCP()
$NIC.SetDNSServerSearchOrder()
# And finally - remove the address total:
Get-WMIObject Win32_NetworkAdapterConfiguration `
         | where{$_.IPEnabled -eq “TRUE”}
Remove-NetIPaddress -InterfaceIndex 3
$NIC.EnableDHCP()
$NIC.SetDNSServerSearchOrder()
$nic.RenewDHCPLease()