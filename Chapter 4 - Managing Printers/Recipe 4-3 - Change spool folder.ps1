# Recipe 4-3 Change Printer Spool folder path
# The Default printer spool path is: C:\Windows\system32\spool\PRINTERS

# 1. Load the System.Printing assembly
Add-Type -AssemblyName System.Printing

# 2. Define required permissions (ability to administrate the server)
$Permissions = [System.Printing.PrintSystemDesiredAccess]::AdministrateServer

# 3. Create Print Server object with required permissions
$Ps = New-Object System.Printing.PrintServer -ArgumentList $Permissions

# 4. Update the default spool folder path
$Newpath = 'C:\spool'
$Ps.DefaultSpoolDirectory = $Newpath 

# 5. Commit the change
$Ps.Commit()

# 6. Restart the Spooler
Restart-Service -Name Spooler

# 7. View the results
New-Object System.Printing.PrintServer  |
     Format-Table Name, DefaultSpoolDirectory

# Here is another way

Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Print\Printers"

Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Print\Printers"`
     DefaultSpoolDirectory -value 'C:\SpoolViaRegistry'


