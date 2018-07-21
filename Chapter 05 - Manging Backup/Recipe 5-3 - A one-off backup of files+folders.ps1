# Recipe 6-3 - Initiage a manual backup

# 0. Clear backup policy if it exists
If (Get-WBPolicy) { Remove-WBPolicy -All }

# Also, just in case
New-Item -Path C:\Foo -ItemType Directory -ErrorAction SilentlyContinue
Get-Date | Out-File -FilePath C:\Foo\d1.txt
Get-Date | Out-File -FilePath C:\Foo\d2.txt


# 1. Create and populate a new one-off backup policy to backup just two folders:
$OOPol      = New-WBPolicy
$Fsn1 = 'C:\Foo'
$FSpec1     = New-WBFileSpec -FileSpec $Fsn1
$Fsn2 = 'C:\Users\administrator\Documents'
$FSpec2     = New-WBFileSpec -FileSpec $Fsn2
Add-WBFileSpec -Policy $OOPol -FileSpec $FSpec1,$FSpec2
$Volume     = Get-WBVolume -VolumePath Q:
$Target     = New-WBBackupTarget -Volume $Volume
Add-WBBackupTarget -Policy $OOPol -Target $Target

# 2. Execute the one-off backup polich
Start-WBBackup -Policy $OOPol

# 3. Find the VHDX file and mount it
$ImagePath     = 'Q:\*.vhdx'
$BUFile        = Get-ChildItem $imagepath -Recurse
$ImageFilename = $BUFile.FullName
$MRHT = @{
    StorageType = 'VHDX'
    ImagePath   = $ImageFilename
    PassThru    = $true
  }
Mount-DiskImage @MRHT 

# 4. If there is a label, get it, otherwise set it to T:
$Vol = Get-CimInstance -Classname Win32_volume |
    Where-Object {(-Not $_.DriveLetter) -and ($_.Label -notmatch 'Recipe')}
If ($Vol.DriveLetter)
 { $DriveLetter = $Vol.DriveLetter}
Else
 { $DriveLetter = 'T:'
   $Vol | Set-CimInstance -Property @{DriveLetter=$driveletter}
 }


# 5. Now View it in Explorer
Explorer $Driveletter