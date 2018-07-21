# Recipe 6-4 Restore files and folders from a backukp.

# 0. Create a full backup policy and Start it
If (Get-WBPolicy) {Remove-WBPolicy -All -Force}
If (-NOT (Test-Path C:\foo\d1.txt)) {
   'D1' |  Out-File c:\foo\d1.txt}
If (-NOT (Test-Path C:\foo\d2.txt)) {
   'D1' |  Out-File c:\foo\d2.txt}
If (-NOT (Test-Path C:\foo\d31.txt)) {
   'D1' |  Out-File c:\foo\d3.txt}
$FullBUPol  = New-WBPolicy
$Schedule   = '06:00'
Set-WBSchedule -Policy $FullBUPol -Schedule $Schedule | Out-Null
$TargetDisk = Get-WBDisk | 
                  Where-Object Properties -match 'ValidTarget' |
                      Select-Object -First 1
$Target     = New-WBBackupTarget -Disk $TargetDisk `
             -Label 'Recipe 6-3' `
             -PreserveExistingBackups $true
Add-WBBackupTarget -Policy $FullBUPol -Target $Target -Force |
     Out-Null
$DisktoBackup = Get-WBDisk | Select-Object -First 1
$Volume       = Get-WBVolume -Disk $DisktoBackup
Add-WBVolume   -Policy $FullBUPol -Volume $Volume | Out-Null
Set-WBPolicy   -Policy $FullBUPol -Force
Start-WBBackup -Policy $FullBUPol -Force
$Drive = Get-CimInstance -Class Win32_Volume |
             Where-Object Label -Match 'Recipe'
Set-CimInstance -InputObject $Drive `
                -Property @{DriveLetter='Q:'}
# Main script starts here

# 1. Get Recent backup job then view the job's items
$Job = Get-WBJob -Previous 1
$Job
$Job | Select-Object -ExpandProperty JobItems

# 2. Get Backupset information
$BUSet = Get-WBBackupSet | Where-Object Versionid -eq $Job.VersionId
$BUSet

# 3. Recover a single file
If (-Not (Test-Path C:\Recovered)) 
    {New-Item -Path C:\Recovered -ItemType Directory}
$File       = 'C:\Foo\D1.txt'
$TargetPath = 'C:\Recovered\'
$WBFHT = @{
    BackupSet  = $BUSet
    SourcePath = $File
    TargetPath = $TargetPath
    Option     = 'CreateCopyIfExists'
    Force      = $true
}
Start-WBFileRecovery @$WBFHT
# See results
Get-ChildItem $TargetPath

# 4 Recover an entire folder structure
If (-Not (Test-Path C:\Recovered2)) 
    {New-Item -Path C:\Recovered2 -ItemType Directory}
$SourcePath = 'C:\Foo\'
$TargetPath = 'C:\Recovered2\'
$WBFHT = @{
    BackupSet   = $BUSet
    SourcePath  = $SourcePath
    TargetPath  = $TargetPath 
    Recursive   = $true
    Force       = $true
}
Start-WBFileRecovery @WBFHT
Get-ChildItem C:\Recovered2\foo

# There's more
Get-WBJob -Previous 2