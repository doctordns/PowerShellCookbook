#  Local Account Management

Get-LocalUser

$date = (Get-Date).addmonths(6)
$pass = ConvertTo-SecureString -String 'Marin1!' -AsPlainText -Force
New-LocalUser -Name JerryG -AccountExpires $date -Password $pass  -Description Consultant
Get-LocalUser -Name Jerryg | Format-Table name, *Source,*exp*

New-LocalGroup -Name TheBand -Description 'Members of the band'
Add-LocalGroupMember -Group TheBand -Member JerryG
Get-LocalGroupMember -Group TheBand