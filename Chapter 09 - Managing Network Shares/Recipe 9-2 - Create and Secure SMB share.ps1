# Recipe 11-2 Create an SMB Share

# Step 1 - Discover existing shares and access rights
Get-SmbShare -Name * | 
    Get-SmbShareAccess |
        Format-Table -GroupBy Name

# Step 2 - Share a folder 
New-SmbShare -Name foo -Path C:\foo

# Step 3 - Update the share to have a description
Set-SmbShare -Name foo -Description 'Foo share for IT' -Confirm:$False

# Step 4 - Set folder enumeration mode
Set-SMBShare -Name foo -FolderEnumerationMode AccessBased `
             -Confirm:$false

# Step 5 - Set encryption on for foo share
Set-SmbShare –Name Foo -EncryptData $true `
             -Confirm:$false

# Step 6 - Set and View share security
Revoke-SmbShareAccess -Name foo `
                      -AccountName 'Everyone' `
                      -Confirm:$false | Out-Null
Grant-SmbShareAccess  -Name foo `
                      -AccessRight Read `
                      -AccountName 'Reskit\ADMINISTRATOR' `
                      -ConFirm:$false | Out-Null
Grant-SmbShareAccess  -Name foo `
                      -AccessRight Full `
                      -AccountName 'NT Authority\SYSTEM'  `
                      -Confirm:$False | Out-Null
Grant-SmbShareAccess  -Name foo `
                      -AccessRight Full `
                      -AccountName 'CREATOR OWNER' `
                      -Confirm:$false | Out-Null
Grant-SmbShareAccess  -Name foo `
                      -AccessRight Read `
                      -AccountName 'IT Team' `
                      -Confirm:$false | Out-Null
Grant-SmbShareAccess  -Name foo `
                      -AccessRight Full `
                      -AccountName 'IT Management' `
                      -Confirm:$false | Out-Null

# Step 7 - Review share access
Get-SmbShareAccess -Name foo



<# reset the shares etc
Get-smbshare foo | remove-smbshare -Confirm:$false

#>
