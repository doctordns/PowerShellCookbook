# Recipe 4-7
# Set printer security

# 1. Define the user to be given access to this printerr
#    and get the user's details from AD 

$GroupName = 'Sales Group'
$Group = New-Object Security.Principal.NTAccount $GroupName

# 2. Now get the user's SID
$GroupSid = $Group.Translate([security.principal.securityidentifier]).Value


# 3. Now define the SDDL that will give this user access to the printer
$SDDL = 'O:BAG:DUD:PAI(A;OICI;FA;;;DA)'+
        "(A;OICI;0x3D8F8;;;$GroupSid)"

# 4. Display them:
'Group Name         : {0}' -f $GroupName
'Group SID          : {0}' -f $GroupSid
'SDDL               : {0}' -f $SDDL

# 5. Now get the Sales group printer object:
$SGPrinter = Get-Printer -Name "SGCP1"

# 6. Set the permissions:
$SGPrinter | Set-Printer -PermissionSDDL $SDDL


<#
# Creating the OU, Group and add a user to the group
$SB = { New-ADOrganizationalUnit -Name 'Sales' -Path 'DC=Reskit,DC=Org'
        New-ADGroup -Name 'Sales Group' -Path 'OU=Sales,DC=Reskit,DC=Org' -GroupScope DomainLocal
        Add-ADGroupMember -Identity 'Sales Group' -Members 'tfl'}
Invoke-Command -ComputerName DC1 -ScriptBlock $SB
#>


