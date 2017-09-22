# Recipe 10-7 - Create DHCP Scope and Options

# 1. Create a Scope
Add-DhcpServerV4Scope -Name 'Reskit' `
                      -StartRange   10.10.10.150 `
                      -EndRange     10.10.10.199 `
                      -SubnetMask   255.255.255.0 `
                      -ComputerName DC1.Reskit.Org

# 2. Get Scopes from the server
Get-DhcpServerv4Scope -ComputerName DC1.Reskit.Org


# 3. Set Option Values
Set-DhcpServerV4OptionValue -DnsDomain Reskit.Org `
                            -DnsServer 10.10.10.10 

# 4. Get options set
Get-DhcpServerv4OptionValue -ComputerName DC1.Reskit.Org
