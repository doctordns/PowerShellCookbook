# Recipe 11-1 - Secure SMB Server

# Step 1 - Retreive SMB Server settings
Get-SmbServerConfiguration

# Step 2 - Turn off SMB1 
Set-SmbServerConfiguration -EnableSMB1Protocol $false `
                           -Confirm:$false

# Step 3 - Turn on SMB signing and encryption
Set-SmbServerConfiguration -RequireSecuritySignature $true `
                           -EnableSecuritySignature $true `
                           -EncryptData $true `
                           -Confirm:$false

# Step 4 - Turn off default server and workstations shares 
Set-SmbServerConfiguration -AutoShareServer $false `
                           -AutoShareWorkstation $false `
                           -Confirm:$false

# Step 5 - turn off server announcementw
Set-SmbServerConfiguration -ServerHidden $true `
                           -AnnounceServer $false `
                           -Confirm:$false

# Step 6 - restart the service with the new configuration
Restart-Service lanmanserver



<# undo and set back to defults

Get-SMBShare foo* | remove-SMBShare -Confirm:$False

Set-SmbServerConfiguration -EnableSMB1Protocol $true `
                           -RequireSecuritySignature $false `
                           -EnableSecuritySignature $false `
                           -EncryptData $False `
                           -AutoShareServer $true `
                           -AutoShareWorkstation $false `
                           -ServerHidden $False `
                           -AnnounceServer $True
Restart-Service lanmanserver
#>





get-smbshare

New-SmbShare -Name foo -Path c:\foo

Get-SmbShareAccess foo

Get-SmbServerConfiguration

