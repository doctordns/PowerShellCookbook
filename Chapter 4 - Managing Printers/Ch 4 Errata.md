# Errata - Chapter 4 - Managing Printers


### Page 123, step 3
Should read:  

    Add-PrinterDriver -Name 'NEC Color MultiWriter Class Driver' `
                      -PrinterEnvironment 'Windows x64'

### Page 123, step 4
Should read:  

    Add-Printer -Name SGCP1 `
                -DriverName 'NEC Color MultiWriter Class Driver' `
                -Portname 'Sales_Color'

### Page 123, step 6
Should read:      

    Get-PrinterPort -Name Sales_Color |
        Format-Table -Property Name, Description,
                               PrinterHostAddress, PortNumber `
                     -Autosize
    Get-PrinterDriver -Name NEC* |
        Format-Table -Property Name, Manufacturer,
                               DriverVersion, PrinterEnvironment
    Get-Printer -ComputerName PSRV -Name SGCP1 |
        Format-Table -Property Name, ComputerName,
                               Type, PortName, Location, Shared


### Page 123, step 6
Should read:      
