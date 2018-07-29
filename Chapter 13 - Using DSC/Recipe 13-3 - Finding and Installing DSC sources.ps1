# Recipe 13-3 - Finding and installing DSC Resources

# 1. Find available repositories
Get-PSRepository

#  1. See what DSC resources you can find
Find-DscResource -Repository 'PSGallery'

# 3. See what IIS resources might exist
Find-DscResource | Where-Object modulename - 'IIS'

# 4. Examine the xWebAdministration resource
Find-DscResource | Where-Object modulename -eq 'xWebAdministration'

# 5. Install the xWebAdministration module (on SRV1)
Install-Module -Name 'xWebAdministration' -Force

# 6. See local module details:
Get-Module -Name xWebAdministration -ListAvailable

# 7. See what is in the module
Get-DscResource -Module xWebAdministration