# Recipe 9-3 - Accessing SMB Shares
# Updated to remove backticks

# 1. Discover the existing shares and access rights:
Get-SmbShare -Name * |
    Get-SmbShareAccess |
        Sort-Object -Property Name |
            Format-Table -GroupBy Name

# 2. Share a folder:
New-SmbShare -Name foo -Path C:\foo

# 3. Update the share's description:
$SMHT = @{
    Name         = 'foo'
    Description  = 'Foo share for IT'
    Confirm     =  $False
}
Set-SmbShare - @SMHT

# 4. Set the folder enumeration mode
$SHT = @{
    Name                  = 'foo'
    FolderEnumerationMode = 'AccessBased'
    Confirm               = $false
}
Set-SMBShare @SHT

# 5. Set the encryption on the foo share:
$EHT = @{
    Name         = 'foo'
    EncryptData  = $true
    Confirm      = $false
}
Set-SmbShare @EHT

# 6. Set and view share security:
$RHT = @{
    Name = 'foo'
    AccountName = 'Everyone'
    Confirm     = $false
}
Revoke-SmbShareAccess  @RHT | Out-Null
$GHT1 = @{
    Name        = 'foo'
    AccessRight = 'Read'
    AccountName = 'Reskit\ADMINISTRATOR'
    ConFirm     = $false
}
Grant-SmbShareAccess @GHT1 | Out-Null
$GHT2 = @{
    Name        = 'foo'
    AccessRight = 'Full'
    AccountName = 'NT Authority\SYSTEM'
    ConFirm     = $false
}
Grant-SmbShareAccess @GHT2 | Out-Null
$GHT3 = @{
    Name        = 'foo'
    AccessRight = 'Full'
    AccountName = 'CREATOR OWNER'
    ConFirm     = $false
}
Grant-SmbShareAccess @GHT3 | Out-Null
$GHT3 = @{
    Name        = 'foo'
    AccessRight = 'Read'
    AccountName = 'IT Team'
    ConFirm     = $false
}
Grant-SmbShareAccess @GHT3 | Out-Null
$GHT4 = @{
    Name        = 'foo'
    AccessRight = 'Full'
    AccountName = 'IT Management'
    ConFirm     = $false
}
Grant-SmbShareAccess @GHT4| Out-Null

    # 7. Review share access:
Get-SmbShareAccess