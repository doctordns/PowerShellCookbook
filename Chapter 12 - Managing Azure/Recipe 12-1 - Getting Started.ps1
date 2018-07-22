# Recipe 12-1 Getting started with Azure

#  1. Find core Azure Modules
Find-Module -Name Azure, AzureRM

# 2. Install ARM cmdlets
Install-Module -Name AzureRM -Force

# 3. Discover Azure modules
$HT = @{ Label ='Cmdlets'
         Expression = {(Get-Command -module $_.name).count}}
Get-Module Azure* -ListAvailable | 
    Sort {(Get-command -Module $_.name).count} -Descending |
       Format-Table -Property Name,Version,Author,$HT -AutoSize

# 4. Find Azure AD cmdlets
Find-Module AzureAD |
    Format-Table -Property Name,Version,Author -AutoSize -Wrap

# 5. Download the AzureADModule
Install-Module -Name AzureAD -Force

# 6. Discover Azure AD Module
$FTHT = @{
    Property = 'Name, Version, Author, Description'
    AutoSize = $true
    Wrap     = $true
}
Get-Module -Name AzureAD -ListAvailable |
  Format-Table @FTHT

# 7. Login To Azure
$Subscription = Login-AzureRmAccount

# 8. Get Azure Subscription details
$SubID = $Subscription.CONTEXT.Subscription.SubscriptionId
Get-AzureRmSubscription -SubscriptionId $SubId |
       Format-List *

# 9. Get Azure Locations
Get-AzureRmLocation | Sort-Object Location |
    Format-Table Location, Displayname

# 10 Get Azure Environments
Get-AzureRmEnvironment |
    Format-Table -Property name, ManagementPortalURL
