# Recipe 6-1 - Configure and set Backup Policy

# 0 just in case
Install-WindowsFeature -Name Windows-Server-Backup
If (Get-WBPolicy) { Remove-WBPolicy -All -Force }

# 1. Create a new empty backup policy
$Pol = New-WBPolicy

# 2. View the (empty) policy
$Pol

# 3. Add a schedule to the backup policy
$Schedule = '06:00'
Set-WBSchedule -Policy $POL -Schedule $Schedule

# 4. View disks to be backed up
Get-WBDisk | 
    Format-Table -Property DiskName, DiskNumber,
                           FreeSpace, Properties

# 5. Use disk 1 as backup target and set it in policy
$TargetDisk = Get-WBDisk | 
    Where-Object Properties -Match 'ValidTarget' |
        Select-Object -First 1
$Target = New-WBBackupTarget -Disk $TargetDisk `
             -Label 'Recipe 6-1' `
             -PreserveExistingBackups $true
Add-WBBackupTarget -Policy $Pol -Target $Target -Force

# 6. Add VolumesToBackup
$DisktoBackup = Get-WBDisk | Select-Object -First 1
$Volume = Get-WBVolume -Disk $DisktoBackup |
    Where-Object FileSystem -eq 'NTFS'
Add-WBVolume -Policy $Pol -Volume $Volume

# 7. View the completed policy
$Pol

# 8. Make policy active
# NOTE: THIS FORMATS DISK 1!!
Set-WBPolicy -Policy $Pol -Force

# 9. Set drive letter:
$Drive = Get-CimInstance -Class Win32_volume |
             Where-Object Label -EQ 'Recipe 6-1'
Set-CimInstance -InputObject $Drive -Property @{DriveLetter='Q:'}
Get-CimInstance -Class Win32_Volume |
    Where-Object Label -EQ 'Recipe 6-1' |
        Format-Table -Property Driveletter, Label

# 10. View active policy
Get-WBPolicy

# 10. View the summary
Get-WBSummary

#  Create a manual backup now
$MBPol = Get-WBPolicy -Editable
Start-WBBackup -Policy $MBPol


<#
#To reset:
Remove-WBPolicy -all -force

#>
