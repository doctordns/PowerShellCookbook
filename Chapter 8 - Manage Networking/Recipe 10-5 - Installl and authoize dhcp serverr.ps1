# Recipe 10-6 - Setup Install and Authorise a DHCP server.
# Run on DC1

# 1. Install the DHCP Feature
Install-WindowsFeature -Name DHCP `
                   -IncludeManagementTools

