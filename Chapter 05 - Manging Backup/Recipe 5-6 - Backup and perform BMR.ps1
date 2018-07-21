# Recipe 5-6 - Backup and perform bare metal recovery

# 1. Ensure you have Windows-Server-Backup installed on FS1:
Install-WindowsFeature -Name Windows-Server-Backup

# 2. Setup backup policy, create a backup share, and take a backup with the backup
file stored on a newly created network share:
# Remove any old policy
If (Get-WBPolicy) {Remove-WBPolicy -All -Force}
# Create new policy
$FullBUPol = New-WBPolicy
$Schedule = '06:00'
# Set schedule
Set-WBSchedule -Policy $FullBUPol -Schedule
$Schedule | Out-Null
# Create a credential
$U = 'administrator@reskit.org'
$P = ConvertTo-SecureString -String 'Pa$$w0rd'
-AsPlainText -Force
$Cred = New-Object -TypeName
System.Management.Automation.PSCredential `
    -ArgumentList $U, $P
# Create target and add to backup policy
Invoke-Command -ComputerName SRV1 -Credential $cred `
    -ScriptBlock {
    New-Item -Path 'C:Backup' `
        -ItemType Directory
    New-SmbShare -Name Backup -Path 'C:Backup' `
        -FullAccess "$Env:USERDOMAINdomain admins"
}
$Target = New-WBBackupTarget -NetworkPath 'SRV1Backup' `
    -Credential $Cred
Add-WBBackupTarget -Policy $FullBUPol -Target $Target `
    -Force | Out-Null
# Get and set volume to backup
$DisktoBackup = Get-WBDisk | Select-Object -First 1
$Volume = Get-WBVolume -Disk $DisktoBackup
Add-WBVolume -Policy $FullBUPol -Volume
$Volume | Out-Null
# Add BMR to policy
Add-WBBareMetalRecovery -Policy $FullBUPol
# Set policy
Set-WBPolicy -Policy $FullBUPol -Force
# Start the backup
Start-WBBackup -Policy $FullBUPol -Force

# Part b

# initial part of this recipe - use MMC as shown in the boo, then...
# 1. After creating the new VM
Get-VM -Name FS1A
Get-VM -Name FS1A | Select-Object -ExpandProperty HardDrives
Get-VM -Name FS1A | Select-Object -ExpandProperty DVDDrives

# 2. Start the VM using Start-VM and observe the VM status:
Start-VM -Name FS1A
Get-VM -Name FS1A

# recovery is via te gui - see the book

# 19. Once the FS1A computer has finished the recovery operation and has rebooted,
# you can logon to the newly restored computer. Open a PowerShell console and
# verify you have recovered the host by the recovery by typing:
HostName
Get-NetIPConfiguration