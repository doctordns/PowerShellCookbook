# Recipe 4-9
# Setup Branch Office Direct Printing

# 1. Set Branch Office Printing for SGBRCP1 printer:
$Printer = 'SGBRCP1'
$PServer = 'PSRV'
Set-Printer -Name $Printer -ComputerName $PServer -RenderingMode BranchOffice

# 2. Get Printing Mode:
$Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Print\Printers\SGBRCP1\PrinterDriverData'
$BROPrint = (Get-ItemProperty $Key).EnableBranchOfficePrinting
# 3. Now display value:
If ($BROPrint) 
   {'Branch Office Printing Enabled'}
else
   {'Branch Office Printing Disabled'}

# 4. Now Reset to default
Set-Printer -Name $printer -ComputerName $PServer -RenderingMode SSR

# 5. Get Value from registry and re-display value:
$Key = 'HKLM:\SYSTEM\CurrentControlSet\Control\Print\Printers\SGBRCP1\PrinterDriverData'
$BROPrint = (Get-ItemProperty $Key).EnableBranchOfficePinting
If ($BROPrint) 
   {'Branch Office Printing Enabled'}
else
   {'Branch Office Printing Disabled'}


###
