# Recipe 6-2 Examine the results of backup job
#
# Assumes recipe 5-1 has been executed and that this recipe
# runs after 6:00 the day after.

# 1. See Current Policy
Get-WBPolicy

# 2. View overview of what's on the target disk
Get-ChildItem -Path Q: -Recurse -Depth 3 -Directory

# 3. See details of a backup
Explorer (Get-ChildItem Q:\WindowsImageBackup\psrv\ -Directory |
              Select-Object -First 1).FullName

# 4. Look inside the VHD
$BFolder = (Get-ChildItem Q:\WindowsImageBackup\psrv\ -Directory |
              Select-Object -First 1).FullName
$BFile = Get-ChildItem -Path $BFolder\*.vhdx
Mount-DiskImage -ImagePath $BFile.FullName
Explorer T:

# 5. Get details of the last backukp job:
Get-WBJob -Previous 1


