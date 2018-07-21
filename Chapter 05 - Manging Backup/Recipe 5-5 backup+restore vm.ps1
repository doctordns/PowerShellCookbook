# Recipe 5-5 - Backup and restore a Hyper-V VM
# Run this on the Hyper-V Host that runs the DC1 VM.

# 1. Look at the VM
Get-VM DC1

# 2. Create the backup using Wbadmin
Wbadmin Start Backup -BackupTarget:C:\ -HyperV:'DC1'

# 3. Examine the log file created by this backup
$P = 'Path C:\WINDOWS\Logs\WindowsServerBackup\' +
     'Backup-29-12-2016_23-56-53.log'
Get-Content $P

# 4. Look at what was created
Get-ChildItem -Path C:\WindowsImageBackup
Get-ChildItem -Path C:\WindowsImageBackup\cookham22

# 5. Look at VM:
$Vm        = Get-Vm -Name DC1
$VmCfgLoc  = $vm.ConfigurationLocation
$VmCfgOK   = Test-Path $VmCfgLoc
$vmDskLoc  = ($vm.HardDrives).path
$VmDskOK   = Test-Path $VmDskLoc
"Location of Config Information: {0}" -f $VmCfgLoc
"Exists: {0}" -f $VmCfgOK
"Location of DC1 Hard Drive    : {0}" -f $vmDskLoc
"Exists: {0}" -f $VmDskOK

# 6.Remove the VM from Hyper-V and see results:
Stop-VM   -Name DC1 -TurnOff -Force
Remove-VM -Name DC1 -Force
Get-VM    -Name DC1
"Location of Config Information: {0}" -f $VmCfgLoc
"Exists: {0}" -f $VmCfgOK
"Location of DC1 Hard Drive    : {0}" -f $vmDskLoc
"Exists: {0}" -f $VmDskOK
Get-VM -Name DC1

# 7. Now restore the VM from backup
$Backupversions = Wbadmin.Exe Get Versions -backuptarget:C: 
$Version        = $Backupversions | 
                     Select-String 'Version identifier' |
                         Select-Object -Last 1
$VID            = $Version.Line.Split(' ')[2]
$Cmd  = "& Wbadmin.Exe Start Recovery -Itemtype:Hyperv -Items:DC1 "
$Cmd += "-Version:$VID -AlternateLocation -RecoveryTarget:C:\Recovery"
Invoke-Expression -Command $Cmd

# 8. And observe the results
Start-VM -Name DC1
Get-VM -Name DC1
$Vm = Get-Vm -Name DC1
$VmCfgLoc  = $Vm.ConfigurationLocation
$VmCfgOK   = Test-Path $VmCfgLoc
$vmDskLoc  = ($Vm.HardDrives).path
$VmDskOK   = Test-Path $VmDskLoc
"Location of Config Information: {0}" -f $VmCfgLoc
"Exists: {0}" -f $VmCfgOK
"Location of DC1 Hard Drive    : {0}" -f $vmDskLoc
"Exists: {0}" -f $VmDskOK