#  Recipe 8-5 - Forward event logs from SRV1 to SRV2

# 1. Create the collector security group.
$ECGName = 'Event Collection Group'
New-ADGroup -Name $ECGName -GroupScope Global `
            -Path 'OU=IT,DC=Reskit,DC=Org'
Add-ADGroupMember -Identity $ECGName -Members 'DC1$'

# 2. Get membership
Get-ADGroupMember -Identity $ECGName

# 3. Create a new GPO on DC1 to configure event collection
$sb = {
  $GPOName = 'Event Collection'
  $ECGName = 'Event Collection Group'
  $gpo  = New-GPO -Name $GPOName
  $link = New-GPLink -Name $GPOName `
                     -Target "DC=Reskit,DC=Org"
  $p1 = Set-GPPermission -Name $GPOName `
                   -TargetName "$ECGName" `
                   -TargetType Group `
                   -PermissionLevel GpoApply
  $p2 = Set-GPPermission -Name $GPOName `
                 -TargetName 'Authenticated Users' `
                 -TargetType Group `
                 -PermissionLevel None }
Invoke-Command -ComputerName DC1 -ScriptBlock $sb

# 4. Set GPO Permissions:
Set-GPPermission -Name $GPOName `
                 -TargetName "Authenticated Users" 
                 -TargetType Group `
                 -PermissionLevel None

# 5. Apply the settings to the new GPO:
$WinRMKey="HKLM\Software\Policies\Microsoft\Windows\WinRM\Service"
Set-GPRegistryValue -Name "Event Collector" -Key $WinRMKey `
-ValueName "AllowAutoConfig" -Type DWORD -Value 1
Set-GPRegistryValue -Name "Event Collector" -Key $WinRMKey `
-ValueName "IPv4Filter" -Type STRING -Value "*"
Set-GPRegistryValue -Name "Event Collector" -Key $WinRMKey `
-ValueName "IPv6Filter" -Type STRING -Value "*"
4. Enable and configure Windows Event Collector on the collector system.
echo y | wecutil qc
5. Create the XML file for the subscription, and save the file.
Following is an example of the subscription.xml file used in this example:
<?xml version="1.0" encoding="UTF-8"?>
<Subscription xmlns="http://schemas.microsoft.com/2006/03/windows/
events/subscription">
<SubscriptionId>Collect security</SubscriptionId>
<SubscriptionType>SourceInitiated</SubscriptionType>Troubleshooting Servers with PowerShell
290
<Description></Description>
<Enabled>true</Enabled>
<Uri>http://schemas.microsoft.com/wbem/wsman/1/windows/
EventLog</Uri>
<ConfigurationMode>Normal</ConfigurationMode>
<Query>
<![CDATA[
<QueryList><Query Id="0"><Select Path="Security">*[System[(Level=1
or Level=2 or Level=3)]]</Select></Query></QueryList>
]]>
</Query>
<ReadExistingEvents>false</ReadExistingEvents>
<TransportName>HTTP</TransportName>
<ContentFormat>RenderedText</ContentFormat>
<Locale Language="en-US"/>
<LogFile>ForwardedEvents</LogFile>
<PublisherName>Microsoft-Windows-EventCollector</
PublisherName>
<AllowedSourceNonDomainComputers>
<AllowedIssuerCAList>
</AllowedIssuerCAList>
</AllowedSourceNonDomainComputers>
<AllowedSourceDomainComputers>O:NSG:BAD:P(A;;GA;;;DC)S:</
AllowedSourceDomainComputers>
</Subscription>
A sample XML file can be viewed by executing wecutil cs /?.
You can export an existing subscription to XML by executing
wecutil gs <name> /f:XML.
6. Create a subscription.
wecutil cs subscription.xml
7. Create the source security group.
New-ADGroup -Name "Event Source" -GroupScope Global
Add-ADGroupMember -Identity "Event Source" -Members Server2$Chapter 9
29