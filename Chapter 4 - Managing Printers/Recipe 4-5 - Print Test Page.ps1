# Recipe 4-5 Print a test page

# 1. Get printer objects from WMI:
$Printers = Get-CimInstance -ClassName Win32_Printer

# 2. Display the number of printers defined:
"{0} Printers defined on this system" -f $Printers.count

# 3.Get our Sales Group printer
$Printer = $Printers | Where-Object name -eq "SGCP1"

# 4. Display details
$Printer | Format-Table -AutoSize

# 5. Print a test page
Invoke-CimMethod -InputObject $Printer `
                 -MethodName PrintTestPage