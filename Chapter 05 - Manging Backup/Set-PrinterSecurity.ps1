 # setting printer security

$Username = 'Reskit\tfl'
$User = new-object security.principal.ntaccount $Username

$UserSid = $user.Translate([security.principal.securityidentifier]).Value

$SID

$SDDL = "O:BAG:DUD:PAI(A;OICI;FA;;;DA)(A;OICI;0x3D8F8;;;$UserSid)"
$sddl

$myPrinter = Get-Printer -Name "SGCP1"
#4. Set the permissions:
$myPrinter | Set-Printer -PermissionSDDL $SDDL