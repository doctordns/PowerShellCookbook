# Chapter 4 - Managing Printers
# Recipe 4-2 Publish printer to AD
# Run on Print Server

# 1. Find printer to publish 
$Printer = Get-Printer -Name 'SGCP1'

# 2. Observe publication status
$Printer | Format-Table Name, Published

# 3. Publish the printer to AD
$Printer | Set-Printer -Published $true `
              -Location '10th floor 10E4'

# 4 Observe publication status
Get-Printer -Name 'SGCP1' |
     Format-Table Name, Published, Location





<# remove publication - for testing
Get-Printer -Name 'SGCP1' |Set-Printer -Published $false
#>