# Recipe 8-6 - Configuring zones and resource records in DNS
# Run on DC1

# 0. Getting ready
$PSS = ConvertTo-SecureString -String 'Pa$$w0rd' -AsPlainText -Force
$NewUserHT = @{
    AccountPassword       = $PSS
    Enabled               = $true
    PasswordNeverExpires  = $true
    ChangePasswordAtLogon = $false
    SamAccountName        = DNSADMIN
    UserPrincipalName     = 'DNSADMIN@reskit.org'
    Name                  = 'DNSADMIN'
    DisplayName           = 'Reslkit DNS Admin'
}
New-ADUser @NewUserHT
# Add to Enterprise and Domain Admin groups
$GRPN = 'CN=Enterprise Admins,CN=Users,DC=reskit,DC=org',
         'CN=Domain Admins,CN=Users,DC=reskit,DC=org'
$PMHT = @{
    Identity = 'CN=DNSADMIN,CN=Users,DC=reskit,DC=org'
    MemberOf = $GRPN
}
Add-ADPrincipalGroupMembership @PMHT
# Ensure the user has been added
Get-ADUser -LDAPFilter '(Name=DNSADMIN)'

# Main script starts here

# 1. Create a new primary forward DNS zone
$ZHT = @{
  Name              = 'foo.bar'
  ReplicationScope  = 'Forest'
  DynamicUpdate     = Secure `
  ResponsiblePerson = 'DNSADMIN.reskit.org'
}
Add-DnsServerPrimaryZone @ZHT

# 2. Create a new primary reverse lookup domain (for IPv4), 
#    and view both new DNS zones
Add-DnsServerPrimaryZone
-Name '10.10.10.in-addr.arpa' `
    -ReplicationScope Forest `
    -DynamicUpdate Secure `
    -ResponsiblePerson 'DNSADMIN.reskit.org.'
Get-DNSServerZone
-Name 'foo.bar', '10.10.10.in-addr.arpa'

# 3. Add an A resource record to foo.bar and get results:
Add-DnsServerResourceRecord -ZoneName 'foo.bar' `
    -A `
    -Name home `
    -AllowUpdateAny `
    -IPv4Address '10.42.42.42' `
    -TimeToLive (30 * (24 * 60 * 60))
Get-DnsServerResourceRecord -ZoneName foo.bar `
    -Name 'home'Managing Windows Networking Services
[ 312 ]
4. Add A and Mx resource records to the reskit.org zone and display the results:
Add-DnsServerResourceRecord -ZoneName 'reskit.org' `
    -A `
    -Name 'mail' `
    -CreatePtr `
    -AllowUpdateAny `
    -IPv4Address ' 10.10.10.42' `
    -TimeToLive 21:00:00
Add-DnsServerResourceRecordMX -Preference 10 `
    -Name '.' `
    -TimeToLive (30 * (24 * 60 * 60)) `
    -MailExchange 'mail.reskit.org' `
    -ZoneName 'reskit.org'
Get-DnsServerResourceRecord -ZoneName 'reskit.org' `
    -name '@' `
    -RRType Mx
5. Set up EDNS on the server with a timeout 30 minutes:
Set-DNSServerEDns -CacheTimeout '0:30:00' `
    -Computername DC1 `
    -EnableProbes $true `
    -EnableReception $true
6. Test the DNS service on DC1:
Test-DnsServer -IPAddress 10.10.10.10 `
    -Context DnsServer
