# Recipe 5-7 - Restore Registry From Backup

# 1. You begin this recipe by creating keys/values in the registry:
$TopKey = 'HKLM:SoftwarePackt'
$SubKey = 'Recipe5-7'
$RegPath = Join-Path -Path $TopKey -ChildPath $SubKey
New-Item -Path $TopKey
New-Item -Path $RegPath
$IPHT = @{
   Type = 'String'
   Name  = 'RecipeName'
   Path  = $RegPath `
   Value 'Recipe 5-7'

}
Set-ItemProperty -Type String -Name RecipeName
-Path $RegPath `
-Value 'Recipe 5-7'
Get-Item -Path $RegPath

# 2. Create a full backup of this server by first removing any existing backup policy
#    then creating a new backup policy with a schedule:
If (Get-WBPolicy) {
    Remove-WBPolicy -All -Force]
    $FullBUPol = New-WBPolicy
    $Schedule = '06:00'

# 3. Create and set the backup schedule:
$SHT = @{
    Policy   = $FullBUPol
    Schedule = $Schedule
}
Set-WBSchedule  @SHT | Out-Null

# 4. Set the backup target:
$BuDisk = Get-WBDisk |
    Where-Object Properties -eq 'ValidTarget'
$BuVol = $BuDisk | Get-WBVolume
$Target = New-WBBackupTarget -Volume $BuVol | Out-Null
Add-WBBackupTarget -Policy $FullBUPol -Target $Target -Force |
    Out-Null

# 5. Set the disk to backup and specify full metal recovery:
$DisktoBackup = Get-WBDisk |
    Select-Object -First 1
$Volume = Get-WBVolume -Disk $DisktoBackup
Add-WBVolume -Policy $FullBUPol -Volume $Volume |
    Out-Null
Add-WBBareMetalRecovery -Policy $FullBUPol
Add-WBSystemState -Policy $FullBUPol

# 6. Start the backup:
Start-WBBackup -Policy $FullBUPol -Force

# 7. Examine applications that were backed up and can be restored:
$Backup = Get-WBBackupSet |
    Where-Object BackupTarget -Match 'E:' |
        Select -Last 1
$Backup.Application

# 8. Restore the registry
# And note the backticks
$Version = $Backup.VersionId
Wbadmin Start Recovery -Version:$Version `
    -ItemType:App `
    -Items:Registry `
    -Recoverytarget:E:

# 9. See what WSB restored:
    Get-ChildItem -Path E:Registry

# 10. Once the recovery is complete, you can examine what was recovered
# Remaining part of this recipe is done in Regedit Except for the last step:


# 14. Look at the restored hive
Get-ChildItem -Path HKLM:\OldSoftwareHive\Packt
