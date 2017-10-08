# Chapter 2/Helper.ps1
# This file contains some code you can run with the ISE from a separate edit window inside the same PS Tab.
# This file creates three credential objects you can use to play around with the nano servers created in this chapter.

$Un1 = "nano1\administrator"
$Pn1 = ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force
$Cn1 = New-Object system.management.automation.PSCredential $un1,$Pn1

$Un2 = "nano2\administrator"
$Pn2 = ConvertTo-SecureString 'Pa$$w0rd' -AsPlainText -Force
$Cn2 = New-Object system.management.automation.PSCredential $un2,$Pn2